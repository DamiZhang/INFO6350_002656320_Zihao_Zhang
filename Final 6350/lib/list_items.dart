import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:info_6350_final_project/bean/bean_post.dart';
import 'package:info_6350_final_project/config/config_document.dart';
import 'package:info_6350_final_project/page_sign_in.dart';
import 'package:info_6350_final_project/utils/utils_logger.dart';
import 'item_detail.dart';
import 'page_new_post.dart';

class BrowsePostsActivity extends StatefulWidget {
  final User user;

  const BrowsePostsActivity({super.key, required this.user});

  @override
  State<BrowsePostsActivity> createState() => _BrowsePostsActivityState();
}

class _BrowsePostsActivityState extends State<BrowsePostsActivity> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hyper Garage Sale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _firebaseAuth.signOut();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewPostActivity(user: widget.user)),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(DocumentConfig.myPosts)
            .where('userId', isEqualTo: widget.user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          LoggerUtils.i("User UID: ${widget.user.uid}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          LoggerUtils.i("Fetched documents: ${snapshot.data!.docs}");

          var docs = snapshot.data?.docs;
          if (docs == null || docs.isEmpty) {
            return const Center(child: Text('no data'));
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
              itemBuilder: (context, index) {
                final doc = docs[index];
                var postBean = PostBean.fromJson(doc.data(), doc.id);

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: postBean.images.isNotEmpty
                        ? Image.network(
                            postBean.images[0],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/placeholder-image.jpg',
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                    title: Text(
                      doc['title'],
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    subtitle: Text(
                      '\$${doc['price'].toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetail(docId: doc.id),
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: snapshot.data!.docs.length,
            ),
          );
        },
      ),
    );
  }
}
