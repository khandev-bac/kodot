import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/service/PostService.dart';
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
  bool isPosting = false;

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
          backgroundColor: Color(0xFF161616),
          title: Text(
            "Permission Required",
            style: TextStyle(color: Color(0xFFE8E8E8)),
          ),
          content: Text(
            "Please allow access to your photos.",
            style: TextStyle(color: Color(0xFF606060)),
          ),
          actions: [
            TextButton(
              onPressed: () => PhotoManager.openSetting(),
              child: Text(
                "Open Settings",
                style: TextStyle(color: Color(0xFF606060)),
              ),
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
      backgroundColor: Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: Color(0xFF606060),
                size: 20,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Share Your Project",
              style: TextStyle(
                color: Color(0xFFE8E8E8),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              "Show what you built",
              style: TextStyle(
                color: Color(0xFF606060),
                fontWeight: FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Show grid if no image selected
              if (selectedImage == null)
                Expanded(
                  child: images.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedImage02,
                                color: Color(0xFF404040),
                                size: 64,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No photos found",
                                style: TextStyle(
                                  color: Color(0xFFE8E8E8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Grant permission to access photos",
                                style: TextStyle(
                                  color: Color(0xFF606060),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(8),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xFF2A2A2A),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: FutureBuilder<Uint8List?>(
                                      future: asset.thumbnailDataWithSize(
                                        ThumbnailSize(200, 200),
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.data != null) {
                                          return Stack(
                                            children: [
                                              Image.memory(
                                                snapshot.data!,
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.transparent,
                                                      Color(
                                                        0xFF000000,
                                                      ).withOpacity(0.3),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        return Container(
                                          color: Color(0xFF161616),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),

              // Show image preview & form if selected
              if (selectedImage != null)
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image preview
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: FutureBuilder<Uint8List?>(
                            future: selectedImage!.thumbnailDataWithSize(
                              ThumbnailSize(600, 600),
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data != null) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              }
                              return Container(
                                height: 300,
                                color: Color(0xFF161616),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF606060),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24),

                        // Change image button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImage = null;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color(0xFF2A2A2A),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedRefresh,
                                  color: Color(0xFF606060),
                                  size: 14,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Change image",
                                  style: TextStyle(
                                    color: Color(0xFF606060),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Caption input
                        _buildSectionLabel("Add Caption"),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF161616),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF2A2A2A),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: captionController,
                            maxLines: 3,
                            style: TextStyle(
                              color: Color(0xFFE8E8E8),
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              hintText: "What's in this screenshot?",
                              hintStyle: TextStyle(color: Color(0xFF404040)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(14),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Tags input
                        _buildSectionLabel("Add Tags"),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF161616),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF2A2A2A),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: tagController,
                            style: TextStyle(color: Color(0xFFE8E8E8)),
                            decoration: InputDecoration(
                              hintText: "design, ux, app... (comma separated)",
                              hintStyle: TextStyle(color: Color(0xFF404040)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(14),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedGrid02,
                                  color: Color(0xFF404040),
                                  size: 16,
                                ),
                              ),
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
                        ),
                        SizedBox(height: 16),

                        // Show tags
                        if (tags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: tags
                                .map(
                                  (tag) => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Color(0xFF2A2A2A),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "#$tag",
                                          style: TextStyle(
                                            color: Color(0xFF606060),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              tags.remove(tag);
                                            });
                                          },
                                          child: HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedCancelCircle,
                                            color: Color(0xFF404040),
                                            size: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),

                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Floating Post Button
          if (selectedImage != null)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A1A1A), Color(0xFF161616)],
                  ),
                  border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isPosting
                        ? null
                        : () async {
                            if (selectedImage == null) return;
                            final file = await selectedImage!.file;
                            if (file == null) return;

                            setState(() => isPosting = true);

                            final Postservice postservice = Postservice();
                            final response = await postservice.CreateImagePost(
                              image: file,
                              caption: captionController.text.trim(),
                              tags: tags,
                            );

                            setState(() => isPosting = false);

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
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 50,
                      child: Center(
                        child: isPosting
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF606060),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedShare04,
                                    color: Color(0xFFE8E8E8),
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Post Project",
                                    style: TextStyle(
                                      color: Color(0xFFE8E8E8),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Color(0xFFE8E8E8),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }
}
