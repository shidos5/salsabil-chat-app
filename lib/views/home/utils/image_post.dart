import 'package:flutter/material.dart';

class ImagePost extends StatelessWidget {
  final String text;
  final String imageUrl;
  const ImagePost({super.key,required this.text,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(13.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      padding: const EdgeInsets.all(13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1/1,
            child: Image.network(imageUrl,fit: BoxFit.cover,)),
            SizedBox(height: 3.0),
            Text(text),
          
        ],
      )
    );
  }
}