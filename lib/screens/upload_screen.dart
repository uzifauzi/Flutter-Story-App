import 'dart:io';

import 'package:final_subs_story_app/utils/flavor_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data/responses/api_response.dart';
import '../provider/auth_provider.dart';
import '../provider/maps_provider.dart';
import '../provider/picture_provider.dart';
import '../provider/story_provider.dart';
import '../utils/enum.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final descriptionController = TextEditingController();
  double latitude = 0.0;
  double longitude = 0.0;
  String? address;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Consumer<PictureProvider>(
            builder: (context, picture, _) {
              return IconButton(
                icon: const Icon(Icons.close),
                onPressed: () async {
                  picture.clearImage();
                  context.goNamed('home');
                },
              );
            },
          ),
          title: Text('Upload Story',
              style: GoogleFonts.quicksand()
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        body: Consumer<PictureProvider>(
          builder: (context, picture, child) {
            return buildFormStory(context, picture);
          },
        ),
      ),
    );
  }

  Widget buildFormStory(BuildContext ctx, PictureProvider picture) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: picture.imagePath == null
                    ? Container(
                        color: Colors.black,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      )
                    : _showImage(),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () => picture.openCameraView(),
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () => picture.openGalleryView(),
                        icon: const Icon(
                          Icons.image,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (FlavorConfig.instance.flavor == FlavorType.paid)
            Consumer<MapsProvider>(
              builder: (context, map, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tampilkan koordinat di sini
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.titleLocation,
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextField(
                            controller: map.addressController,
                            enabled: false,
                            maxLines: null,
                            style:
                                GoogleFonts.quicksand().copyWith(fontSize: 11),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue[500],
                      ),
                      child: IconButton(
                        onPressed: () async {
                          final currentLat =
                              map.currentLatLon?.latitude.toString() ?? '0.0';
                          final currentLon =
                              map.currentLatLon?.longitude.toString() ?? '0.0';

                          final result =
                              await ctx.pushNamed('picker', pathParameters: {
                            'lat': currentLat,
                            'lon': currentLon,
                          });

                          if (result != null) {
                            final data = result as LatLng;
                            setState(() {
                              latitude = data.latitude;
                              longitude = data.longitude;
                            });
                            map.defineNewMarker(
                                lat: data.latitude, lon: data.longitude);
                          }
                        },
                        icon: const Icon(Icons.location_on),
                      ),
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 15),
          Text(
            AppLocalizations.of(context)!.descriptionTitle,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: 5,
            controller: descriptionController,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.descriptionText,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            validator: (value) {
              if (value == null) {
                return 'Deskripsi tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Consumer3<AuthProvider, PictureProvider, StoryProvider>(
              builder: (context, auth, picture, story, _) {
            return GestureDetector(
              onTap: () => onUploadStory(context, auth, picture, story),
              child: Container(
                width: MediaQuery.sizeOf(context).width / 2,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: story.state == ResultState.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.uploadBtn,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void onUploadStory(
    BuildContext ctx,
    AuthProvider auth,
    PictureProvider picture,
    StoryProvider story,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(ctx);
    if (story.state == ResultState.error && context.mounted) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(story.message!)));
    }

    final token = auth.token;

    final imagePath = picture.imagePath;
    final imageFile = picture.imageFile;
    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await story.compressImage(bytes);

    final ApiResponse response = await story.uploadStory(
      token: token,
      fileName: fileName,
      bytes: newBytes,
      desc: descriptionController.text,
      lat: latitude,
      lon: longitude,
    );

    if (response.error == false && ctx.mounted) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(response.message)));
      await story.refreshPage();
      picture.clearImage();
      ctx.goNamed('home');
    }
  }

  Widget _showImage() {
    final imagePath = context.read<PictureProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath?.toString() ?? '',
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath?.toString() ?? ''),
            fit: BoxFit.contain,
          );
  }
}
