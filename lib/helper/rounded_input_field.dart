import 'package:flutter/material.dart';
import 'package:invenzine/helper/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        cursorColor: Colors.black54,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.black45,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
