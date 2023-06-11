import 'package:flutter/material.dart';

class TextAndButtonFullPageWidget extends StatelessWidget {
  String text;
  String? subText;
  String buttonText;
  VoidCallback buttonOnPressed;
  TextAndButtonFullPageWidget({required this.text, required this.buttonOnPressed, required this.buttonText, this.subText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,style: const TextStyle(fontSize: 18)),
          if(subText!=null)Text(subText!),
          ElevatedButton(
              onPressed: buttonOnPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              child: Text(buttonText))
        ],
      ),
    );
  }
}