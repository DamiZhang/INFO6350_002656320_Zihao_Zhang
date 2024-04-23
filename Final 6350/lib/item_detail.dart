import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:info_6350_final_project/bean/bean_post.dart';
import 'package:info_6350_final_project/config/config_document.dart';
import 'package:info_6350_final_project/page_pic_previewer.dart';
import 'package:info_6350_final_project/utils/utils_logger.dart';

class ItemDetail extends StatefulWidget {
  final String docId;

  const ItemDetail({required this.docId, super.key});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final db = FirebaseFirestore.instance;

  Future<PostBean> _getItemDetail() async {
    var doc =
        await db.collection(DocumentConfig.myPosts).doc(widget.docId).get();
    return PostBean.fromJson(doc.data(), doc.id);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: _getItemDetail(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var doc = snapshot.data;
            LoggerUtils.i(doc);
            if (doc == null) {
              return const Center(child: Text('no data'));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 300,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: doc.images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => PicPreviewerPage(
                                    imageUrl: doc.images[index])));
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Image.network(
                            doc.images[index],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          doc.title,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "\$${doc.price}",
                        style: theme.textTheme.titleLarge
                            ?.copyWith(color: theme.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Description",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      doc.description,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
