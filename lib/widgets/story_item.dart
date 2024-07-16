import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/responses/stories_response.dart';
import '../utils/utils.dart';

class StoryItem extends StatelessWidget {
  const StoryItem({required this.story, super.key});

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 350,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12, left: 5, right: 5),
        decoration: BoxDecoration(
          color: const Color(0xfffffefe),
          borderRadius: BorderRadius.circular(18),
          // boxShadow: const [
          //   BoxShadow(
          //     offset: Offset(0.5, 0.1),
          //     blurRadius: 3.0,
          //   )
          // ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              story.name,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatDateTime(story.createdAt),
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                story.photoUrl,
                height: 300,
                width: 500,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ));
  }
}
