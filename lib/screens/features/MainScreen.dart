import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/models/AppSuccessModel.dart' show AppSuccessMessage;
import 'package:kodot/models/FeedModel.dart';
import 'package:kodot/service/PostService.dart';
import 'package:kodot/widget/CustomFeed.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  late Future<AppSuccessMessage<List<FeedPostModel?>>?> futurePosts;
  final Postservice postservice = Postservice();
  @override
  void initState() {
    super.initState();
    futurePosts = postservice.GetAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customBlack,
        title: Text(
          "Kodot",
          style: TextStyle(
            color: AppColors.customWhite,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder<AppSuccessMessage<List<FeedPostModel?>>?>(
        future: futurePosts,
        builder: (context, snapshot) {
          // Loading animation
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.customWhite),
            );
          }

          // Error
          if (snapshot.data == null || snapshot.data!.data == null) {
            return const Center(
              child: Text(
                "Failed to load posts",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final posts = snapshot.data!.data!;

          return ListView.builder(
            physics: const BouncingScrollPhysics(), // Instagram style
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index]!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: MatrixRainPostWidget(
                  author: post.username,
                  avatarUrl: post.profile,
                  caption: post.caption ?? "",
                  code: post.code ?? "",
                  tags: post.tags,
                  imageUrl: post.imageUrl ?? "",
                  githubUrl: post.socials.github,
                  instagramUrl: post.socials.instagram,
                  xUrl: "",
                  linkedinUrl: post.socials.linkedIn,
                  emailUrl: "",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
