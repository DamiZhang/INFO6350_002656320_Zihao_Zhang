import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String imageTitle;
  final String screen;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    required this.imageTitle,
    required this.screen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(imageTitle)),
      backgroundColor: Colors.black,
      body: Center(
        child: screen == "NewPost"
            ? Image.file(File(imagePath))
            : Image.network(imagePath),
      ),
    );
  }
}
