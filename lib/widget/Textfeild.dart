import 'package:flutter/material.dart';

class AnimatedCapsuleTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? isPassowrd;

  const AnimatedCapsuleTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.validator,
    this.isPassowrd,
  });

  @override
  State<AnimatedCapsuleTextField> createState() =>
      _AnimatedCapsuleTextFieldState();
}

class _AnimatedCapsuleTextFieldState extends State<AnimatedCapsuleTextField> {
  final FocusNode _focusNode = FocusNode();
  bool hasFocus = false;
  bool showError = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final errorText = widget.validator?.call(widget.controller.text) ?? null;
    showError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedScale(
          scale: hasFocus ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                width: hasFocus ? 3 : 2,
                color: showError
                    ? Colors.red
                    : hasFocus
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
            child: TextFormField(
              focusNode: _focusNode,
              obscureText: widget.isPassowrd ?? false,
              controller: widget.controller,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.hint,
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Error Message Animation
        AnimatedOpacity(
          opacity: showError ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            errorText ?? "",
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
