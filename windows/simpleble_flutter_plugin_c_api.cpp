#include "include/simpleble_flutter/simpleble_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "simpleble_flutter_plugin.h"

void SimplebleFlutterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  simpleble_flutter::SimplebleFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
