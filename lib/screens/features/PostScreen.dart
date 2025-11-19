import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/screens/features/CodePostScreen.dart';
import 'package:kodot/widget/CustomCircle.dart';

class Postscreen extends StatefulWidget {
  const Postscreen({super.key});

  @override
  State<Postscreen> createState() => _PostscreenState();
}

class _PostscreenState extends State<Postscreen> {
  List post = [];
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
              // --- Drag handle ---
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 15),

              // --- Header with title & close button ---
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

              // --- Options ---
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
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Codepostscreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0, 1);
                            const end = Offset.zero;
                            final curve = Curves.easeOutCubic;
                            final tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                    ),
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
                onTap: () => Navigator.pop(context),
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              //// list of all posts
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
                  : Center(
                      child: Text(
                        "Todo build listview",
                        style: TextStyle(
                          fontFamily: "Jost",
                          fontSize: 18,
                          color: AppColors.customWhite,
                        ),
                      ),
                    ),
              // post button
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
        ),
      ),
    );
  }
}
