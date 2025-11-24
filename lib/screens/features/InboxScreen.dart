import 'package:flutter/material.dart';
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

  String timeAgo(String? iso) {
    if (iso == null) return "";
    final date = DateTime.tryParse(iso);
    if (date == null) return "";
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customBlack,
      appBar: AppBar(
        title: const Text("Inbox"),
        backgroundColor: AppColors.customBlack,
        foregroundColor: AppColors.customWhite,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.customWhite),
            )
          : inbox.isEmpty
          ? Center(
              child: Text(
                "No messages yet",
                style: TextStyle(
                  color: AppColors.customWhite.withOpacity(0.5),
                  fontSize: 16,
                  fontFamily: "Jost",
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              itemCount: inbox.length,
              itemBuilder: (context, index) {
                final msg = inbox[index];

                return GestureDetector(
                  onTap: () {
                    // TODO: Optional -> Navigate to full message view
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.customWhite.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.customWhite.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Profile Image
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.grey.shade800,
                          backgroundImage:
                              (msg.senderProfile != null &&
                                  msg.senderProfile!.isNotEmpty)
                              ? NetworkImage(msg.senderProfile!)
                              : null,
                          child:
                              (msg.senderProfile == null ||
                                  msg.senderProfile!.isEmpty)
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 28,
                                )
                              : null,
                        ),

                        const SizedBox(width: 12),

                        // Text Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.senderUsername ?? "Unknown",
                                style: TextStyle(
                                  color: AppColors.customWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Jost",
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg.message ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.customWhite.withOpacity(0.7),
                                  fontSize: 14,
                                  fontFamily: "Jost",
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Time Ago
                        Text(
                          timeAgo(msg.createdAt),
                          style: TextStyle(
                            color: AppColors.customWhite.withOpacity(0.5),
                            fontSize: 12,
                            fontFamily: "Jost",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
