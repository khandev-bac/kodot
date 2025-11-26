import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/models/AppSuccessModel.dart';
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

  // Track boost counts locally
  late Map<String, int> boostCounts;
  // Track which posts have been boosted
  late Set<String> boostedPosts;

  @override
  void initState() {
    super.initState();
    boostCounts = {};
    boostedPosts = {};
    futurePosts = postservice.GetAllPosts();
  }

  Future<void> refreshPosts() async {
    setState(() {
      futurePosts = postservice.GetAllPosts();
    });
  }

  Future<void> _handleBoost(String postId, int currentBoosts) async {
    // Check if already boosted
    if (boostedPosts.contains(postId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You already boosted this post!"),
          backgroundColor: Colors.orange,
          duration: Duration(milliseconds: 800),
        ),
      );
      return;
    }

    try {
      // Call the boost API
      final result = await postservice.Boost(postId);

      if (result != null && result['count'] != null) {
        setState(() {
          // Update the local boost count
          boostCounts[postId] = result['count'];
          // Add to boosted posts set
          boostedPosts.add(postId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Boosted! 🚀"),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 800),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to boost post"),
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      print("Boost Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error boosting post"),
          backgroundColor: Colors.red,
        ),
      );
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kodot",
                  style: TextStyle(
                    color: AppColors.customWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "Developer Feed",
                  style: TextStyle(
                    color: Color(0xFF606060),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: FutureBuilder<AppSuccessMessage<List<FeedPostModel?>>?>(
        future: futurePosts,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF606060)),
              ),
            );
          }

          // Error handling
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedAlertCircle,
                    color: Color(0xFF404040),
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Failed to load posts",
                    style: TextStyle(
                      color: AppColors.customWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please try again later",
                    style: TextStyle(color: Color(0xFF606060), fontSize: 13),
                  ),
                ],
              ),
            );
          }

          if (snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
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
                    "No posts yet",
                    style: TextStyle(
                      color: AppColors.customWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Be the first to share your code!",
                    style: TextStyle(color: Color(0xFF606060), fontSize: 13),
                  ),
                ],
              ),
            );
          }

          final posts = snapshot.data!.data!;
          final validPosts = posts
              .where((p) => p != null)
              .cast<FeedPostModel>()
              .toList();

          return RefreshIndicator(
            onRefresh: refreshPosts,
            color: AppColors.customWhite,
            backgroundColor: Color(0xFF1A1A1A),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: validPosts.length,
              separatorBuilder: (context, index) => SizedBox(height: 1),
              itemBuilder: (context, index) {
                final post = validPosts[index];

                // Get the current boost count (from local state or original)
                final currentBoosts = boostCounts[post.postId] ?? post.boost;
                // Check if this post is already boosted
                final isAlreadyBoosted = boostedPosts.contains(post.postId);

                return MatrixRainPostWidget(
                  author: post.username,
                  avatarUrl: post.profile,
                  caption: post.caption ?? "",
                  code: post.code ?? "",
                  tags: post.tags,
                  imageUrl: post.imageUrl ?? "",
                  githubUrl: post.socials.github,
                  instagramUrl: post.socials.instagram,
                  linkedinUrl: post.socials.linkedIn,
                  boosts: currentBoosts,
                  
                  // Disable boost if already boosted
                  isBoostDisabled: isAlreadyBoosted,

                  // --------------------------------------------------
                  // SEND MESSAGE (INBOX)
                  // --------------------------------------------------
                  onSendMessage: (String message) async {
                    if (message.trim().isEmpty) return;

                    final res = await postservice.CreateInboxMessage(
                      post.postId,
                      message,
                    );

                    if (res != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Message sent! 📩"),
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 800),
                        ),
                      );
                    }
                  },

                  // --------------------------------------------------
                  // BOOST BUTTON
                  // --------------------------------------------------
                  onBoost: isAlreadyBoosted
                      ? null
                      : () async {
                          await _handleBoost(post.postId, currentBoosts);
                        },

                  onInbox: () {},
                  onShare: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }
}
