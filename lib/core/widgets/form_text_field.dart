import 'package:flutter/material.dart';


class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool borderOnly;

  const FormTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.borderOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && !borderOnly)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(label!, style: Theme.of(context).textTheme.labelLarge),
          ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: borderOnly ? label : null,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey), 
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,

            
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),

            
            floatingLabelBehavior: FloatingLabelBehavior.auto,

            
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                5.0,
              ), 
              borderSide: const BorderSide(color: Color(0xFFC4C4C4)), 
            ),

            
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(color: Color(0xFFC4C4C4)),
            ),

            
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                color: Color(0xFF3F69B8),
                width: 1.5,
              ),
            ),

            
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),

            
            filled: true,
            fillColor: Colors.white,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
