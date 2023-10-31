#ifndef FLUTTER_PLUGIN_SIMPLEBLE_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_SIMPLEBLE_FLUTTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/basic_message_channel.h>

#include <simpleble/SimpleBLE.h>
#include "simpleble_flutter.g.h"
#include <memory>

namespace simpleble_flutter
{
    using flutter::EncodableMap;
    using flutter::EncodableValue;

    class SimplebleFlutterPlugin : public flutter::Plugin, public SimpleBlePlatformChannel
    {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

        SimplebleFlutterPlugin();

        virtual ~SimplebleFlutterPlugin();

        // Disallow copy and assign.
        SimplebleFlutterPlugin(const SimplebleFlutterPlugin &) = delete;
        SimplebleFlutterPlugin &operator=(const SimplebleFlutterPlugin &) = delete;

        void Initialize();
        void setConnectionCallbacks(SimpleBLE::Peripheral peripheral);
        SimpleBleScanResult ConvertToSimpleBleScanResultAndCache(SimpleBLE::Peripheral peripheral);
        SimpleBLE::Peripheral findDevice(const std::string &device_id);
        static void SuccessCallback() {}
        static void ErrorCallback(const FlutterError &error)
        {
            std::cout << "ErrorCallback: " << error.message() << std::endl;
        }

        // SimpleBlePlatformChannel implementation:
        ErrorOr<bool> IsBluetoothAvailable() override;
        std::optional<FlutterError> StartScan() override;
        std::optional<FlutterError> StopScan() override;
        std::optional<FlutterError> Connect(const std::string &device_id) override;
        std::optional<FlutterError> Disconnect(const std::string &device_id) override;
        ErrorOr<flutter::EncodableList> DiscoverServices(const std::string &device_id) override;
        std::optional<FlutterError> SetNotifiable(
            const std::string &device_id,
            const std::string &service,
            const std::string &characteristic,
            int64_t ble_input_property) override;
        ErrorOr<std::vector<uint8_t>> ReadValue(
            const std::string &device_id,
            const std::string &service,
            const std::string &characteristic) override;
        std::optional<FlutterError> WriteValue(
            const std::string &device_id,
            const std::string &service,
            const std::string &characteristic,
            const std::vector<uint8_t> &value,
            int64_t ble_output_property) override;
        ErrorOr<int64_t> RequestMtu(
            const std::string &device_id,
            int64_t expected_mtu) override;
    };

} // namespace simpleble_flutter

#endif // FLUTTER_PLUGIN_SIMPLEBLE_FLUTTER_PLUGIN_H_
