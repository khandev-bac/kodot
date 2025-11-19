import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

Future<List<AssetEntity>> fetchAllImages(BuildContext context) async {
  final PermissionState ps = await PhotoManager.requestPermissionExtend();
  if (!ps.isAuth) {
    if (!ps.isAuth) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Permission Required"),
          content: Text("Please allow access to your photos."),
          actions: [
            TextButton(
              onPressed: () => PhotoManager.openSetting(),
              child: Text("Open Settings"),
            ),
          ],
        ),
      );
      return [];
    }
  }

  List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
    type: RequestType.image,
    hasAll: true,
  );

  if (albums.isEmpty) return [];

  // Fallback: get the first album if "all" not found
  AssetPathEntity allPhotos = albums.firstWhere(
    (album) => album.isAll,
    orElse: () => albums.first,
  );

  // Fetch all images (or limit if you want)
  List<AssetEntity> images = await allPhotos.getAssetListPaged(
    page: 0,
    size: 1000,
  );
  return images;
}
