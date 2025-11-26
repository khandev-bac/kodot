import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void showShareBottomSheet(
  BuildContext context, {
  required String postId,
  required String? caption,
  required String? authorName,
  required String? authorAvatar,
  required String? imageUrl,
  required String? code,
  String? deepLink,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Color(0xFF0A0A0A),
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SharePostSheet(
        postId: postId,
        caption: caption,
        authorName: authorName,
        authorAvatar: authorAvatar,
        imageUrl: imageUrl,
        code: code,
        deepLink: deepLink,
      );
    },
  );
}

class SharePostSheet extends StatefulWidget {
  final String postId;
  final String? caption;
  final String? authorName;
  final String? authorAvatar;
  final String? imageUrl;
  final String? code;
  final String? deepLink;

  const SharePostSheet({
    super.key,
    required this.postId,
    this.caption,
    this.authorName,
    this.authorAvatar,
    this.imageUrl,
    this.code,
    this.deepLink,
  });

  @override
  State<SharePostSheet> createState() => _SharePostSheetState();
}

class _SharePostSheetState extends State<SharePostSheet> {
  bool _isCopied = false;

  Future<void> _copyToClipboard() async {
    final shareLink = widget.deepLink ?? "kodot://post/${widget.postId}";
    await Clipboard.setData(ClipboardData(text: shareLink));
    setState(() => _isCopied = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedCheckmarkCircle01,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(width: 8),
            Text("Deep link copied!"),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 1500),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isCopied = false);
      }
    });
  }

  Future<void> _shareViaWhatsApp() async {
    final shareLink =
        widget.deepLink ?? "https://kodot.app/post/${widget.postId}";
    final message =
        "Check out this post by ${widget.authorName ?? 'a developer'} on Kodot 🚀\n\n${widget.caption ?? 'Great code shared!'}\n\n$shareLink";

    try {
      await launchUrl(
        Uri.parse("whatsapp://send?text=${Uri.encodeComponent(message)}"),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print("WhatsApp error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("WhatsApp not installed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _shareViaTelegram() async {
    final shareLink =
        widget.deepLink ?? "https://kodot.app/post/${widget.postId}";
    final message =
        "Check out this post by ${widget.authorName ?? 'a developer'} on Kodot 🚀\n\n${widget.caption ?? 'Great code shared!'}\n\n$shareLink";

    try {
      await launchUrl(
        Uri.parse("tg://msg?text=${Uri.encodeComponent(message)}"),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print("Telegram error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Telegram not installed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _shareViaTwitter() async {
    final shareLink =
        widget.deepLink ?? "https://kodot.app/post/${widget.postId}";
    final message =
        "Check out this post by ${widget.authorName ?? 'a developer'} on Kodot 🚀\n\n${widget.caption ?? ''}\n\n$shareLink";

    try {
      await launchUrl(
        Uri.parse(
          "https://twitter.com/intent/tweet?text=${Uri.encodeComponent(message)}",
        ),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print("Twitter error: $e");
    }
  }

  Future<void> _shareViaEmail() async {
    final shareLink =
        widget.deepLink ?? "https://kodot.app/post/${widget.postId}";
    final subject = "Check out this post on Kodot";
    final body =
        "Check out this post by ${widget.authorName ?? 'a developer'}\n\n${widget.caption ?? 'Great code shared!'}\n\n$shareLink";

    try {
      await launchUrl(
        Uri(
          scheme: 'mailto',
          path: '',
          queryParameters: {'subject': subject, 'body': body},
        ),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print("Email error: $e");
    }
  }

  Future<void> _shareNative() async {
    final shareLink = widget.deepLink ?? "kodot://post/${widget.postId}";
    final message = "Check out this post on Kodot: $shareLink";

    await Share.share(
      message,
      subject: "Check out this post by ${widget.authorName}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: Color(0xFF1A1A1A), width: 1)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: 20),

            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedShare01,
                    color: Color(0xFF606060),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Share Post",
                        style: TextStyle(
                          color: Color(0xFFE8E8E8),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Share to your network",
                        style: TextStyle(
                          color: Color(0xFF606060),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Post Preview Card
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color(0xFF161616),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF2A2A2A), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author info
                  Row(
                    children: [
                      if (widget.authorAvatar != null)
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF1A1A1A),
                          backgroundImage: NetworkImage(widget.authorAvatar!),
                        ),
                      if (widget.authorAvatar != null) SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.authorName ?? "Developer",
                          style: TextStyle(
                            color: Color(0xFFE8E8E8),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Color(0xFF2A2A2A),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "Kodot",
                          style: TextStyle(
                            color: Color(0xFF606060),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Caption preview
                  if (widget.caption != null && widget.caption!.isNotEmpty)
                    Text(
                      widget.caption!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  if (widget.caption != null && widget.caption!.isNotEmpty)
                    SizedBox(height: 12),

                  // Code preview
                  if (widget.code != null && widget.code!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFF0A0A0A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                      ),
                      child: Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedCode,
                            color: Color(0xFF606060),
                            size: 14,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Code snippet",
                            style: TextStyle(
                              color: Color(0xFF606060),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.code != null && widget.code!.isNotEmpty)
                    SizedBox(height: 12),

                  // Image preview
                  if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.imageUrl!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 120,
                            color: Color(0xFF1A1A1A),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF404040),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Share options - Grid
            Text(
              "Share via",
              style: TextStyle(
                color: Color(0xFF606060),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildShareOption(
                  icon: HugeIcons.strokeRoundedWhatsapp,
                  label: "WhatsApp",
                  onTap: _shareViaWhatsApp,
                ),
                _buildShareOption(
                  icon: HugeIcons.strokeRoundedTelegram,
                  label: "Telegram",
                  onTap: _shareViaTelegram,
                ),
                _buildShareOption(
                  icon: HugeIcons.strokeRoundedTwitter,
                  label: "Twitter",
                  onTap: _shareViaTwitter,
                ),
                _buildShareOption(
                  icon: HugeIcons.strokeRoundedMail01,
                  label: "Email",
                  onTap: _shareViaEmail,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Copy link button
            GestureDetector(
              onTap: _copyToClipboard,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF161616),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HugeIcon(
                      icon: _isCopied
                          ? HugeIcons.strokeRoundedCheckList
                          : HugeIcons.strokeRoundedCopy01,
                      color: _isCopied ? Colors.green : Color(0xFF606060),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      _isCopied ? "Copied!" : "Copy Deep Link",
                      style: TextStyle(
                        color: _isCopied ? Colors.green : Color(0xFFE8E8E8),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF161616),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF2A2A2A), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(icon: icon, color: Color(0xFF606060), size: 28),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFF606060),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
