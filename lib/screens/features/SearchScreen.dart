import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  List<dynamic> searchResults = []; // Will hold API results later

  // TODO: integrate search API here later
  Future<void> searchPosts(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    // ---- API integration goes here ----
    // setState(() => isLoading = true);
    // final apiResponse = await SearchService().search(query);
    // setState(() {
    //   searchResults = apiResponse;
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customBlack,
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: AppColors.customBlack,
        foregroundColor: AppColors.customWhite,
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
                onChanged: (value) => searchPosts(value),
                decoration: InputDecoration(
                  hintText: "Search posts, users or tags...",
                  hintStyle: TextStyle(
                    color: AppColors.customWhite.withOpacity(0.5),
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

          // Results section
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
                      "Search something...?",
                      style: TextStyle(
                        color: AppColors.customWhite.withOpacity(0.4),
                        fontSize: 16,
                        fontFamily: "Jost",
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final item = searchResults[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
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
                              backgroundColor: Colors.grey.shade800,
                              child: const HugeIcon(
                                icon: HugeIcons.strokeRoundedSearch01,
                              ),
                            ),
                            title: Text(
                              item["caption"] ?? "No caption",
                              style: TextStyle(
                                color: AppColors.customWhite,
                                fontFamily: "Jost",
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              item["username"] ?? "",
                              style: TextStyle(
                                color: AppColors.customWhite.withOpacity(0.5),
                                fontFamily: "Jost",
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
}
