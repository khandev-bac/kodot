import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/models/AppSuccessModel.dart';
import 'package:kodot/models/UserUpdateInfo.dart';
import 'package:kodot/service/AuthService.dart';
import 'package:kodot/service/PostService.dart';
import 'package:kodot/widget/CustomButton.dart';

class ProfilSreen extends StatefulWidget {
  const ProfilSreen({super.key});

  @override
  State<ProfilSreen> createState() => _ProfilSreenState();
}

class _ProfilSreenState extends State<ProfilSreen> {
  final Authservice authservice = Authservice();
  final Postservice postservice = Postservice();

  bool isLoading = true;
  AppSuccessMessage<Userinfo>? user; // ✅ FIXED

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final res = await postservice.GetUserData();

    setState(() {
      user = res; // ❌ No more user! access before assignment
      isLoading = false;
    });

    print("User data: ${user?.data?.Email}");
  }

  String formatJoinDate(String? isoString) {
    if (isoString == null) return "";
    try {
      final date = DateTime.parse(isoString);
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return "Joined ${months[date.month - 1]} ${date.year}";
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customBlack,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.customBlack,
        foregroundColor: AppColors.customWhite,
        elevation: 0,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : user == null ||
                user!.data ==
                    null // ✅ FIXED
          ? Center(
              child: Text(
                "Failed to load user",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : buildUI(user!.data!),
    );
  }

  Widget buildUI(Userinfo data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // ---------------- PROFILE PICTURE ----------------
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: (data.Profile != null && data.Profile!.isNotEmpty)
                ? NetworkImage(data.Profile!)
                : null,
            child: (data.Profile == null || data.Profile!.isEmpty)
                ? const Icon(Icons.person, color: Colors.white, size: 50)
                : null,
          ),

          const SizedBox(height: 20),

          // ---------------- USERNAME ----------------
          Text(
            data.UserName ?? "Unknown User",
            style: TextStyle(
              color: AppColors.customWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "Jost",
            ),
          ),

          const SizedBox(height: 6),

          // ---------------- JOIN DATE ----------------
          if (data.CreatedAt != null)
            Text(
              formatJoinDate(data.CreatedAt),
              style: TextStyle(
                color: AppColors.customWhite.withOpacity(0.6),
                fontSize: 15,
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
              border: Border.all(color: AppColors.customWhite.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.email, color: AppColors.customWhite, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    data.Email ?? "No email",
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
              Clipboard.setData(ClipboardData(text: data.userId ?? ""));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User ID copied"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Container(
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

          Custombutton(
            text: "Logout",
            onTap: () async => authservice.signOut(),
          ),

          const SizedBox(height: 12),

          Text(
            "Made in India 🇮🇳",
            style: TextStyle(
              color: AppColors.customWhite.withOpacity(0.7),
              fontSize: 14,
              fontFamily: "Jost",
            ),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
