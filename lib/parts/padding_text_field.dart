import 'package:flutter/material.dart';

class PaddingTextField extends StatelessWidget {
  final String? hint;
  final bool? obscureText;
  final Function(String)? onChanged;
  const PaddingTextField({Key? key, this.hint, this.obscureText, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: onChanged,
        obscureText: obscureText!,
        decoration: InputDecoration(
          hintText: hint,
        ),
      ),
    );
  }

}