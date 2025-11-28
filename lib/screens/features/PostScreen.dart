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
      backgroundColor: Color(0xFF0A0A0A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF0A0A0A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: Color(0xFF1A1A1A), width: 1)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(height: 20),

                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedFeather,
                        color: Color(0xFFE8E8E8),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create New Post",
                            style: TextStyle(
                              color: Color(0xFFE8E8E8),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            "Share your code or project",
                            style: TextStyle(
                              color: Color(0xFF606060),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedMultiplicationSignCircle,
                          color: Color(0xFF606060),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Option 1: Code Snippet
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const Codepostscreen()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF161616),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color(0xFF2A2A2A),
                              width: 1,
                            ),
                          ),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedCode,
                            color: Color(0xFFBBBBBB),
                            size: 22,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Code Snippet",
                                style: TextStyle(
                                  color: Color(0xFFE8E8E8),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Share your code with the community",
                                style: TextStyle(
                                  color: Color(0xFF606060),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowRight01,
                          color: Color(0xFF404040),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),

                // Option 2: Image/Project
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const UploadPostImageScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF161616),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color(0xFF2A2A2A),
                              width: 1,
                            ),
                          ),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedImage02,
                            color: Color(0xFFBBBBBB),
                            size: 22,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Project Snapshot",
                                style: TextStyle(
                                  color: Color(0xFFE8E8E8),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Share a screenshot of your work",
                                style: TextStyle(
                                  color: Color(0xFF606060),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowRight01,
                          color: Color(0xFF404040),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
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
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF606060)),
              ),
            );
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading posts",
                style: TextStyle(color: AppColors.customWhite),
              ),
            );
          }

          // Handle null snapshot
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                "No posts found",
                style: TextStyle(color: AppColors.customWhite),
              ),
            );
          }

          // Handle null data inside response
          if (snapshot.data!.data == null) {
            return _buildEmptyState();
          }

          // Extract and filter posts
          final data = snapshot.data!.data!;
          post = data.where((e) => e != null).cast<FeedPostModel>().toList();

          if (post.isEmpty) {
            return _buildEmptyState();
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 12, bottom: 100),
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
                    githubUrl: postData.socials.github,
                    instagramUrl: postData.socials.instagram,
                    xUrl: "",
                    linkedinUrl: "",
                    emailUrl: "",
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openBottomSheet,
        backgroundColor: AppColors.customWhite,
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedAdd01,
          color: AppColors.customBlack,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedFileNotFound,
            color: AppColors.customWhite.withOpacity(0.5),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            "Nothing you have shared",
            style: TextStyle(
              fontFamily: "Jost",
              fontSize: 18,
              color: AppColors.customWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Create your first post",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.customWhite.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
