import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {required this.title,
      required this.onValidate,
      this.textEditingController,
      this.textInputType,
      this.hintText,
      this.obsecureText,
      this.onChanged,
      super.key});

  final String title;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final String? hintText;
  final bool? obsecureText;
  final String? Function(String?)? onValidate;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textEditingController,
          keyboardType: textInputType,
          cursorColor: Colors.blue,
          obscureText: obsecureText ?? false,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          style: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          validator: onValidate,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
