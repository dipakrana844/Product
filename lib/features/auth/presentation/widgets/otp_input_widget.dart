import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpInputWidget extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCodeChanged;
  final TextEditingController? controller;
  final VoidCallback? onClearRequested;

  const OtpInputWidget({
    super.key,
    this.length = 6,
    required this.onCodeChanged,
    this.controller,
    this.onClearRequested,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());

    // If a controller is provided, listen to it to populate fields?
    // Usually OTP is user-input, so we focus on updating the controller/callback.
  }

  @override
  void didUpdateWidget(OtpInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if clear was requested
    if (widget.onClearRequested != oldWidget.onClearRequested && widget.onClearRequested != null) {
      clearOtpFields();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Public method to clear all OTP fields, typically called after successful submission
  void clearOtpFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    if (widget.controller != null) {
      widget.controller!.clear();
    }
    // Focus the first field after clearing
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
    // Notify parent that the code has changed (now empty)
    widget.onCodeChanged('');
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      // If user pasted code (length > 1), handle it
      if (value.length > 1) {
        _handlePaste(value);
        return;
      }

      // Move next
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus(); // Last digit entered
      }
    } else {
      // Handle backspace - move previous if empty
      // Note: onChanged only fires when text changes.
      // If empty and backspace pressed, we need RawKeyboardListener usually,
      // but for simple cases, if value is empty it means we just deleted.
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    _updateParent();
  }

  void _handlePaste(String value) {
    String code = value;
    if (code.length > widget.length) {
      code = code.substring(0, widget.length);
    }

    for (int i = 0; i < code.length; i++) {
      _controllers[i].text = code[i];
    }

    // Fill remaining if any empty? No, paste usually replaces.

    // Focus last filled or next empty
    if (code.length < widget.length) {
      _focusNodes[code.length].requestFocus();
    } else {
      _focusNodes[widget.length - 1].unfocus();
    }

    _updateParent();
  }

  void _updateParent() {
    String code = _controllers.map((c) => c.text).join();
    widget.onCodeChanged(code);
    if (widget.controller != null) {
      widget.controller!.text = code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 45,
          height: 55,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            // maxLength: 1, // Remove built-in counter
            inputFormatters:
                [], // Could add length limiter here, but onChanged handles paste
            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '', // Hide counter
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Color(0xFF3F69B8), width: 2),
              ),
            ),
            onChanged: (value) => _onOtpChanged(value, index),
            onTap: () {
              // Select all content on tap to allow easy replacement
              _controllers[index].selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controllers[index].text.length,
              );
            },
          ),
        );
      }),
    );
  }
}
