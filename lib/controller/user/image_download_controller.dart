import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageDownloadController extends GetxController {
  final Map<String, RxBool> _downloadStates = {};

  RxBool isDownloading(String url) {
    return _downloadStates.putIfAbsent(url, () => false.obs);
  }

  Future<void> downloadPhoto(String photoUrl) async {
    final downloading = isDownloading(photoUrl);
    try {
      downloading.value = true;

      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }

        if (!status.isGranted) {
          Get.defaultDialog(
            title: "Permission Required",
            content:
                const Text("Please enable file access permission in settings."),
            confirm: ElevatedButton(
              onPressed: () {
                openAppSettings();
                Get.back();
              },
              child: const Text("Open Settings"),
            ),
            cancel: TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
          );
          return;
        }
      }

      final dir = await getDownloadDirectory();
      final filePath =
          '${dir.path}/downloaded_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final dio = Dio();
      await dio.download(
        photoUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
                "Downloading: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      Get.snackbar(
        "Download Complete", "Photo saved to:\n$filePath",
         backgroundColor: Colors.blue.shade50,
        colorText: Colors.blue.shade800,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),

        );
    } catch (e) {
      Get.snackbar("Download Failed", e.toString());
    } finally {
      downloading.value = false;
    }
  }

  Future<Directory> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      Directory dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return dir;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }
}
