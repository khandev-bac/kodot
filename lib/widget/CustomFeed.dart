import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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

  final Function(String message)? onSendMessage;
  final bool isBoostDisabled;

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
    this.isBoostDisabled = false,
  });

  @override
  State<MatrixRainPostWidget> createState() => _MatrixRainPostWidgetState();
}

class _MatrixRainPostWidgetState extends State<MatrixRainPostWidget>
    with SingleTickerProviderStateMixin {
  late int _boosts;
  bool _showReply = false;
  bool _isLiked = false;
  late AnimationController _likeController;

  final TextEditingController _replyInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _boosts = widget.boosts;
    _likeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    _replyInput.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw Exception('Could not launch $url');
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeController.forward();
        _boosts++;
      } else {
        _boosts--;
      }
    });
    widget.onBoost?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(bottom: BorderSide(color: Color(0xFF1A1A1A), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (widget.caption != null) _buildCaption(),
          _buildContentSection(),
          if (widget.tags != null && widget.tags!.isNotEmpty) _buildTags(),
          _buildEngagementBar(),
          if (_showReply) _buildReplyBox(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (widget.avatarUrl != null)
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF1A1A1A),
              backgroundImage: NetworkImage(widget.avatarUrl!),
            ),
          if (widget.avatarUrl != null) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.author ?? "Developer",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (widget.time != null)
                  Text(
                    widget.time!,
                    style: TextStyle(
                      color: Color(0xFF808080),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
          _buildHeaderMenu(),
        ],
      ),
    );
  }

  Widget _buildHeaderMenu() {
    return PopupMenuButton(
      icon: Icon(Icons.more_horiz, color: Color(0xFF808080), size: 18),
      color: Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (context) => [
        if (widget.githubUrl != null)
          PopupMenuItem(
            child: _buildMenuItem(
              'GitHub',
              HugeIcons.strokeRoundedGithub,
              () => _launchUrl(widget.githubUrl!),
            ),
          ),
        if (widget.xUrl != null)
          PopupMenuItem(
            child: _buildMenuItem(
              'Twitter/X',
              HugeIcons.strokeRoundedTwitter,
              () => _launchUrl(widget.xUrl!),
            ),
          ),
        if (widget.linkedinUrl != null)
          PopupMenuItem(
            child: _buildMenuItem(
              'LinkedIn',
              HugeIcons.strokeRoundedLinkedin01,
              () => _launchUrl(widget.linkedinUrl!),
            ),
          ),
        if (widget.instagramUrl != null)
          PopupMenuItem(
            child: _buildMenuItem(
              'Instagram',
              HugeIcons.strokeRoundedInstagram,
              () => _launchUrl(widget.instagramUrl!),
            ),
          ),
        if (widget.emailUrl != null)
          PopupMenuItem(
            child: _buildMenuItem(
              'Email',
              HugeIcons.strokeRoundedMail01,
              () => _launchUrl("mailto:${widget.emailUrl!}"),
            ),
          ),
      ],
    );
  }

  Widget _buildMenuItem(String label, dynamic icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(icon: icon, color: Color(0xFFFFFFFF), size: 16),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        widget.caption!,
        style: TextStyle(
          color: Color(0xFFE8E8E8),
          fontSize: 15,
          height: 1.5,
          fontWeight: FontWeight.w400,
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
          if (hasCode && hasImage) const SizedBox(height: 12),
          if (hasImage) _buildImageBlock(),
        ],
      ),
    );
  }

  Widget _buildCodeBlock() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF161616),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF2A2A2A), width: 1),
              ),
            ),
            child: Text(
              '// Code',
              style: TextStyle(
                color: Color(0xFF808080),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                widget.code ?? '',
                style: TextStyle(
                  color: Color(0xFFBBBBBB),
                  fontSize: 11,
                  fontFamily: 'monospace',
                  height: 1.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBlock() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.imageUrl!,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 300,
            color: Color(0xFF1A1A1A),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF808080)),
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTags() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.tags!
            .map(
              (tag) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFF2A2A2A), width: 1),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    color: Color(0xFFB0B0B0),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildEngagementBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildEngagementButton(
            icon: HugeIcons.strokeRoundedFlash,
            count: _boosts,
            isActive: _isLiked,
            onTap: widget.isBoostDisabled ? null : _toggleLike,
            label: 'Boost',
            isDisabled: widget.isBoostDisabled,
          ),
          const Spacer(),
          _buildEngagementButton(
            icon: HugeIcons.strokeRoundedMail01,
            count: widget.messages,
            onTap: () {
              setState(() => _showReply = !_showReply);
              widget.onInbox?.call();
            },
            label: 'Reply',
          ),
          const Spacer(),
          _buildEngagementButton(
            icon: HugeIcons.strokeRoundedArrowUpRight01,
            count: widget.shares,
            onTap: widget.onShare,
            label: 'Share',
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementButton({
    required dynamic icon,
    required int count,
    VoidCallback? onTap,
    required String label,
    bool isActive = false,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: icon,
            color: isDisabled
                ? Color(0xFF404040)
                : (isActive ? Color(0xFFFFFFFF) : Color(0xFF606060)),
            size: 16,
          ),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Text(
              count.toString(),
              style: TextStyle(
                color: isDisabled
                    ? Color(0xFF404040)
                    : (isActive ? Color(0xFFFFFFFF) : Color(0xFF606060)),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyBox() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF161616),
        border: Border(top: BorderSide(color: Color(0xFF1A1A1A), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (widget.avatarUrl != null)
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF1A1A1A),
              backgroundImage: NetworkImage(widget.avatarUrl!),
            ),
          if (widget.avatarUrl != null) const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Color(0xFF2A2A2A), width: 1),
              ),
              child: TextField(
                controller: _replyInput,
                maxLines: null,
                style: TextStyle(color: Color(0xFFE8E8E8), fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Add your reply...',
                  hintStyle: TextStyle(color: Color(0xFF606060), fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              final msg = _replyInput.text.trim();
              if (msg.isEmpty) return;
              widget.onSendMessage?.call(msg);
              _replyInput.clear();
              setState(() => _showReply = false);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedMenu01,
                color: Color(0xFFFFFFFF),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
