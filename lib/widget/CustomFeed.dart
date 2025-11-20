import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hugeicons/hugeicons.dart';

class MatrixRainPostWidget extends StatefulWidget {
  final String? author;
  final String? avatarUrl; // Changed from avatar emoji to URL
  final String? time;
  final String? caption;
  final String? code;
  final String? imageUrl; // Changed from imageEmoji to URL
  final List<String>? tags;
  final int boosts;
  final int messages;
  final int shares;

  // Social Links - Optional
  final String? githubUrl;
  final String? instagramUrl;
  final String? xUrl;
  final String? linkedinUrl;
  final String? emailUrl;

  final VoidCallback? onBoost;
  final VoidCallback? onInbox;
  final VoidCallback? onShare;

  const MatrixRainPostWidget({
    Key? key,
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
  }) : super(key: key);

  @override
  State<MatrixRainPostWidget> createState() => _MatrixRainPostWidgetState();
}

class _MatrixRainPostWidgetState extends State<MatrixRainPostWidget> {
  late int _boosts;
  bool _showInbox = false;

  @override
  void initState() {
    super.initState();
    _boosts = widget.boosts;
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
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
          // Social Icons Row
          if (widget.avatarUrl != null || widget.author != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  // GitHub
                  if (widget.githubUrl != null)
                    _buildSocialIconButton(
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedGithub,
                        color: MatrixRainColors.green400,
                        size: 30,
                      ),
                      MatrixRainColors.green400,
                      () => _launchUrl(widget.githubUrl!),
                    ),
                  if (widget.githubUrl != null) const SizedBox(width: 12),

                  // Instagram
                  if (widget.instagramUrl != null)
                    _buildSocialIconButton(
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedInstagram,
                        color: MatrixRainColors.lime400,
                        size: 30,
                      ),
                      MatrixRainColors.lime400,
                      () => _launchUrl(widget.instagramUrl!),
                    ),
                  if (widget.instagramUrl != null) const SizedBox(width: 12),

                  // LinkedIn
                  if (widget.linkedinUrl != null)
                    _buildSocialIconButton(
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedLinkedin01,
                        color: MatrixRainColors.emerald400,
                        size: 30,
                      ),
                      MatrixRainColors.emerald400,
                      () => _launchUrl(widget.linkedinUrl!),
                    ),
                  if (widget.linkedinUrl != null) const SizedBox(width: 12),

                  // X (Twitter)
                  if (widget.xUrl != null)
                    _buildSocialIconButton(
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedNewTwitter,
                        color: MatrixRainColors.teal400,
                        size: 30,
                      ),
                      MatrixRainColors.teal400,
                      () => _launchUrl(widget.xUrl!),
                    ),
                  if (widget.xUrl != null) const SizedBox(width: 12),

                  // Email
                  if (widget.emailUrl != null)
                    _buildSocialIconButton(
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedMail01,
                        color: MatrixRainColors.green300,
                        size: 30,
                      ),
                      MatrixRainColors.green300,
                      () => _launchUrl('mailto:${widget.emailUrl!}'),
                    ),

                  // Show default icons if no social links provided
                  if (widget.githubUrl == null &&
                      widget.instagramUrl == null &&
                      widget.linkedinUrl == null &&
                      widget.xUrl == null &&
                      widget.emailUrl == null) ...[
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedCode,
                      color: MatrixRainColors.green400,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedCamel,
                      color: MatrixRainColors.lime400,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedUser,
                      color: MatrixRainColors.emerald400,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedLine,
                      color: MatrixRainColors.teal400,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedMail01,
                      color: MatrixRainColors.green300,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Profile Section
          if (widget.avatarUrl != null || widget.author != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  if (widget.avatarUrl != null)
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.avatarUrl!),
                      backgroundColor: MatrixRainColors.bgGreenTint,
                    ),
                  if (widget.avatarUrl != null) const SizedBox(width: 12),
                  Expanded(
                    child: Column(
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
                        if (widget.time != null)
                          Text(
                            widget.time!,
                            style: const TextStyle(
                              color: MatrixRainColors.textGray500,
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Caption
          if (widget.caption != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.caption!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Code or Image Section
          if (widget.code != null || widget.imageUrl != null)
            _buildContentSection(),

          // Tags
          if (widget.tags != null && widget.tags!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.tags!
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1a4d3a),
                          border: Border.all(
                            color: MatrixRainColors.borderGreen,
                            width: 1,
                          ),
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
            ),
          ],

          // Stats Section
          if (widget.boosts > 0 ||
              widget.messages > 0 ||
              widget.shares > 0) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: MatrixRainColors.borderGreen, height: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(
                    'BOOSTS',
                    '$_boosts',
                    MatrixRainColors.green400,
                  ),
                  if (widget.messages > 0 || widget.shares > 0)
                    Container(
                      width: 1,
                      height: 40,
                      color: MatrixRainColors.borderGreen,
                    ),
                  if (widget.messages > 0)
                    _buildStatColumn(
                      'MSGS',
                      '${widget.messages}',
                      MatrixRainColors.lime400,
                    ),
                  if (widget.messages > 0 && widget.shares > 0)
                    Container(
                      width: 1,
                      height: 40,
                      color: MatrixRainColors.borderGreen,
                    ),
                  if (widget.shares > 0)
                    _buildStatColumn(
                      'SHARE',
                      '${widget.shares}',
                      MatrixRainColors.emerald400,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: MatrixRainColors.borderGreen, height: 1),
            ),
          ],

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Boost',
                    Icons.flash_on,
                    MatrixRainColors.green400,
                    () {
                      setState(() => _boosts++);
                      widget.onBoost?.call();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Inbox',
                    Icons.mail_outline,
                    MatrixRainColors.lime400,
                    () {
                      setState(() => _showInbox = !_showInbox);
                      widget.onInbox?.call();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Share',
                    Icons.share,
                    MatrixRainColors.emerald400,
                    () => widget.onShare?.call(),
                  ),
                ),
              ],
            ),
          ),

          // Inbox Modal
          if (_showInbox) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: MatrixRainColors.borderGreen, height: 1),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0a2e1a),
                  border: Border.all(
                    color: MatrixRainColors.borderGreen,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            color: MatrixRainColors.green400,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Reply...',
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MatrixRainColors.green600,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Send',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    final hasCode = widget.code != null && widget.code!.isNotEmpty;
    final hasImage = widget.imageUrl != null && widget.imageUrl!.isNotEmpty;

    // Code Focus
    if (hasCode && !hasImage) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [_buildCodeBlock()]),
      );
    }

    // Image Focus
    if (hasImage && !hasCode) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [_buildImageBlock()]),
      );
    }

    // Both Code and Image
    if (hasCode && hasImage) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildCodeBlock(),
            const SizedBox(height: 12),
            _buildImageBlock(),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '▶ run_code()',
            style: const TextStyle(
              color: MatrixRainColors.green400,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.code ?? '',
            style: const TextStyle(
              color: MatrixRainColors.lime400,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '▼ success',
            style: const TextStyle(
              color: MatrixRainColors.green400,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBlockSmall() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black38,
        border: Border.all(color: MatrixRainColors.borderGreen, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '▶ run_code()',
            style: const TextStyle(
              color: MatrixRainColors.green400,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.code ?? '',
            style: const TextStyle(
              color: MatrixRainColors.lime400,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '▼ success',
            style: const TextStyle(
              color: MatrixRainColors.green400,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBlock() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MatrixRainColors.green600, Color(0xFF059669)],
        ),
        border: Border.all(color: MatrixRainColors.borderGreen, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image.network(
          widget.imageUrl ?? '',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.image_not_supported,
                color: MatrixRainColors.green400,
                size: 50,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(
                  MatrixRainColors.green400,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Icon(icon, color: color, size: 20);
  }

  Widget _buildSocialIconButton(
    Widget icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return GestureDetector(onTap: onPressed, child: icon);
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: MatrixRainColors.textGray500,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 1),
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
