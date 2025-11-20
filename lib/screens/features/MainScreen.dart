import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/models/AppSuccessModel.dart' show AppSuccessMessage;
import 'package:kodot/models/CreatePostModel.dart';
import 'package:kodot/service/PostService.dart';
import 'package:kodot/widget/CustomFeed.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  late Future<AppSuccessMessage<List<Createpostmodel?>>?> futurePosts;
  final Postservice postservice = Postservice();
  @override
  void initState() {
    super.initState();
    futurePosts = postservice.GetAllPosts(); // load FEED
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
      body: FutureBuilder<AppSuccessMessage<List<Createpostmodel?>>?>(
        future: futurePosts,
        builder: (context, snapshot) {
          // Loading animation
          if (!snapshot.hasData) {
            return Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500), // ↓ faster spin
                onEnd: () {},
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 6.28, // full circle
                    child: CircularProgressIndicator(
                      backgroundColor: MatrixRainColors.emerald400,
                      color: MatrixRainColors.bgPrimary,
                    ),
                  );
                },
              ),
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
                  author: "Khan_dev",
                  avatarUrl:
                      "https://lh3.googleusercontent.com/a/ACg8ocKVirZ-9X3PWGkurNdBF-jMJALVPyIY6cImWel8UszRk1Vvcw=s96-c",
                  caption: post.caption ?? "",
                  code: post.code ?? "",
                  tags: post.tags ?? [],
                  imageUrl: post.imageUrl ?? "",
                  githubUrl: "",
                  instagramUrl: "",
                  xUrl: "",
                  linkedinUrl: "",
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
