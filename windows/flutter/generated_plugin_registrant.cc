//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <firebase_core/firebase_core_plugin_c_api.h>
#include <geolocator_windows/geolocator_windows.h>
#include <platform_device_id_windows/platform_device_id_windows_plugin.h>
#include <record_windows/record_windows_plugin_c_api.h>
#include <syncfusion_pdfviewer_windows/syncfusion_pdfviewer_windows_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
  GeolocatorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GeolocatorWindows"));
  PlatformDeviceIdWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PlatformDeviceIdWindowsPlugin"));
  RecordWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RecordWindowsPluginCApi"));
  SyncfusionPdfviewerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SyncfusionPdfviewerWindowsPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
