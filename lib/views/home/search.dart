import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'Search',
          style: TextStyle(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter username',
              ),
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
            ),
          ),
          if (userName != null && userName!.length > 3)
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isEqualTo: userName)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.indigo,
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No user found'),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return ListTile(
                        leading: IconButton(
                            onPressed: () async {
                              QuerySnapshot q = await FirebaseFirestore.instance
                                  .collection('chats')
                                  .where('users',
                                      arrayContains: [FirebaseAuth
                                          .instance.currentUser!.uid , doc.id])
                                  .get();

                                if(q.docs.isEmpty){
                                  //creat new chat
                                  print("Yes doc");
                                  var data ={
                                    'users':[FirebaseAuth
                                          .instance.currentUser!.uid,
                                          doc.id],
                                          'recent text':'hi'
                                  };
                                 await FirebaseFirestore.instance
                                  .collection('chats').add(data);
                                  print("No doc");
                                }  else{
                                  //open chat
                                }
                            },
                            icon: Icon(
                              Icons.chat,
                              color: Colors.indigo,
                            )),
                        title: Text(doc.get('username')),
                        subtitle: Text(doc.get('email')),
                        trailing: FutureBuilder<DocumentSnapshot>(
                          future: doc.reference
                              .collection('followers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                color: Colors.indigo,
                              );
                            }
                            bool isFollowing = snapshot.data?.exists ?? false;
                            return ElevatedButton(
                              onPressed: () async {
                                if (isFollowing) {
                                  await doc.reference
                                      .collection('followers')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .delete();
                                } else {
                                  await doc.reference
                                      .collection('followers')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .set({'time': DateTime.now()});
                                }
                                setState(() {});
                              },
                              child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
