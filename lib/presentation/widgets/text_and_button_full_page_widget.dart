import 'package:flutter/material.dart';

class TextAndButtonFullPageWidget extends StatelessWidget {
  String text;
  Widget? extraInfo;
  String buttonText;
  VoidCallback buttonOnPressed;
  TextAndButtonFullPageWidget({required this.text, required this.buttonOnPressed, required this.buttonText, this.extraInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,style: const TextStyle(fontSize: 18)),
          if(extraInfo!=null)extraInfo!,
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