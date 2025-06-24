import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salsabil/views/chat_page.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chats"),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('chats').where('users',
              arrayContains: FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data?.docs.isEmpty??true ){
                return const Center(
                  child: Text("No chats found"),
                );
              }
               return ListView.builder(
                itemCount: snapshot.data?.docs.length??0,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                return ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(doc: doc)));
                  },
                 title: Text('DATA'),
                 trailing: Icon(Icons.arrow_forward_ios),
                 subtitle: Text((doc.data() as Map<String, dynamic>).containsKey('recent_text') ? doc['recent_text'] : 'No recent text'),
                );
               });
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
           
          },
        ));
  }
}
