import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/models/InboxMessageModel.dart';
import 'package:kodot/models/UserUpdateInfo.dart';
import 'package:kodot/service/PostService.dart';

class UserProfileScreen extends StatefulWidget {
  final String senderUsername;
  final String? senderProfile;
  final String senderUserId;

  const UserProfileScreen({
    super.key,
    required this.senderUsername,
    this.senderProfile,
    required this.senderUserId,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final Postservice postService = Postservice();
  bool isLoading = true;
  Userinfo? userData;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      setState(() => isLoading = true);
      final response = await postService.GetUserData();

      if (response != null && response.data != null) {
        setState(() {
          userData = response.data;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error loading user: $e");
      setState(() => isLoading = false);
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "N/A";
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
        title: Text(
          "Profile",
          style: TextStyle(
            color: Color(0xFFE8E8E8),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF606060)),
                strokeWidth: 2,
              ),
            )
          : userData == null
          ? Center(
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
                    "Failed to load profile",
                    style: TextStyle(
                      color: Color(0xFFE8E8E8),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please try again",
                    style: TextStyle(color: Color(0xFF606060), fontSize: 12),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: loadUserData,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                      ),
                      child: Text(
                        "Retry",
                        style: TextStyle(
                          color: Color(0xFF606060),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF2A2A2A),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF000000).withOpacity(0.3),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child:
                                userData?.Profile != null &&
                                    userData!.Profile!.isNotEmpty
                                ? Image.network(
                                    userData!.Profile!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Color(0xFF1A1A1A),
                                        child: Center(
                                          child: HugeIcon(
                                            icon: HugeIcons.strokeRoundedUser,
                                            color: Color(0xFF606060),
                                            size: 48,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Color(0xFF1A1A1A),
                                    child: Center(
                                      child: HugeIcon(
                                        icon: HugeIcons.strokeRoundedUser,
                                        color: Color(0xFF606060),
                                        size: 48,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Username
                        Text(
                          userData?.UserName ?? "Unknown",
                          style: TextStyle(
                            color: Color(0xFFE8E8E8),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),

                        // User ID
                        Text(
                          "@${userData?.userId ?? "N/A"}",
                          style: TextStyle(
                            color: Color(0xFF606060),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Info Cards
                  _buildInfoCard(
                    icon: HugeIcons.strokeRoundedMail01,
                    label: "Email",
                    value: userData?.Email ?? "Not provided",
                  ),
                  SizedBox(height: 12),

                  _buildInfoCard(
                    icon: HugeIcons.strokeRoundedCalendar01,
                    label: "Joined",
                    value: formatDate(userData?.CreatedAt),
                  ),
                  SizedBox(height: 12),

                  _buildInfoCard(
                    icon: HugeIcons.strokeRoundedId,
                    label: "User ID",
                    value: userData?.userId ?? "N/A",
                    isCopyable: true,
                  ),
                  SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: HugeIcons.strokeRoundedMail01,
                          label: "Message",
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: HugeIcons.strokeRoundedShare01,
                          label: "Share",
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required dynamic icon,
    required String label,
    required String value,
    bool isCopyable = false,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFF161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF2A2A2A), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF2A2A2A), width: 1),
            ),
            child: HugeIcon(icon: icon, color: Color(0xFF606060), size: 16),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Color(0xFF606060),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFFE8E8E8),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isCopyable)
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Copied!"),
                    backgroundColor: Colors.green,
                    duration: Duration(milliseconds: 800),
                  ),
                );
              },
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedCopy01,
                color: Color(0xFF606060),
                size: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFF2A2A2A), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(icon: icon, color: Color(0xFF606060), size: 16),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFFE8E8E8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
