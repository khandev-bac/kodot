import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/models/FeedModel.dart';
import 'package:kodot/service/PostService.dart';
import 'package:kodot/widget/CustomFeed.dart'; // MatrixRainPostWidget

class Postscreenbyid extends StatefulWidget {
  final String postId;

  const Postscreenbyid({super.key, required this.postId});

  @override
  State<Postscreenbyid> createState() => _PostscreenbyidState();
}

class _PostscreenbyidState extends State<Postscreenbyid>
    with SingleTickerProviderStateMixin {
  final Postservice postservice = Postservice();

  bool isLoading = true;
  FeedPostModel? postData;

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    fetchPost();

    // ✨ Smooth fade-in animation
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut,
    );
  }

  Future<void> fetchPost() async {
    final res = await postservice.GetPostId(widget.postId);

    if (res != null && res.data != null && res.data!.isNotEmpty) {
      setState(() {
        postData = res.data!.first;
        isLoading = false;
      });

      fadeController.forward(); // ⭐ Start fade animation
    } else {
      setState(() {
        isLoading = false;
        postData = null;
      });
    }
  }

  @override
  void dispose() {
    fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customBlack,
      appBar: AppBar(
        title: const Text("Post"),
        backgroundColor: AppColors.customBlack,
        foregroundColor: AppColors.customWhite,
        elevation: 0,
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: isLoading
            ? _buildLoading()
            : postData == null
            ? _buildNotFound()
            : _buildPostBody(),
      ),
    );
  }

  /// ⭐ Elegant loading animation with better UX
  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),
          Text(
            "Fetching post...",
            style: TextStyle(
              color: AppColors.customWhite.withOpacity(0.6),
              fontFamily: "Jost",
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  /// ⭐ Beautiful message if the post doesn’t exist
  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.customWhite.withOpacity(0.5),
            size: 60,
          ),
          const SizedBox(height: 12),
          Text(
            "Post not found",
            style: TextStyle(
              color: AppColors.customWhite.withOpacity(0.6),
              fontFamily: "Jost",
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  /// ⭐ Final perfect UI with padding + animation
  Widget _buildPostBody() {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.customWhite.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.customWhite.withOpacity(0.08)),
          ),

          /// ⭐ Your MatrixRainPostWidget placed cleanly inside
          child: MatrixRainPostWidget(
            author: postData!.username,
            avatarUrl: postData!.profile,
            caption: postData!.caption ?? "",
            code: postData!.code ?? "",
            tags: postData!.tags ?? [],

            githubUrl: postData!.socials.github ?? "",
            instagramUrl: postData!.socials.instagram ?? "",
            xUrl: "",
            linkedinUrl: "",
            emailUrl: "",
          ),
        ),
      ),
    );
  }
}
