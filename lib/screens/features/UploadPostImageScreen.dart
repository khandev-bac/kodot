import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/service/PostService.dart';
import 'package:kodot/widget/CustomButton.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadPostImageScreen extends StatefulWidget {
  const UploadPostImageScreen({super.key});

  @override
  State<UploadPostImageScreen> createState() => _UploadPostImageScreenState();
}

class _UploadPostImageScreenState extends State<UploadPostImageScreen> {
  List<AssetEntity> images = [];
  AssetEntity? selectedImage;

  final TextEditingController captionController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    // Request permission
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
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
      return;
    }

    // Get albums
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: true,
    );

    if (albums.isEmpty) return;

    // Get "All Photos" or fallback
    final AssetPathEntity allPhotos = albums.firstWhere(
      (album) => album.isAll,
      orElse: () => albums.first,
    );

    // Get all images
    final List<AssetEntity> fetchedImages = await allPhotos.getAssetListPaged(
      page: 0,
      size: 1000,
    );

    setState(() {
      images = fetchedImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.customDarkBlue,
        title: Text(
          "New Post",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.customWhite,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Show grid if no image selected
              if (selectedImage == null)
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(4),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final asset = images[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImage = asset;
                          });
                        },
                        child: FutureBuilder<Uint8List?>(
                          future: asset.thumbnailDataWithSize(
                            ThumbnailSize(200, 200),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data != null) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                            return Container(color: Colors.grey.shade900);
                          },
                        ),
                      );
                    },
                  ),
                ),

              // Show caption & tags if image selected
              if (selectedImage != null)
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<Uint8List?>(
                          future: selectedImage!.thumbnailDataWithSize(
                            ThumbnailSize(400, 400),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data != null) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                            return Container(
                              height: 200,
                              color: Colors.grey.shade900,
                            );
                          },
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: captionController,
                          style: TextStyle(color: AppColors.customWhite),
                          decoration: InputDecoration(
                            hintText: "Add a caption…",
                            hintStyle: TextStyle(color: Color(0xFFD3DAD9)),
                            border: InputBorder.none,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: tagController,
                          style: TextStyle(color: AppColors.customWhite),
                          decoration: InputDecoration(
                            hintText: "Add tags (comma separated)…",
                            hintStyle: TextStyle(color: Color(0xFFD3DAD9)),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              setState(() {
                                tags.addAll(
                                  value.split(",").map((e) => e.trim()),
                                );
                                tagController.clear();
                              });
                            }
                          },
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: tags
                              .map(
                                (tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor: AppColors.customBlack,
                                  labelStyle: TextStyle(
                                    color: AppColors.customWhite,
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      tags.remove(tag);
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Floating Post Button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Visibility(
              visible: selectedImage != null,
              child: Custombutton(
                text: "Post",
                onTap: () async {
                  if (selectedImage == null) return;
                  final file = await selectedImage!.file;
                  if (file == null) return;
                  // Loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Center(
                      child: CircularProgressIndicator(
                        color: AppColors.customWhite,
                      ),
                    ),
                  );
                  final Postservice postservice = Postservice();
                  final response = await postservice.CreateImagePost(
                    image: file,
                    caption: captionController.text.trim(),
                    tags: tags,
                  );
                  Navigator.pop(context);
                  if (response == null || response.data == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response!.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
