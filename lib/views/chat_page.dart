import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final DocumentSnapshot doc;
  const ChatPage({super.key, required this.doc});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        
        title: Text(widget.doc.data() != null &&
                (widget.doc.data() as Map<String, dynamic>)
                    .containsKey('username')
            ? widget.doc['username']
            : 'Unknown User'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: widget.doc.reference
                    .collection("messages")
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.docs.isEmpty ?? true) {
                      return const Center(
                        child: Text("No messages yet"),
                      );
                    }

                    return ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          DocumentSnapshot msg = snapshot.data!.docs[index];
                          if (msg['sender uid'] ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    margin: const EdgeInsets.only(
                                        top: 10.0, left: 7.0, bottom: 10),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 99, 168, 102),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      msg['message'],
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 17),
                                    )),
                              ],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    margin: const EdgeInsets.only(
                                        top: 10.0, left: 7.0, bottom: 10),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      msg['message'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 17),
                                    )),
                              ],
                            );
                          }
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Type a message',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                        )),
                  ),
                  controller: messageController,
                )),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.indigo,
                    size: 25,
                  ),
                  onPressed: () async {
                    await widget.doc.reference.collection('messages').add({
                      'message': messageController.text,
                      'time': DateTime.now(),
                      'sender uid': FirebaseAuth.instance.currentUser!.uid,
                    });
                    messageController.text = '';
                    // await widget.doc.reference.update({
                    //   'recent_text': DateTime.now(),
                    // });
                    // messageController.text = '';
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
