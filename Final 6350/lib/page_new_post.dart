import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:info_6350_final_project/bean/bean_post.dart';
import 'package:info_6350_final_project/config/config_document.dart';
import 'package:info_6350_final_project/utils/utils_logger.dart';
import 'dart:io';

class NewPostActivity extends StatefulWidget {
  final User user;

  const NewPostActivity({super.key, required this.user});

  @override
  State<NewPostActivity> createState() => _NewPostActivityState();
}

class _NewPostActivityState extends State<NewPostActivity> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  static int maxImgCount = 4;
  final List<String> _images = [];

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= maxImgCount) {
      return;
    }
    try {
      final XFile? photo;
      if (source == ImageSource.camera) {
        photo = await _imagePicker.pickImage(source: ImageSource.camera);
      } else {
        photo = await _imagePicker.pickImage(source: ImageSource.gallery);
      }
      if (photo == null) {
        return;
      }
      final storageRef = FirebaseStorage.instance.ref();
      var nameRef = storageRef.child(photo.name);
      var namePathRef = storageRef.child("images/${photo.name}");

      assert(nameRef.name == namePathRef.name);
      assert(nameRef.fullPath != namePathRef.fullPath);
      LoggerUtils.i(photo.path);
      await nameRef.putFile(File(photo.path));
      var url = await nameRef.getDownloadURL();
      LoggerUtils.i(url);
      setState(() {
        _images.add(url);
      });
    } catch (e) {
      LoggerUtils.e(e);
    }
  }

  Future<void> _submit() async {
    if (!mounted) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and add at least one image'),
        ),
      );
      return;
    }
    var title = _titleController.text;
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
        ),
      );
      return;
    }
    var price = _priceController.text;
    if (price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a price'),
        ),
      );
      return;
    }

    var description = _descriptionController.text;
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description'),
        ),
      );
      return;
    }

    var post = PostBean(
      "",
      title,
      double.parse(price),
      description,
      widget.user.uid,
      _images,
      DateTime.now().millisecondsSinceEpoch,
    );

    try {
      await FirebaseFirestore.instance.collection(DocumentConfig.myPosts).add(post.toJson());
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while submitting the post: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Post'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_images.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                itemCount: _images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return Image.network(
                    _images[index],
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  );
                },
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Select Image'),
                ),
                TextButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                    // primary: theme.primaryColor,
                    // onPrimary: theme.primaryTextTheme.button!.color,
                    ),
                child: const Text('Post Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
