import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';

class AddDatasController extends GetxController {
  void addData(String projectName) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp4',
        'jpg',
        'png',
        'jpeg',
        'svg',
        '3gp',
        'flv',
        'mkv'
      ],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ext = result.files.single.extension!;
      final isVideo = ext == 'mp4';

      Get.snackbar(
        "Uploading",
        "Uploading your file...",
        backgroundColor: Colors.blue.shade50,
        colorText: Colors.blue.shade800,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );

      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('projects')
            .child(projectName)
            .child(isVideo ? 'videos' : 'photos')
            .child('$fileName.$ext');

        final uploadTask = await ref.putFile(file);

        if (uploadTask.state == TaskState.success) {
          final downloadUrl = await ref.getDownloadURL();

          String? thumbnailUrl;

          // Generate and upload thumbnail if it's a photo
          if (!isVideo) {
            thumbnailUrl = await _generateAndUploadPhotoThumbnail(
                file, projectName, fileName);
          }

          await FirebaseFirestore.instance
              .collection('projects')
              .doc(projectName)
              .collection(isVideo ? 'videos' : 'photos')
              .add({
            'url': downloadUrl,
            'uploadedAt': Timestamp.now(),
            'fileName': '$fileName.$ext',
            if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
          });

          Get.snackbar(
            "Success",
            "${isVideo ? "Video" : "Photo"} uploaded",
            backgroundColor: Colors.green.shade50,
            colorText: Colors.green.shade800,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          Get.snackbar("Error", "Upload failed. Try again.");
        }
      } catch (e) {
        print('Upload error: $e');
        Get.snackbar("Error", e.toString());
      }
    }
  }

// Helper method to generate and upload photo thumbnail
  Future<String?> _generateAndUploadPhotoThumbnail(
      File file, String projectName, String fileName) async {
    try {
      // Read image bytes
      final bytes = await file.readAsBytes();

      // Decode image
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      // Resize to thumbnail size (e.g., 100x100)
      final thumbnail = img.copyResize(image, width: 100);

      // Encode thumbnail to JPEG
      final thumbnailBytes = img.encodeJpg(thumbnail, quality: 70);

      // Upload thumbnail
      final thumbRef = FirebaseStorage.instance
          .ref()
          .child('projects')
          .child(projectName)
          .child('photos')
          .child('thumbnails')
          .child('$fileName.jpg');

      final uploadTask =
          await thumbRef.putData(Uint8List.fromList(thumbnailBytes));
      if (uploadTask.state == TaskState.success) {
        final thumbnailUrl = await thumbRef.getDownloadURL();
        return thumbnailUrl;
      } else {
        return null;
      }
    } catch (e) {
      print('Thumbnail generation/upload error: $e');
      return null;
    }
  }
}
