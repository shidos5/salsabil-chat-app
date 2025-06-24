import 'package:flutter/material.dart';

class TextPost extends StatelessWidget {
  final String text;
  const TextPost({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(13.0),
      ),
      padding: const EdgeInsets.all(13.0),
      child: Text(text),
    );
  }
}