import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionChecker {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Checks and requests all required permissions
  /// Returns a Map containing permission status information
  static Future<Map<String, dynamic>> checkAndRequestPermissions() async {
    try {
      // Check platform version for Android
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        // Request manage external storage permission (Android 11+)
        if (sdkInt >= 30) { // Android 11+ (API 30+)
          final storageStatus = await Permission.manageExternalStorage.request();
          if (storageStatus.isDenied) {
            return {
              'granted': false,
              'permissionType': 'android.permission.MANAGE_EXTERNAL_STORAGE',
            };
          }
        } else {
          // For older Android versions, fall back to regular storage permission
          final storageStatus = await Permission.storage.request();
          if (storageStatus.isDenied) {
            return {
              'granted': false,
              'permissionType': 'android.permission.READ_EXTERNAL_STORAGE',
            };
          }
        }

        // Request notification permission for Android 13+ (SDK 33+)
        final notificationStatus = await Permission.notification.request();
        if (notificationStatus.isDenied) {
          return {
            'granted': false,
            'permissionType': 'android.permission.POST_NOTIFICATIONS',
          };
        }

        // If everything is granted, return success
      }

      // iOS specific permissions
      else if (Platform.isIOS) {
        final photosStatus = await Permission.photos.request();

        if (photosStatus.isDenied) {
          return {
            'granted': false,
            'permissionType': 'photos',
          };
        }
      }

      // All permissions granted
      return {
        'granted': true,
        'permissionType': null,
      };
    } catch (e) {
      print('Error checking permissions: $e');
      return {
        'granted': false,
        'permissionType': null,
      };
    }
  }

  /// Opens the app settings page
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
