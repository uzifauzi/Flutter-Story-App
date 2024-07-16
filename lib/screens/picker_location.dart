import 'package:final_subs_story_app/provider/maps_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PickerLocationScreen extends StatelessWidget {
  const PickerLocationScreen({
    super.key,
    required this.lat,
    required this.lon,
  });

  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context) {
    return Consumer<MapsProvider>(
      builder: (ctx, maps, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () async {
                  // context.pop(ctx.read<MapsProvider>().currentLatLon);
                  context.pop(maps.currentLatLon);
                },
                icon: const Icon(
                  Icons.arrow_back,
                )),
            title: Text(
              "Ubah Lokasi Story",
              style: GoogleFonts.quicksand()
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(children: [
            GoogleMap(
              myLocationEnabled: true,
              markers: maps.markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lon),
                zoom: 10,
              ),
              onMapCreated: (controller) {
                maps.mapController = controller;
              },
              onTap: (argument) {
                maps.defineNewMarker(
                  lat: argument.latitude,
                  lon: argument.longitude,
                );
              },
            ),
            Positioned(
              bottom: 120,
              right: 16,
              child: FloatingActionButton(
                child: const Icon(Icons.my_location),
                onPressed: () async {
                  maps.getMyLocation();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: maps.addressController,
                  enabled: false,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}
