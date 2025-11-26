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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Code cannot be empty"),
          backgroundColor: Colors.red,
        ),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // go back home
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response!.message), backgroundColor: Colors.red),
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
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: Color(0xFF606060),
                size: 20,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Share Your Code",
              style: TextStyle(
                color: Color(0xFFE8E8E8),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              "Make it awesome",
              style: TextStyle(
                color: Color(0xFF606060),
                fontWeight: FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Code input section
            _buildSectionLabel("Your Code"),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF161616),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF2A2A2A), width: 1),
              ),
              child: TextField(
                controller: codeController,
                maxLines: null,
                minLines: 8,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  color: Color(0xFFBBBBBB),
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  hintText: "// Paste your code here...",
                  hintStyle: TextStyle(
                    color: Color(0xFF404040),
                    fontFamily: 'monospace',
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Caption input section
            _buildSectionLabel("Add Caption"),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF161616),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF2A2A2A), width: 1),
              ),
              child: TextField(
                controller: captionController,
                maxLines: 3,
                style: TextStyle(color: Color(0xFFE8E8E8), fontSize: 13),
                decoration: InputDecoration(
                  hintText: "What's this code about?",
                  hintStyle: TextStyle(color: Color(0xFF404040)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Tags input section
            _buildSectionLabel("Add Tags"),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF161616),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF2A2A2A), width: 1),
              ),
              child: TextField(
                controller: tagController,
                style: TextStyle(color: Color(0xFFE8E8E8)),
                decoration: InputDecoration(
                  hintText: "flutter, dart, ui... (comma separated)",
                  hintStyle: TextStyle(color: Color(0xFF404040)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedGrid,
                      color: Color(0xFF404040),
                      size: 16,
                    ),
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
            ),
            SizedBox(height: 16),

            // Show tags as modern chips
            if (tags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags
                    .map(
                      (tag) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xFF2A2A2A),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "#$tag",
                              style: TextStyle(
                                color: Color(0xFF606060),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  tags.remove(tag);
                                });
                              },
                              child: HugeIcon(
                                icon: HugeIcons
                                    .strokeRoundedMultiplicationSignCircle,
                                color: Color(0xFF404040),
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 24),
            ],

            // Post button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF161616)],
                ),
                border: Border.all(color: Color(0xFF2A2A2A), width: 1),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoading ? null : submitPost,
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF606060),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedShare04,
                                color: Color(0xFFE8E8E8),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Post Code",
                                style: TextStyle(
                                  color: Color(0xFFE8E8E8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Color(0xFFE8E8E8),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }
}
