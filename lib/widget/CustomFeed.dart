import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MatrixRainPostWidget extends StatefulWidget {
  final String? author;
  final String? avatarUrl;
  final String? time;
  final String? caption;
  final String? code;
  final String? imageUrl;
  final List<String>? tags;

  final int boosts;
  final int messages;
  final int shares;

  final String? githubUrl;
  final String? instagramUrl;
  final String? xUrl;
  final String? linkedinUrl;
  final String? emailUrl;

  final VoidCallback? onBoost;
  final VoidCallback? onInbox;
  final VoidCallback? onShare;

  /// NEW: send message callback
  final Function(String message)? onSendMessage;

  const MatrixRainPostWidget({
    super.key,
    this.author,
    this.avatarUrl,
    this.time,
    this.caption,
    this.code,
    this.imageUrl,
    this.tags,
    this.boosts = 0,
    this.messages = 0,
    this.shares = 0,
    this.githubUrl,
    this.instagramUrl,
    this.xUrl,
    this.linkedinUrl,
    this.emailUrl,
    this.onBoost,
    this.onInbox,
    this.onShare,
    this.onSendMessage,
  });

  @override
  State<MatrixRainPostWidget> createState() => _MatrixRainPostWidgetState();
}

class _MatrixRainPostWidgetState extends State<MatrixRainPostWidget> {
  late int _boosts;
  bool _showInbox = false;

  final TextEditingController _inboxInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _boosts = widget.boosts;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MatrixRainColors.bgCard,
            MatrixRainColors.bgGreenTint,
            MatrixRainColors.bgCard,
          ],
        ),
        border: Border.all(color: MatrixRainColors.borderGreen, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSocialBar(),
          _buildProfileRow(),
          if (widget.caption != null) _buildCaption(),
          _buildContentSection(),
          if (widget.tags != null && widget.tags!.isNotEmpty) _buildTags(),

          /// REMOVED boost count section
          _buildActionButtons(),
          if (_showInbox) _buildInboxBox(),
        ],
      ),
    );
  }

  // SOCIAL BUTTON BAR
  Widget _buildSocialBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          if (widget.githubUrl != null)
            _buildSocialButton(
              HugeIcon(
                icon: HugeIcons.strokeRoundedGithub,
                color: MatrixRainColors.green400,
                size: 30,
              ),
              () => _launchUrl(widget.githubUrl!),
            ),
          if (widget.instagramUrl != null)
            _buildSocialButton(
              HugeIcon(
                icon: HugeIcons.strokeRoundedInstagram,
                color: MatrixRainColors.lime400,
                size: 30,
              ),
              () => _launchUrl(widget.instagramUrl!),
            ),
          if (widget.linkedinUrl != null)
            _buildSocialButton(
              HugeIcon(
                icon: HugeIcons.strokeRoundedLinkedin01,
                color: MatrixRainColors.emerald400,
                size: 30,
              ),
              () => _launchUrl(widget.linkedinUrl!),
            ),
          if (widget.xUrl != null)
            _buildSocialButton(
              HugeIcon(
                icon: HugeIcons.strokeRoundedNewTwitter,
                color: MatrixRainColors.teal400,
                size: 30,
              ),
              () => _launchUrl(widget.xUrl!),
            ),
          if (widget.emailUrl != null)
            _buildSocialButton(
              HugeIcon(
                icon: HugeIcons.strokeRoundedMail01,
                color: MatrixRainColors.green300,
                size: 30,
              ),
              () => _launchUrl("mailto:${widget.emailUrl!}"),
            ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(Widget icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(onTap: onTap, child: icon),
    );
  }

  Widget _buildProfileRow() {
    if (widget.author == null && widget.avatarUrl == null) return SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          if (widget.avatarUrl != null)
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black26,
              backgroundImage: NetworkImage(widget.avatarUrl!),
            ),
          if (widget.avatarUrl != null) SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.author != null)
                Text(
                  widget.author!,
                  style: const TextStyle(
                    color: MatrixRainColors.green400,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'monospace',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.caption!,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    final hasCode = widget.code != null && widget.code!.isNotEmpty;
    final hasImage = widget.imageUrl != null && widget.imageUrl!.isNotEmpty;

    if (!hasCode && !hasImage) return SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          if (hasCode) _buildCodeBlock(),
          if (hasCode && hasImage) SizedBox(height: 12),
          if (hasImage) _buildImageBlock(),
        ],
      ),
    );
  }

  Widget _buildCodeBlock() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black38,
        border: Border.all(color: MatrixRainColors.borderGreen, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        widget.code ?? "",
        style: const TextStyle(
          color: MatrixRainColors.lime400,
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _buildImageBlock() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.imageUrl!,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTags() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Wrap(
        spacing: 8,
        children: widget.tags!
            .map(
              (tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MatrixRainColors.bgGreenTint,
                  border: Border.all(color: MatrixRainColors.borderGreen),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: MatrixRainColors.green300,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // BOOST BUTTON
          Expanded(
            child: _buildAction("Boost", Icons.flash_on, () {
              setState(() {
                _boosts = _boosts == 0 ? 1 : 0; // toggle like Instagram
              });
              widget.onBoost?.call();
            }),
          ),

          SizedBox(width: 8),

          Expanded(
            child: _buildAction("Inbox", Icons.mail_outline, () {
              setState(() => _showInbox = !_showInbox);
              widget.onInbox?.call();
            }),
          ),

          SizedBox(width: 8),

          Expanded(
            child: _buildAction("Share", Icons.share, () {
              widget.onShare?.call();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(String label, IconData icon, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: MatrixRainColors.green400),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: MatrixRainColors.green400, size: 14),
          SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: MatrixRainColors.green400,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInboxBox() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0a2e1a),
          border: Border.all(color: MatrixRainColors.borderGreen),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inboxInput,
                  style: const TextStyle(
                    color: MatrixRainColors.green400,
                    fontFamily: 'monospace',
                  ),
                  decoration: InputDecoration(
                    hintText: "Reply...",
                    hintStyle: const TextStyle(
                      color: MatrixRainColors.textGray500,
                      fontFamily: 'monospace',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: MatrixRainColors.borderGreen,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              ElevatedButton(
                onPressed: () {
                  final msg = _inboxInput.text.trim();
                  if (msg.isEmpty) return;

                  widget.onSendMessage?.call(msg);
                  _inboxInput.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MatrixRainColors.green600,
                ),
                child: const Text(
                  "Send",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "monospace",
                    fontSize: 12,
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
