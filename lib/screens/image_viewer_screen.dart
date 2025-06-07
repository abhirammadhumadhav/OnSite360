import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:media_hub/controller/user/image_download_controller.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  ImageViewerScreen({super.key, required this.imageUrl});
  final ImageDownloadController _imageDownloadController =
      Get.put(ImageDownloadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            PhotoView(
              imageProvider: NetworkImage(imageUrl),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Obx(() {
                final isDownloading =
                    _imageDownloadController.isDownloading(imageUrl);
                return FloatingActionButton(
                  backgroundColor: Colors.black87,
                  onPressed: isDownloading.value
                      ? null
                      : () => _imageDownloadController.downloadPhoto(imageUrl),
                  child: isDownloading.value
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Icon(Icons.download, color: Colors.white),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
