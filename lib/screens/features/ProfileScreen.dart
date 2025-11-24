import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/service/AuthService.dart';
import 'package:kodot/widget/CustomButton.dart';

class ProfilSreen extends StatelessWidget {
  const ProfilSreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Authservice authservice = Authservice();

    // TODO: Replace with real user data
    final String username = "John Doe";
    final String email = "johndoe@example.com";
    final String userId = "JwrK9bqf6SZYwp0dVYddcOvWt4R2";
    final String? profileUrl = null;

    return Scaffold(
      backgroundColor: AppColors.customBlack,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.customBlack,
        foregroundColor: AppColors.customWhite,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // ---------------- PROFILE PICTURE ----------------
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade800,
              backgroundImage: profileUrl != null
                  ? NetworkImage(profileUrl)
                  : null,
              child: profileUrl == null
                  ? const Icon(Icons.person, color: Colors.white, size: 50)
                  : null,
            ),

            const SizedBox(height: 20),

            // ---------------- USERNAME ONLY ----------------
            Text(
              username,
              style: TextStyle(
                color: AppColors.customWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "Jost",
              ),
            ),

            const SizedBox(height: 25),

            // ---------------- EMAIL CARD ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.customWhite.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.customWhite.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.email, color: AppColors.customWhite, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      email,
                      style: TextStyle(
                        color: AppColors.customWhite,
                        fontSize: 16,
                        fontFamily: "Jost",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ---------------- COPY USER ID ----------------
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: userId));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User ID copied"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: AppColors.customWhite.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.customWhite.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.support_agent,
                      color: AppColors.customWhite,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Customer Support: Copy User ID",
                        style: TextStyle(
                          color: AppColors.customWhite,
                          fontSize: 16,
                          fontFamily: "Jost",
                        ),
                      ),
                    ),
                    Icon(Icons.copy, color: AppColors.customWhite, size: 20),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ---------------- LOGOUT BUTTON ----------------
            Custombutton(
              text: "Logout",
              onTap: () async {
                authservice.signOut();
              },
            ),

            const SizedBox(height: 15),

            // ---------------- MADE IN INDIA ----------------
            Text(
              "Made in India 🇮🇳",
              style: TextStyle(
                color: AppColors.customWhite.withOpacity(0.6),
                fontSize: 14,
                fontFamily: "Jost",
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
