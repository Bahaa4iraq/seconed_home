import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../provider/auth_provider.dart';
import '../../../../provider/student/provider_maps.dart';
// import 'package:geoloator_apple/geolocator_apple.dart';
// import 'package:geoloator_android/geolocator_android.dart';
// import 'package:background_location/background_location.dart';

class ConnectSocket {
  final MapStudentProvider mapStudentProvider = Get.put(MapStudentProvider());
  final SocketDataProvider _socketDataProvider = Get.put(SocketDataProvider());
  final MainDataGetProvider _mainDataGetProvider = Get.put(MainDataGetProvider());
  initSocket() {
    IO.Socket socket = _socketDataProvider.socket;
    if(!socket.connected){
      socket.connect();
    }else{
      location(socket);
    }
    socket.onConnect((_socket) {
      if (socket.connected) {
        //getLocation(socket);
        socket.emit("join_room",_mainDataGetProvider.mainData['account']["account_driver"]);
        location(socket);
      }
    });

    socket.on('geo', (_data){
      mapStudentProvider.addData(_data);
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void location(_socket) async {

    // Map? _userData =  box.read('_userData');
    // const LocationSettings locationSettings = LocationSettings(
    //   accuracy: LocationAccuracy.high,
    //   distanceFilter: 100,
    // );
    late LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          // forceLocationManager: true,
          intervalDuration: const Duration(seconds: 1),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
            "تم تفعيل تتبع الموقع في الخلفية",
            notificationTitle: "تتبع الموقع",
            enableWakeLock: true,
          )
      );
    }
    else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.otherNavigation,
        distanceFilter: 100,
        //pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: true,
      );
    }
    else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      Map _data = {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "speed": position.speed,
        // "id": "sama_${_userData!['_id']}",
      };
      mapStudentProvider.addData(_data);
      _socket.emit('geo', _data);
    });
    // var geolocator = Geolocator();
    // var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    //
    // // ignore: unused_local_variable
    // // ignore: cancel_subscriptions
    // StreamSubscription<Position> positionStream = Geolocator.getPositionStream().listen((Position position) {
    //   position == null ? print('Unknown') : sendData(position.latitude, position.longitude, position.speed);
    // });
  }

  // getLocation(_socket) async {
  //   await BackgroundLocation.stopLocationService();
  //   await BackgroundLocation.setAndroidNotification(
  //       title: "تتبع الموقع الحالي");
  //   await BackgroundLocation.startLocationService();
  //   location(_socket);
  // }
}
