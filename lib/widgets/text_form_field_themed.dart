import 'package:flutter/material.dart';
import 'package:chatapp/theme/theme.dart';

class TextFormFieldThemed extends StatefulWidget {
  TextFormFieldThemed({
    Key? key,
    required this.focusNode,
    required this.labelText,
    required this.icon,
    required this.onChanged,
    required this.validator,
    required this.textEditingController,
    required this.error,
    this.obscureText = false,
  }) : super(key: key);

  final FocusNode focusNode;
  final String labelText;
  final Icon icon;
  String? error;
  bool obscureText;
  // function returns string or null
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;

  @override
  State<TextFormFieldThemed> createState() => _TextFormFieldThemedState();
}

class _TextFormFieldThemedState extends State<TextFormFieldThemed> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: AppTheme.textfocusedState(widget.focusNode),
        ),
        border: widget.error != null ? OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ) : null,
        prefixIcon: widget.icon,
        prefixIconColor: AppTheme.iconBlackFocused(),
      ),
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
