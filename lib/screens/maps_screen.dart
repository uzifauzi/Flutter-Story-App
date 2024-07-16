import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../provider/story_provider.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final initialPosition = const LatLng(-6.8957473, 107.6337669);
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  List<LatLng> storyLocations = [];
  geo.Placemark? placemark;

  @override
  void initState() {
    super.initState();
    initializeMarkers();
  }

  Future<void> initializeMarkers() async {
    final storyProvider = context.read<StoryProvider>();
    await storyProvider.fetchAllStories(location: 1);

    final stories = storyProvider.allStories
        ?.where((story) => story.lat != null && story.lon != null)
        .toList();

    if (stories != null) {
      for (var story in stories) {
        final marker = Marker(
          markerId: MarkerId(story.id),
          position: LatLng(story.lat!, story.lon!),
          infoWindow: InfoWindow(
            title: story.name,
            snippet: story.description,
          ),
          onTap: () async {
            final info =
                await geo.placemarkFromCoordinates(story.lat!, story.lon!);
            final place = info[0];

            setState(() {
              placemark = place;
            });
            mapController.animateCamera(
              CameraUpdate.newLatLngZoom(LatLng(story.lat!, story.lon!), 18),
            );
          },
        );
        markers.add(marker);

        storyLocations.add(LatLng(story.lat!, story.lon!));
      }
    }

    setState(() {});
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Consumer<StoryProvider>(
          builder: (context, story, _) {
            return IconButton(
              onPressed: () {
                story.refreshPage();
                context.goNamed('home');
              },
              icon: const Icon(Icons.arrow_back),
            );
          },
        ),
        title: Text(
          'All Stories Location',
          style: GoogleFonts.quicksand()
              .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Stack(children: [
          GoogleMap(
            markers: markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(
              zoom: 5,
              target: initialPosition,
            ),
            onMapCreated: (controller) async {
              final info = await geo.placemarkFromCoordinates(
                  initialPosition.latitude, initialPosition.longitude);

              final place = info[0];

              setState(() {
                placemark = place;
                mapController = controller;
              });

              final bound =
                  boundsFromLatLngList([initialPosition, ...storyLocations]);
              mapController.animateCamera(
                CameraUpdate.newLatLngBounds(bound, 50),
              );
            },
          ),
          Positioned(
            bottom: 120,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "zoom-in",
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton.small(
                  heroTag: "zoom-out",
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
