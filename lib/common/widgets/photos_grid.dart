
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:media_hub/screens/image_viewer_screen.dart';

class PhotosGrid extends StatelessWidget {
  final String projectName;

  const PhotosGrid({super.key, required this.projectName});

  /// 🔍 Fetch photo URLs from Firestore
 Future<List<String>> fetchPhotoThumbnailUrls() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('projects')
      .doc(projectName)
      .collection('photos')
      .orderBy('uploadedAt', descending: true)
      .get();

  return snapshot.docs
      .map((doc) => doc.data()['thumbnailUrl'] as String? ?? doc.data()['url'] as String)
      .toList();
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchPhotoThumbnailUrls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No photos uploaded.',style: TextStyle(color: Colors.white),));
        }

        final photoUrls = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: photoUrls.length,
          itemBuilder: (context, index) {
            final photoUrl = photoUrls[index];
            return GestureDetector(
              onTap: (){
                Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewerScreen(imageUrl: photoUrl),
        ),
      );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                imageUrl: photoUrl,
                imageBuilder: (context, imageProvider) => Image(
                  image: ResizeImage(imageProvider, width: 200), // resize to width 200px
                  fit: BoxFit.cover,
                ),
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, size: 40)),
                ),
              ),
              ),
            );
          },
        );
      },
    );
  }
}