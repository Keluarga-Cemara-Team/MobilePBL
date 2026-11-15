import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';

class OtpBoxInput extends StatefulWidget {
  const OtpBoxInput({
    super.key,
    this.length = 6,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onCompleted,
  });

  final int length;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpBoxInput> createState() => _OtpBoxInputState();
}

class _OtpBoxInputState extends State<OtpBoxInput> {
  late final FocusNode _internalFocusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _effectiveFocusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_handleTextChange);
    _internalFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) setState(() {});
  }

  void _handleTextChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;
    final isFocused = _effectiveFocusNode.hasFocus;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Barisan visual kotak-kotak digit
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.length, (index) {
            final isFilled = index < text.length;
            final isCurrent = isFocused && index == text.length;
            final digit = isFilled ? text[index] : '';

            final borderColor = isCurrent
                ? AppColors.of(context).primary
                : (isFilled
                    ? AppColors.of(context).primary.withValues(alpha: 0.7)
                    : AppColors.of(context).border);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: context.ui(46),
              height: context.ui(54),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E2333)
                    : Colors.white,
                borderRadius: BorderRadius.circular(context.ui(12)),
                border: Border.all(
                  color: borderColor,
                  width: isCurrent ? 2.0 : 1.5,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.of(context)
                              .primary
                              .withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                digit,
                style: TextStyle(
                  fontSize: context.ui(22),
                  fontWeight: FontWeight.bold,
                  color: AppColors.of(context).navy,
                ),
              ),
            );
          }),
        ),

        // Invisible TextField di atasnya untuk menangani ketikan keyboard & backspace
        Opacity(
          opacity: 0.0,
          child: TextField(
            controller: widget.controller,
            focusNode: _effectiveFocusNode,
            keyboardType: TextInputType.number,
            maxLength: widget.length,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            cursorColor: Colors.transparent,
            style: const TextStyle(color: Colors.transparent),
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              counterText: '',
            ),
            onChanged: (value) {
              widget.onChanged?.call(value);
              if (value.length == widget.length) {
                widget.onCompleted?.call(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
