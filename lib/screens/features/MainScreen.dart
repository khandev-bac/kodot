import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/models/AppSuccessModel.dart';
import 'package:kodot/models/FeedModel.dart';
import 'package:kodot/screens/features/SharePostBottomSheet.dart';
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

  // Local boost state so UI updates instantly
  Map<String, int> localBoosts = {};
  Map<String, bool> userLiked = {};

  @override
  void initState() {
    super.initState();
    futurePosts = postservice.GetAllPosts();
  }

  Future<void> refreshPosts() async {
    setState(() {
      futurePosts = postservice.GetAllPosts();
    });
  }

  Future<void> _handleBoostToggle(String postId) async {
    try {
      final result = await postservice.Boost(postId);

      if (result != null && result['count'] != null) {
        setState(() {
          localBoosts[postId] = result['count'];
          userLiked[postId] = !(userLiked[postId] ?? false);
        });
      }
    } catch (e) {
      print("Boost Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "K",
                  style: TextStyle(
                    color: AppColors.customWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Kodot",
              style: TextStyle(
                color: AppColors.customWhite,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<AppSuccessMessage<List<FeedPostModel?>>?>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF606060)),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return _buildError("Failed to load posts");
          }

          final posts = snapshot.data!.data;
          if (posts == null || posts.isEmpty) {
            return _buildError("No posts yet");
          }

          final validPosts = posts
              .where((p) => p != null)
              .cast<FeedPostModel>()
              .toList();

          return RefreshIndicator(
            onRefresh: refreshPosts,
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 20),
              itemCount: validPosts.length,
              itemBuilder: (context, index) {
                final post = validPosts[index];

                final localBoost = localBoosts[post.postId];
                final currentBoost = localBoost ?? post.boost;

                return MatrixRainPostWidget(
                  author: post.username,
                  avatarUrl: post.profile,
                  caption: post.caption,
                  code: post.code,
                  tags: post.tags,
                  imageUrl: post.imageUrl,
                  githubUrl: post.socials.github,
                  instagramUrl: post.socials.instagram,
                  linkedinUrl: post.socials.linkedIn,
                  // xUrl: post.socials,
                  boosts: currentBoost,

                  isBoostDisabled: false, // ⭐ always enabled
                  onBoost: () => _handleBoostToggle(post.postId),

                  onInbox: () {},
                  onShare: () {
                    showShareBottomSheet(
                      context,
                      postId: post.postId,
                      caption: post.caption,
                      authorName: post.username,
                      authorAvatar: post.profile,
                      imageUrl: post.imageUrl,
                      code: post.code,
                    );
                  },

                  onSendMessage: (msg) async {
                    if (msg.trim().isEmpty) return;
                    await postservice.CreateInboxMessage(post.postId, msg);
                  },
                  onDelete: () async {
                    final result = await postservice.DeletePost(
                      postId: post.postId,
                    );
                    if (result != null && result['statusCode'] == 200) {
                      setState(() {
                        futurePosts = postservice.GetAllPosts();
                      });
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedFileNotFound,
            color: Color(0xFF404040),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.customWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
