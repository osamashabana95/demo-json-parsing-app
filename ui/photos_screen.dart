import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../provider/photos_provider.dart';
import 'widgets/photo_list_item.dart';

class PhotosScreen extends ConsumerWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoListState = ref.watch(photoListProvider);
    final photoListNotifier = ref.watch(photoListProvider.notifier);
    final photosAsyncValue = ref.watch(photosProvider);

    final photosU = photoListState.photos;
    final currentPage = photoListState.currentPage;
    final itemsPerPage = 10;
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    final displayedPhotos =
        photosU.sublist(startIndex, endIndex.clamp(0, photosU.length));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Osama Photo List',
          style: GoogleFonts.sofadiOne(color: Colors.white),
        ),
      ),
      body: photosAsyncValue.when(
        data: (photos) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: photoListState.sortBy,
                        dropdownColor: Colors.grey[900],
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        isExpanded: true,
                        underline: Container(),
                        style: GoogleFonts.lato(color: Colors.white),
                        items: ['title', 'albumId']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          photoListNotifier.sortPhotos(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Filter by Album ID',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          photoListNotifier.filterPhotos(int.tryParse(value));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: displayedPhotos.length,
                  itemBuilder: (context, index) {
                    final photo = displayedPhotos[index];
                    return PhotoListItem(photo: photo);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentPage > 1
                        ? () {
                            photoListNotifier.changePage(currentPage - 1);
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    '$currentPage',
                    style: GoogleFonts.sofadiOne(color: Colors.white),
                  ),
                  IconButton(
                    onPressed: endIndex < photosU.length
                        ? () {
                            photoListNotifier.changePage(currentPage + 1);
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
