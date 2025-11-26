import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/models/InboxMessageModel.dart';
import 'package:kodot/service/PostService.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final Postservice postService = Postservice();

  bool isLoading = true;
  List<InboxMessageModel> inbox = [];

  @override
  void initState() {
    super.initState();
    loadInbox();
  }

  Future<void> loadInbox() async {
    setState(() => isLoading = true);

    final res = await postService.GetAllUserInbox();

    if (res != null && res.data != null) {
      inbox = res.data!.map((e) => e as InboxMessageModel).toList();
    }

    setState(() => isLoading = false);
  }

  Future<void> refreshInbox() async {
    await loadInbox();
  }

  String timeAgo(String? iso) {
    if (iso == null) return "";
    final date = DateTime.tryParse(iso);
    if (date == null) return "";
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    if (diff.inDays < 7) return "${diff.inDays}d ago";
    return "${(diff.inDays / 7).floor()}w ago";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        title: Text(
          "Messages",
          style: TextStyle(
            color: Color(0xFFE8E8E8),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        foregroundColor: Color(0xFF606060),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: refreshInbox,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedRefresh,
                    color: Color(0xFF606060),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF606060)),
                strokeWidth: 2,
              ),
            )
          : inbox.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedMail01,
                    color: Color(0xFF404040),
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No messages yet",
                    style: TextStyle(
                      color: Color(0xFFE8E8E8),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "When someone replies to your post, it will appear here",
                    style: TextStyle(color: Color(0xFF606060), fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: refreshInbox,
              color: Color(0xFFE8E8E8),
              backgroundColor: Color(0xFF1A1A1A),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                itemCount: inbox.length,
                itemBuilder: (context, index) {
                  final msg = inbox[index];
                  final isUnread = msg.createdAt != null;

                  return GestureDetector(
                    onTap: () {
                      // TODO: Navigate to user profile screen
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Color(0xFF161616),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Image with badge
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xFF1A1A1A),
                                backgroundImage:
                                    (msg.senderProfile != null &&
                                        msg.senderProfile!.isNotEmpty)
                                    ? NetworkImage(msg.senderProfile!)
                                    : null,
                                child:
                                    (msg.senderProfile == null ||
                                        msg.senderProfile!.isEmpty)
                                    ? HugeIcon(
                                        icon: HugeIcons.strokeRoundedUser,
                                        color: Color(0xFF606060),
                                        size: 18,
                                      )
                                    : null,
                              ),
                              if (isUnread)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF606060),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xFF161616),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),

                          // Message content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Username and time
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        msg.senderUsername ?? "Unknown User",
                                        style: TextStyle(
                                          color: Color(0xFFE8E8E8),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      timeAgo(msg.createdAt),
                                      style: TextStyle(
                                        color: Color(0xFF606060),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Message preview
                                Text(
                                  msg.message ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFFB0B0B0),
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Action icon
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Color(0xFF2A2A2A),
                                width: 1,
                              ),
                            ),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowRight01,
                              color: Color(0xFF404040),
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
