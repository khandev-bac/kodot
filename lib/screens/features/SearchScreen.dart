import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/models/FeedModel.dart';
import 'package:kodot/screens/features/PostScreenById.dart';
import 'package:kodot/service/PostService.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final TextEditingController searchController = TextEditingController();
  final Postservice postservice = Postservice();

  bool isLoading = false;
  List<FeedPostModel> searchResults = [];

  Future<void> searchPosts(String text) async {
    if (text.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    setState(() => isLoading = true);

    final apiRes = await postservice.SearchQuery(text);

    if (apiRes != null && apiRes.data != null) {
      setState(() {
        searchResults = apiRes.data!;
        isLoading = false;
      });
    } else {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        title: Text(
          "Discover",
          style: TextStyle(
            color: Color(0xFFE8E8E8),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        foregroundColor: Color(0xFF606060),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF161616),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                style: TextStyle(color: Color(0xFFE8E8E8), fontSize: 14),
                onChanged: searchPosts,
                decoration: InputDecoration(
                  hintText: "Search posts, users, tags...",
                  hintStyle: TextStyle(color: Color(0xFF404040), fontSize: 13),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedSearch01,
                      color: Color(0xFF606060),
                      size: 18,
                    ),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            searchController.clear();
                            setState(() => searchResults = []);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedCancelCircle,
                              color: Color(0xFF606060),
                              size: 16,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 4,
                  ),
                ),
              ),
            ),
          ),

          // Results
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF606060),
                      ),
                      strokeWidth: 2,
                    ),
                  )
                : searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedSearch01,
                          color: Color(0xFF404040),
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          searchController.text.isEmpty
                              ? "Search for posts"
                              : "No results found",
                          style: TextStyle(
                            color: Color(0xFFE8E8E8),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          searchController.text.isEmpty
                              ? "Find posts, users, and tags"
                              : "Try different keywords",
                          style: TextStyle(
                            color: Color(0xFF606060),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final FeedPostModel post = searchResults[index];
                      final hasImage =
                          post.imageUrl != null && post.imageUrl!.isNotEmpty;
                      final hasCode =
                          post.code != null && post.code!.isNotEmpty;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    Postscreenbyid(postId: post.postId),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF161616),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFF2A2A2A),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Author info
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Color(0xFF1A1A1A),
                                        backgroundImage:
                                            post.profile != null &&
                                                post.profile!.isNotEmpty
                                            ? NetworkImage(post.profile!)
                                            : null,
                                        child:
                                            post.profile == null ||
                                                post.profile!.isEmpty
                                            ? HugeIcon(
                                                icon:
                                                    HugeIcons.strokeRoundedUser,
                                                color: Color(0xFF606060),
                                                size: 18,
                                              )
                                            : null,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              post.username,
                                              style: TextStyle(
                                                color: Color(0xFFE8E8E8),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              "@${post.username}",
                                              style: TextStyle(
                                                color: Color(0xFF606060),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (hasCode)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF1A1A1A),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: Color(0xFF2A2A2A),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              HugeIcon(
                                                icon:
                                                    HugeIcons.strokeRoundedCode,
                                                color: Color(0xFF606060),
                                                size: 12,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Code",
                                                style: TextStyle(
                                                  color: Color(0xFF606060),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 12),

                                  // Caption
                                  if (post.caption != null &&
                                      post.caption!.isNotEmpty)
                                    Text(
                                      post.caption!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFFE8E8E8),
                                        fontSize: 13,
                                        height: 1.5,
                                      ),
                                    ),

                                  // Tags
                                  if (post.tags != null &&
                                      post.tags!.isNotEmpty) ...[
                                    SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      children: post.tags!
                                          .take(3)
                                          .map(
                                            (tag) => Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF1A1A1A),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: Color(0xFF2A2A2A),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                "#$tag",
                                                style: TextStyle(
                                                  color: Color(0xFF606060),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],

                                  // Image or preview
                                  if (hasImage) ...[
                                    SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        post.imageUrl!,
                                        width: double.infinity,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Container(
                                                height: 150,
                                                color: Color(0xFF1A1A1A),
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Color(0xFF404040)),
                                                  ),
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ],

                                  // Stats
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _buildStat(
                                        HugeIcons.strokeRoundedFlash,
                                        post.boost.toString(),
                                      ),
                                      SizedBox(width: 16),
                                      if (post.code != null &&
                                          post.code!.isNotEmpty)
                                        _buildStat(
                                          HugeIcons.strokeRoundedCode,
                                          "Code",
                                        ),
                                      if (post.imageUrl != null &&
                                          post.imageUrl!.isNotEmpty)
                                        _buildStat(
                                          HugeIcons.strokeRoundedImage02,
                                          "Image",
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(dynamic icon, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HugeIcon(icon: icon, color: Color(0xFF606060), size: 14),
        SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            color: Color(0xFF606060),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
