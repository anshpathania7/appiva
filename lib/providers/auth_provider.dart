import 'dart:io';

import 'package:appiva/models/log_model.dart';
import 'package:appiva/repository/auth_repository.dart';
import 'package:appiva/repository/logs_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends ChangeNotifier {
  //
  bool allowedGps = false;
  bool _shouldOpenSettings = false;
  File? image;
  Position? geoPosition;
  bool loadingState = true;
  bool isLoggingIn = false;

  void init() async {
    await performLogout();

    await checkPermissions();
    loadingState = false;
    notifyListeners();
  }

  set _updateLoggingState(bool v) {
    isLoggingIn = v;
    notifyListeners();
  }

  Future<void> performLogout() async {
    AuthRepository().logout();
  }

  Future<bool> performLogin() async {
    _updateLoggingState = true;
    bool succesfullyExecuted = false;
    final succesfullyLoggedIn = await AuthRepository().loginWithGoogle();
    if (succesfullyLoggedIn) {
      final imgUrl = await LogsRepository().uploadImage(imageFile: image!);
      final log = LogModel(
        userImgUrl: imgUrl!,
        addedAt: DateTime.now(),
        geoLocation: geoPosition!.toJson(),
      );
      await LogsRepository().addLog(logModel: log);
      resetFields();

      succesfullyExecuted = true;
    }
    _updateLoggingState = false;
    return succesfullyExecuted;
  }

  bool checkIfAllFieldsSet() {
    return image != null && geoPosition != null;
  }

  void resetFields() {
    image = null;
    notifyListeners();
  }

  void pickImage() async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    image = File(xFile!.path);
    notifyListeners();
  }

  void getLocationPermission() async {
    _shouldOpenSettings
        ? await Geolocator.openAppSettings()
        : await Geolocator.requestPermission();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    final locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      allowedGps = true;
    } else {
      _shouldOpenSettings =
          locationPermission == LocationPermission.deniedForever;
      allowedGps = false;
    }
    if (allowedGps) {
      geoPosition = await Geolocator.getCurrentPosition();
    }
    notifyListeners();
  }
}
