// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  String text;
  Function()? onPressed;
  Mybutton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.indigo,
        ),
        width: double.infinity,
        height: 40.0,
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 19),
        )),
      ),
    );
  }
}
