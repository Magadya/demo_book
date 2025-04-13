//
//  GoogleMapsApiKey.swift
//  Runner
//
//  Created by Dmitry Magadya on 13.04.25.
//

import Flutter
import GoogleMaps

public class GoogleMapsApiKeyPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "google_maps_api_key", binaryMessenger: registrar.messenger())
    let instance = GoogleMapsApiKeyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "setApiKey" {
      if let args = call.arguments as? Dictionary<String, Any>,
         let apiKey = args["apiKey"] as? String {
        GMSServices.provideAPIKey(apiKey)
        result(true)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "API key not provided", details: nil))
      }
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
