import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhotosController extends GetxController {
  final RxList<String> photoUrls = <String>[].obs;
  final RxBool isLoading = true.obs;

  void loadPhotos(String projectName) async {
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectName)
          .collection('photos')
          .orderBy('uploadedAt', descending: true)
          .get();

      photoUrls.value =
          snapshot.docs.map((doc) => doc['url'] as String).toList();
    } catch (e) {
      print("Error fetching photos: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
