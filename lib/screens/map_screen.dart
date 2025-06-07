import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:media_hub/screens/project_details_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter:
            const LatLng(28.6139, 77.2090), // Center the map over London
        initialZoom: 5.5,
      ),
      children: [
        TileLayer(
          // Bring your own tiles
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
          userAgentPackageName: 'com.example.app', // Add your app identifier
          // And many more recommended properties!
        ),
        MarkerLayer(
          markers: [
            Marker(
              rotate: true,
              point: LatLng(10.8505, 76.2711),
              width: 30,
              height: 30,
              child: GestureDetector(
                  onTap: () {
                    Get.to(() => ProjectDetailsScreen(
                          projectName: 'Project Alpha',
                        ));
                  },
                  child: Container(
                      child: Icon(Icons.location_on,
                          color: Colors.red, size: 40))),
            ),
            Marker(
              rotate: true,
              point: LatLng(13.0827, 80.2707),
              width: 30,
              height: 30,
              child: GestureDetector(
                  onTap: () {
                    Get.to(() => ProjectDetailsScreen(
                          projectName: 'Project Beta',
                        ));
                  },
                  child: Container(
                      child: Icon(Icons.location_on,
                          color: Colors.yellow, size: 40))),
            ),
            Marker(
              rotate: true,
              point: LatLng(12.9716, 77.5946),
              width: 30,
              height: 30,
              child: GestureDetector(
                  onTap: () {
                    Get.to(() => ProjectDetailsScreen(
                          projectName: 'Project Gamma',
                        ));
                  },
                  child: Container(
                      child: Icon(Icons.location_on,
                          color: Colors.green, size: 40))),
            ),
            Marker(
              rotate: true,
              point: LatLng(17.3850, 78.4867),
              width: 30,
              height: 30,
              child: GestureDetector(
                  onTap: () {
                    Get.to(() => ProjectDetailsScreen(
                          projectName: 'Project Delta',
                        ));
                  },
                  child: Container(
                      child: Icon(Icons.location_on,
                          color: Colors.blue, size: 40))),
            ),
            Marker(
              rotate: true,
              point: LatLng(19.0760, 72.8777),
              width: 30,
              height: 30,
              child: GestureDetector(
                  onTap: () {
                    Get.to(() => ProjectDetailsScreen(
                          projectName: 'Project Epsilon',
                        ));
                  },
                  child: Container(
                      child: Icon(Icons.location_on,
                          color: Colors.black, size: 40))),
            ),
          ],
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
