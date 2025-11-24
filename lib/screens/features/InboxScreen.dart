import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';

class Inboxscreen extends StatefulWidget {
  const Inboxscreen({super.key});

  @override
  State<Inboxscreen> createState() => _InboxscreenState();
}

class _InboxscreenState extends State<Inboxscreen> {
  bool isLoading = false;

  // Messages list (You will replace this with API data)
  List<dynamic> inboxMessages = [];

  // TODO: Integrate Inbox API here
  Future<void> fetchInbox() async {
    setState(() => isLoading = true);

    // simulate loading
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Replace with API response
    inboxMessages = [
      {
        "sender": "JohnDev",
        "message": "Hey! I liked your post 👀",
        "time": DateTime.now().subtract(const Duration(minutes: 5)),
        "profile": null,
      },
      {
        "sender": "FlutterGuy",
        "message": "Can you share the code snippet?",
        "time": DateTime.now().subtract(const Duration(hours: 1)),
        "profile": null,
      },
    ];

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchInbox(); // load on start
  }

  String timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
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
          : inboxMessages.isEmpty
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
              itemCount: inboxMessages.length,
              itemBuilder: (context, i) {
                final msg = inboxMessages[i];

                return InkWell(
                  onTap: () {
                    // TODO: Navigate to message detail page
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.customWhite.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.customWhite.withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Profile avatar
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.grey.shade800.withOpacity(
                            0.8,
                          ),
                          backgroundImage: msg["profile"] != null
                              ? NetworkImage(msg["profile"])
                              : null,
                          child: msg["profile"] == null
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),

                        const SizedBox(width: 12),

                        // Message details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg["sender"],
                                style: TextStyle(
                                  color: AppColors.customWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Jost",
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg["message"],
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

                        const SizedBox(width: 10),

                        // Time
                        Text(
                          timeAgo(msg["time"]),
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
