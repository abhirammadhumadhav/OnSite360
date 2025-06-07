import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_hub/common/widgets/photos_grid.dart';
import 'package:media_hub/common/widgets/videos_grid.dart';
import 'package:media_hub/controller/user/add_datas_controller.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final addDataController = Get.put(AddDatasController());
  final String projectName;
  ProjectDetailsScreen({super.key, required this.projectName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            "Project Details",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                text: 'Videos',
              ),
              Tab(text: 'Photos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VideosGrid(
              projectName: projectName,
            ),
            PhotosGrid(
              projectName: projectName,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addDataController.addData(projectName);
          },
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
