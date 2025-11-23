import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/models/AppSuccessModel.dart';
import 'package:kodot/models/FeedModel.dart';
import 'package:kodot/screens/features/CodePostScreen.dart';
import 'package:kodot/screens/features/UploadPostImageScreen.dart';
import 'package:kodot/service/PostService.dart';
import 'package:kodot/widget/CustomCircle.dart';
import 'package:kodot/widget/CustomFeed.dart';

class Postscreen extends StatefulWidget {
  const Postscreen({super.key});

  @override
  State<Postscreen> createState() => _PostscreenState();
}

class _PostscreenState extends State<Postscreen> {
  late Future<AppSuccessMessage<List<FeedPostModel?>>?> currentPost;
  final Postservice postservice = Postservice();

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  List<FeedPostModel> post = [];

  void _loadPost() {
    setState(() {
      currentPost = postservice.GetAllUserPost();
    });
  }

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.customDarkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "New Post",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ListTile(
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedCode,
                  color: AppColors.customWhite,
                ),
                title: Text(
                  "Post Today’s Snippet.",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const Codepostscreen()),
                  );
                },
              ),
              ListTile(
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedImage02,
                  color: AppColors.customWhite,
                ),
                title: Text(
                  "Share a Snapshot of Your Project",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const UploadPostImageScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your posts",
          style: TextStyle(color: AppColors.customWhite),
        ),
        backgroundColor: AppColors.customBlack,
      ),
      body: FutureBuilder<AppSuccessMessage<List<FeedPostModel?>>?>(
        future: currentPost,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.customWhite),
            );
          }

          // unwrap response
          final data = snapshot.data!.data!;

          post = data.where((e) => e != null).cast<FeedPostModel>().toList();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                post.isEmpty
                    ? Center(
                        child: Text(
                          "Nothing you have shared",
                          style: TextStyle(
                            fontFamily: "Jost",
                            fontSize: 18,
                            color: AppColors.customWhite,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: post.length,
                        itemBuilder: (context, index) {
                          final FeedPostModel postData = post[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: MatrixRainPostWidget(
                              author: postData.username,
                              avatarUrl: postData.profile,
                              caption: postData.caption ?? "",
                              code: postData.code ?? "",
                              tags: postData.tags ?? [],
                              // imageUrl: postData.profile ?? "",
                              githubUrl: postData.socials.github,
                              instagramUrl: postData.socials.instagram,
                              xUrl: "",
                              linkedinUrl: "",
                              emailUrl: "",
                            ),
                          );
                        },
                      ),

                Positioned(
                  bottom: 20,
                  left: 50,
                  right: 50,
                  child: Center(
                    child: AnimatedCapsuleButton(
                      text: 'Create Post',
                      btnColor: AppColors.customDarkBlue,
                      onTap: () => _openBottomSheet(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
