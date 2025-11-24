import 'package:flutter/material.dart';
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
      backgroundColor: AppColors.customBlack,
      appBar: AppBar(
        title: const Text("Search"),
        foregroundColor: AppColors.customWhite,
        backgroundColor: AppColors.customBlack,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.customWhite.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                style: TextStyle(color: AppColors.customWhite),
                onChanged: searchPosts,
                decoration: InputDecoration(
                  hintText: "Search posts, users or tags...",
                  hintStyle: TextStyle(
                    color: AppColors.customWhite.withOpacity(0.4),
                    fontFamily: "Jost",
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.customWhite),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
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
                      color: AppColors.customWhite,
                    ),
                  )
                : searchResults.isEmpty
                ? Center(
                    child: Text(
                      "Search something...",
                      style: TextStyle(
                        color: AppColors.customWhite.withOpacity(0.4),
                        fontFamily: "Jost",
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final FeedPostModel post = searchResults[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
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
                              color: AppColors.customWhite.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.customWhite.withOpacity(0.1),
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey.shade900,
                                backgroundImage:
                                    post.profile != null &&
                                        post.profile!.isNotEmpty
                                    ? NetworkImage(post.profile!)
                                    : null,
                                child:
                                    post.profile == null ||
                                        post.profile!.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        color: AppColors.customWhite,
                                      )
                                    : null,
                              ),
                              title: Text(
                                post.caption?.isNotEmpty == true
                                    ? post.caption!
                                    : "No caption",
                                style: TextStyle(
                                  color: AppColors.customWhite,
                                  fontFamily: "Jost",
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                "@${post.username}",
                                style: TextStyle(
                                  color: AppColors.customWhite.withOpacity(0.5),
                                  fontFamily: "Jost",
                                ),
                              ),
                              trailing:
                                  post.imageUrl != null &&
                                      post.imageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        post.imageUrl!,
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : null,
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
}
