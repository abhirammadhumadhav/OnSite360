import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_hub/controller/user/auth_controller.dart';
import 'package:media_hub/screens/project_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> allProjects = [
    'Project Alpha',
    'Project Beta',
    'Project Gamma',
    'Project Delta',
    'Project Epsilon',
  ];

  List<String> filteredProjects = [];

  @override
  void initState() {
    super.initState();
    filteredProjects = List.from(allProjects);

    searchController.addListener(() {
      filterProjects();
    });
  }

  void filterProjects() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProjects = allProjects
          .where((project) => project.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.find<AuthController>().signOut();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    )),
              ],
            ),
            TextField(
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredProjects.isEmpty
                  ? const Center(child: Text('No projects found.',style: TextStyle(color: Colors.white),))
                  : ListView.builder(
                      itemCount: filteredProjects.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(filteredProjects[index]),
                            leading:
                                const Icon(Icons.folder, color: Colors.black),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Get.to(() => ProjectDetailsScreen(
                                  projectName: filteredProjects[index]));
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
