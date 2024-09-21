import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/photo.dart';

class PhotoListItem extends StatelessWidget {
  const PhotoListItem({Key? key, required this.photo}) : super(key: key);

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: photo.url,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  photo.title,
                  style: GoogleFonts.lato(color: Colors.white),
                ),
                Text(
                  'Album ID: ${photo.albumId}',
                  style: GoogleFonts.lato(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
