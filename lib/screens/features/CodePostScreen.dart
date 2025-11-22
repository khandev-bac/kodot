import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/service/PostService.dart';
import 'package:kodot/widget/CustomButton.dart';

class Codepostscreen extends StatefulWidget {
  const Codepostscreen({super.key});

  @override
  State<Codepostscreen> createState() => _CodepostscreenState();
}

class _CodepostscreenState extends State<Codepostscreen> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  List<String> tags = [];

  bool isLoading = false;

  // -------------------------
  // SUBMIT FUNCTION
  // -------------------------
  Future<void> submitPost() async {
    final Postservice postservice = Postservice();
    final code = codeController.text.trim();
    final caption = captionController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Code cannot be empty")));
      return;
    }

    setState(() => isLoading = true);

    final response = await postservice.CreateCodePostService(
      code: code,
      caption: caption,
      tags: tags,
    );

    setState(() => isLoading = false);

    if (response != null && response.data != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.pop(context); // go back home
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response!.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.customDarkBlue,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedMultiplicationSign,
              color: AppColors.customWhite,
              size: 20,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "New Post",
          style: TextStyle(
            color: AppColors.customWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Code input
            Expanded(
              child: TextField(
                controller: codeController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  color: AppColors.customWhite,
                  fontFamily: 'monospace',
                ),
                decoration: InputDecoration(
                  hintText: "Drop today’s build, hacks, or mysterious errors…",
                  hintStyle: TextStyle(color: Color(0xFFD3DAD9)),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Caption input
            TextField(
              controller: captionController,
              style: TextStyle(color: AppColors.customWhite),
              decoration: InputDecoration(
                hintText: "Add a caption…",
                hintStyle: TextStyle(color: Color(0xFFD3DAD9)),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Tags input
            TextField(
              controller: tagController,
              style: TextStyle(color: AppColors.customWhite),
              decoration: InputDecoration(
                hintText: "Add tags (comma separated)…",
                hintStyle: TextStyle(color: Color(0xFFD3DAD9)),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  setState(() {
                    tags.addAll(value.split(",").map((e) => e.trim()));
                    tagController.clear();
                  });
                }
              },
            ),
            SizedBox(height: 10),

            // Show tags as chips
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      backgroundColor: AppColors.customBlack,
                      labelStyle: TextStyle(color: AppColors.customWhite),
                      onDeleted: () {
                        setState(() {
                          tags.remove(tag);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),

            SizedBox(height: 20),

            // Post button
            Custombutton(
              text: isLoading ? "Posting..." : "Post",
              onTap: isLoading ? null : submitPost,
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
