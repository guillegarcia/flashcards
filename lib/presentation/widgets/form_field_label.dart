import 'package:flutter/material.dart';

class FormFieldLabel extends StatelessWidget {
  final String text;
  const FormFieldLabel(this.text,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(this.text,style: TextStyle(fontSize: 16)),
    );
  }
}
