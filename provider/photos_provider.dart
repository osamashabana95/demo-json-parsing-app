import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/photo.dart';
import '../repository/photos_repository.dart';

final photosProvider = FutureProvider<List<Photo>>((ref) async {
  final repository = PhotosRepository();
  final photos = await repository.fetchPhotos();
  return photos;
});

final photoListProvider =
    StateNotifierProvider<PhotoListNotifier, PhotoListState>(
        (ref) => PhotoListNotifier(ref));

class PhotoListState {
  final List<Photo> photos;
  final int currentPage;
  final String sortBy;
  final int? filterAlbumId;

  PhotoListState(
      {required this.photos,
      this.currentPage = 1,
      this.sortBy = 'albumId',
      this.filterAlbumId});

  PhotoListState copyWith(
      {List<Photo>? photos,
      int? currentPage,
      String? sortBy,
      int? filterAlbumId}) {
    return PhotoListState(
        photos: photos ?? this.photos,
        currentPage: currentPage ?? this.currentPage,
        sortBy: sortBy ?? this.sortBy,
        filterAlbumId: filterAlbumId ?? this.filterAlbumId);
  }
}

class PhotoListNotifier extends StateNotifier<PhotoListState> {
  final Ref ref;

  PhotoListNotifier(this.ref) : super(PhotoListState(photos: [])) {
    _init();
  }

  void _init() async {
    final photos = await ref.read(photosProvider.future);
    state = state.copyWith(photos: photos);
  }

  void sortPhotos(String sortBy) {
    state = state.copyWith(sortBy: sortBy, currentPage: 1);
    List<Photo> sortedPhotos = List.from(state.photos);
    sortedPhotos.sort((a, b) {
      if (sortBy == 'title') {
        return a.title.compareTo(b.title);
      } else {
        int albumIdComparison = a.albumId.compareTo(b.albumId);
        if (albumIdComparison == 0) {
          return a.id.compareTo(b.id);
        } else {
          return albumIdComparison;
        }
      }
    });
    state = state.copyWith(photos: sortedPhotos);
  }

  void filterPhotos(int? albumId) {
    state = state.copyWith(
        filterAlbumId: albumId, currentPage: 1, sortBy: 'albumId');

    List<Photo> filteredPhotos = ref
        .read(photosProvider)
        .value!
        .where((photo) => albumId == null || photo.albumId == albumId)
        .toList();
    state = state.copyWith(photos: filteredPhotos);
  }

  void changePage(int page) {
    state = state.copyWith(currentPage: page);
  }
}
