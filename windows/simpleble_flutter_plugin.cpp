#include "simpleble_flutter_plugin.h"

#include <windows.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>
#include <sstream>
#include <thread>
#include <map>
#include <algorithm>
#include <iomanip>

#include <simpleble/SimpleBLE.h>
#include "simpleble_flutter.g.h"
#include "simpleble_enums.h"

namespace simpleble_flutter
{
  using simpleble_flutter::ErrorOr;
  using simpleble_flutter::SimpleBleCallbackChannel;
  using simpleble_flutter::SimpleBlePlatformChannel;

  SimpleBLE::Adapter adapter;
  std::unique_ptr<SimpleBleCallbackChannel> callbackChannel;
  std::map<std::string, SimpleBLE::Peripheral> peripherals;

  void SimplebleFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarWindows *registrar)
  {
    auto plugin = std::make_unique<SimplebleFlutterPlugin>();
    SimpleBlePlatformChannel::SetUp(registrar->messenger(), plugin.get());
    callbackChannel = std::make_unique<SimpleBleCallbackChannel>(registrar->messenger());
    registrar->AddPlugin(std::move(plugin));
  }

  SimplebleFlutterPlugin::SimplebleFlutterPlugin()
  {
    Initialize();
  }

  SimplebleFlutterPlugin::~SimplebleFlutterPlugin() {}

  // Helpers
  void SimplebleFlutterPlugin::Initialize()
  {
    std::vector<SimpleBLE::Adapter> adapters = SimpleBLE::Adapter::get_adapters();
    if (adapters.empty())
    {
      std::cout << "SimpleBleError: No Bluetooth adapters found, Failed to initialize" << std::endl;
      return;
    }
    adapter = adapters[0];
    adapter.set_callback_on_scan_found([this](SimpleBLE::Peripheral peripheral)
                                       { callbackChannel->OnScanResult(
                                             ConvertToSimpleBleScanResultAndCache(peripheral),
                                             SuccessCallback,
                                             ErrorCallback); });

    adapter.set_callback_on_scan_updated([this](SimpleBLE::Peripheral peripheral)
                                         { callbackChannel->OnScanResult(
                                               ConvertToSimpleBleScanResultAndCache(peripheral),
                                               SuccessCallback,
                                               ErrorCallback); });
  }

  SimpleBleScanResult SimplebleFlutterPlugin::ConvertToSimpleBleScanResultAndCache(SimpleBLE::Peripheral peripheral)
  {
    std::vector<uint8_t> manufacturerData;
    for (const auto &pair : peripheral.manufacturer_data())
    {
      manufacturerData.insert(manufacturerData.end(), pair.second.begin(), pair.second.end());
    }
    auto address = peripheral.address();
    auto scanResult = SimpleBleScanResult(address);
    scanResult.set_name(peripheral.identifier());
    scanResult.set_manufacturer_data(manufacturerData);
    scanResult.set_rssi(peripheral.rssi());
    if (peripherals.find(address) == peripherals.end())
    {
      // TODO: set connection callback only when required
      setConnectionCallbacks(peripheral);
      peripherals[address] = peripheral;
    }
    return scanResult;
  }

  SimpleBLE::Peripheral SimplebleFlutterPlugin::findDevice(const std::string &device_id)
  {
    auto it = peripherals.find(device_id);
    if (it == peripherals.end())
    {
      throw std::runtime_error("Device not found");
    }
    return it->second;
  }

  void SimplebleFlutterPlugin::setConnectionCallbacks(SimpleBLE::Peripheral peripheral)
  {
    auto address = peripheral.address();
    // TODO: This is background thread, so we need to call OnConnectionChanged on main thread
    peripheral.set_callback_on_connected([address]()
                                         { callbackChannel->OnConnectionChanged(
                                               address,
                                               static_cast<int>(ConnectionState::connected),
                                               SuccessCallback,
                                               ErrorCallback); });

    peripheral.set_callback_on_disconnected([address]()
                                            { callbackChannel->OnConnectionChanged(
                                                  address,
                                                  static_cast<int>(ConnectionState::disconnected),
                                                  SuccessCallback,
                                                  ErrorCallback); });
  }

  // SimpleBlePlatformChannel implementation.
  ErrorOr<bool> SimplebleFlutterPlugin::IsBluetoothAvailable()
  {
    auto adapters = SimpleBLE::Adapter::get_adapters();
    if (adapters.empty())
    {
      return false;
    }
    return SimpleBLE::Adapter::bluetooth_enabled();
  }

  std::optional<FlutterError> SimplebleFlutterPlugin::StartScan()
  {
    if (adapter.scan_is_active())
      return FlutterError("Scan already active");
    adapter.scan_start();
    return std::nullopt;
  };

  std::optional<FlutterError> SimplebleFlutterPlugin::StopScan()
  {
    adapter.scan_stop();
    return std::nullopt;
  };

  std::optional<FlutterError> SimplebleFlutterPlugin::Connect(const std::string &device_id)
  {
    SimpleBLE::Peripheral peripheral = findDevice(device_id);
    if (peripheral.is_connected())
      return FlutterError("AlreadyConnected", "Device already connected");

    if (!peripheral.is_connectable())
      return FlutterError("NotConnectable", "Device not connectable");

    // TODO: Fix: crashes app if peripherl.connect failed to connect
    std::thread([peripheral]() mutable
                { try {
                  peripheral.connect();
                } catch (const std::exception& e) {
                  std::cout << "ConnectionError: " << e.what() << std::endl;
                } })
        .detach();
    return std::nullopt;
  };

  std::optional<FlutterError> SimplebleFlutterPlugin::Disconnect(const std::string &device_id)
  {
    SimpleBLE::Peripheral peripheral = findDevice(device_id);
    // TODO: Fix: crashes app if peripherl.disconnect failed to disconnect
    std::thread([peripheral]() mutable
                { try {
                  peripheral.disconnect();
                } catch (const std::exception& e) {
                  std::cout << "DiconnectionError: " << e.what() << std::endl;
                } })
        .detach();
    return std::nullopt;
  };

  ErrorOr<flutter::EncodableList> SimplebleFlutterPlugin::DiscoverServices(const std::string &device_id)
  {
    SimpleBLE::Peripheral peripheral = peripherals[device_id];
    std::vector<SimpleBLE::Service> services = peripheral.services();
    // std::cout << "Services found: " << services.size() << std::endl;
    flutter::EncodableList simpleBleServices = flutter::EncodableList();
    for (SimpleBLE::Service service : services)
    {
      flutter::EncodableMap SimpleCharacteristics;
      std::vector<SimpleBLE::Characteristic> characteristics = service.characteristics();
      for (SimpleBLE::Characteristic characteristic : characteristics)
      {
        flutter::EncodableList properties = flutter::EncodableList();
        if (characteristic.can_read())
        {
          properties.push_back(flutter::EncodableValue(static_cast<int>(CharacteristicProperty::read)));
        }
        if (characteristic.can_indicate())
        {
          properties.push_back(flutter::EncodableValue(static_cast<int>(CharacteristicProperty::indicate)));
        }
        if (characteristic.can_notify())
        {
          properties.push_back(flutter::EncodableValue(static_cast<int>(CharacteristicProperty::notify)));
        }
        if (characteristic.can_write_request())
        {
          properties.push_back(flutter::EncodableValue(static_cast<int>(CharacteristicProperty::write)));
        }
        if (characteristic.can_write_command())
        {
          properties.push_back(flutter::EncodableValue(static_cast<int>(CharacteristicProperty::writeWithoutResponse)));
        }
        SimpleCharacteristics[flutter::EncodableValue(characteristic.uuid())] = properties;
      }
      flutter::EncodableMap simpleBleService;
      simpleBleService[flutter::EncodableValue(service.uuid())] = SimpleCharacteristics;
      simpleBleServices.push_back(simpleBleService);
    }

    return simpleBleServices;
  };

  std::optional<FlutterError> SimplebleFlutterPlugin::SetNotifiable(
      const std::string &device_id,
      const std::string &service,
      const std::string &characteristic,
      int64_t ble_input_property)
  {
    SimpleBLE::Peripheral peripheral = findDevice(device_id);
    if (ble_input_property == static_cast<int>(BleInputProperty::disabled))
    {
      peripheral.unsubscribe(service, characteristic);
    }
    else if (ble_input_property == static_cast<int>(BleInputProperty::notification))
    {
      peripheral.notify(service, characteristic, [device_id, characteristic](SimpleBLE::ByteArray payload)
                        { callbackChannel->OnValueChanged(
                              device_id,
                              characteristic,
                              std::vector<uint8_t>(payload.begin(), payload.end()),
                              SuccessCallback,
                              ErrorCallback); });
    }
    else if (ble_input_property == static_cast<int>(BleInputProperty::indication))
    {
      peripheral.indicate(service, characteristic, [device_id, characteristic](SimpleBLE::ByteArray payload)
                          { callbackChannel->OnValueChanged(
                                device_id,
                                characteristic,
                                std::vector<uint8_t>(payload.begin(), payload.end()),
                                SuccessCallback,
                                ErrorCallback); });
    }

    return std::nullopt;
  };

  ErrorOr<std::vector<uint8_t>> SimplebleFlutterPlugin::ReadValue(
      const std::string &device_id,
      const std::string &service,
      const std::string &characteristic)
  {
    SimpleBLE::Peripheral peripheral = findDevice(device_id);
    SimpleBLE::ByteArray value = peripheral.read(service, characteristic);
    std::vector<uint8_t> result = std::vector<uint8_t>(value.begin(), value.end());
    return result;
  };

  std::optional<FlutterError> SimplebleFlutterPlugin::WriteValue(
      const std::string &device_id,
      const std::string &service,
      const std::string &characteristic,
      const std::vector<uint8_t> &value,
      int64_t ble_output_property)
  {
    SimpleBLE::Peripheral peripheral = findDevice(device_id);
    if (ble_output_property == static_cast<int>(BleOutputProperty::withResponse))
    {
      peripheral.write_request(service, characteristic, SimpleBLE::ByteArray(value.begin(), value.end()));
    }
    else
    {
      peripheral.write_command(service, characteristic, SimpleBLE::ByteArray(value.begin(), value.end()));
    }
    return std::nullopt;
  };

  ErrorOr<int64_t> SimplebleFlutterPlugin::RequestMtu(
      const std::string &device_id,
      int64_t expected_mtu)
  {
    SimpleBLE::Peripheral peripheral = findDevice(device_id);
    return peripheral.mtu();
  };

} // namespace simpleble_flutter
