
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:media_hub/screens/video_player_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideosGrid extends StatelessWidget {
  final String projectName;

  const VideosGrid({super.key, required this.projectName});

  /// 🔍 Fetch video URLs from Firestore
  Future<List<String>> fetchVideoUrls() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('projects')
        .doc(projectName)
        .collection('videos')
        .orderBy('uploadedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc['url'] as String).toList();
  }

  /// 🧩 Generate thumbnail for a given video URL
  Future<Uint8List?> _generateThumbnail(String url) async {
    try {
      return await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 25,
      );
    } catch (e) {
      print('Thumbnail generation failed: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchVideoUrls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No videos uploaded.',style: TextStyle(color: Colors.white),));
        }

        final videoUrls = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: videoUrls.length,
          itemBuilder: (context, index) {
            final videoUrl = videoUrls[index];
            return FutureBuilder<Uint8List?>(
              future: _generateThumbnail(videoUrl),
              builder: (context, thumbSnapshot) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
    ),
  );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: thumbSnapshot.hasData
                          ? DecorationImage(
                              image: MemoryImage(thumbSnapshot.data!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Colors.grey[300],
                    ),
                    child: const Center(
                      child: Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}