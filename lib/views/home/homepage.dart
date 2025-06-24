import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salsabil/auth/login.dart';
import 'package:salsabil/views/home/search.dart';
import 'package:salsabil/views/home/utils/image_post.dart';
import 'package:salsabil/views/home/utils/text_post.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Search()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Sign out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.indigo),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(13.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: postController,
                    decoration: const InputDecoration(
                      labelText: 'Post something',
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          var data = {
                            'type': "text",
                            'time': DateTime.now(),
                            'content': postController.text,
                            'uid': FirebaseAuth.instance.currentUser!.uid,
                          };
                          await FirebaseFirestore.instance
                              .collection('posts')
                              .add(data);
                          postController.clear();
                        },
                        child: const Text('Post'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('timeline')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading posts');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No Post for you');
                  } else {
                    final timelineDocs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: timelineDocs.length,
                      itemBuilder: (context, index) {
                        final postId = (timelineDocs[index].data()
                            as Map<String, dynamic>)['post'];
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(postId)
                              .get(),
                          builder: (context, postSnapshot) {
                            if (postSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (postSnapshot.hasError ||
                                !postSnapshot.hasData) {
                              return const Text('Error loading post');
                            } else {
                              final post = postSnapshot.data!;
                              final postType = post['type'];
                              if (postType == 'text') {
                                return TextPost(text: post['content']);
                              } else if (postType == 'image') {
                                return ImagePost(
                                  imageUrl: post['url'],
                                  text: post['content'],
                                );
                              } else {
                                return TextPost(text: post['content']);
                              }
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
