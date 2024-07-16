import 'package:final_subs_story_app/provider/story_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';

import '../data/responses/stories_response.dart';
import '../utils/flavor_config.dart';
import '../utils/utils.dart';

class DetailStoryContent extends StatelessWidget {
  const DetailStoryContent({required this.story, super.key});

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.name,
                style: GoogleFonts.quicksand()
                    .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              //LOCATION
              if (FlavorConfig.instance.flavor == FlavorType.paid)
                Consumer<StoryProvider>(
                  builder: (context, value, _) {
                    if (story.lat != null && story.lon != null) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GoogleMap(
                            markers: value.markers,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(story.lat!, story.lon!),
                              zoom: 10,
                            )),
                      );
                    } else {
                      return const Text('Lokasi tidak ditemukan');
                    }
                  },
                ),
              const SizedBox(
                height: 10,
              ),
              Text(
                formatDateTime(story.createdAt),
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  story.photoUrl,
                  height: 300,
                  width: 500,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Deskripsi:',
                style: GoogleFonts.quicksand()
                    .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                story.description,
                style: GoogleFonts.quicksand().copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getAddress(double lat, double lon) async {
    final latLng = LatLng(lat, lon);
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street;

    return street ?? ' ';
  }
}
