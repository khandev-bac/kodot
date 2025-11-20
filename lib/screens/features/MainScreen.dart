import 'package:flutter/material.dart';
import 'package:kodot/widget/CustomFeed.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MatrixRainPostWidget(
                author: 'Alex Dev',
                avatar: '👨‍💻',
                caption: 'Check out my projects!',
                code: "Hello world this mis my forst project ",
                tags: ["React native", "js", "py", "flutter", "stsrtup"],
                githubUrl: 'https://github.com/alexdev',
                instagramUrl: 'https://instagram.com/alexdev',
                xUrl: 'https://x.com/alexdev',
                linkedinUrl: 'https://linkedin.com/in/alexdev',
                emailUrl: 'alex@example.com',
              ),
              SizedBox(height: 5),
              MatrixRainPostWidget(
                author: 'Alex Dev',
                avatar: '👨‍💻',
                caption: 'Check out my projects!',
                code: "Hello world this mis my forst project ",
                tags: ["React native", "js", "py", "flutter", "stsrtup"],
                githubUrl: 'https://github.com/alexdev',
                instagramUrl: 'https://instagram.com/alexdev',
                xUrl: 'https://x.com/alexdev',
                linkedinUrl: 'https://linkedin.com/in/alexdev',
                emailUrl: 'alex@example.com',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
