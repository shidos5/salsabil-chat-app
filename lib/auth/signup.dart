// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:salsabil/auth/login.dart';
import 'package:salsabil/views/home/home.dart';
import 'package:salsabil/widget/mybutton.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String? userName;
  String? email;
  String? password;
  GlobalKey<FormState> Key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Sign Up"),
      ),
      body: Form(
        key: Key,
        child: ListView(padding: const EdgeInsets.all(12.0), children: [
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "username",
            ),
            validator: ValidationBuilder().maxLength(10).build(),
            onChanged: (value) {
              userName = value;
            },
          ),
          SizedBox(
            height: 12.0,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
            ),
            validator: ValidationBuilder().email().maxLength(50).build(),
            onChanged: (value) {
              email = value;
            },
          ),
          SizedBox(
            height: 12.0,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Password",
            ),
            validator: ValidationBuilder().maxLength(15).minLength(6).build(),
            onChanged: (value) {
              password = value;
            },
          ),
          SizedBox(
            height: 12.0,
          ),
          Mybutton(
            text: 'Sign Up',
            onPressed: () async {
              if (Key.currentState?.validate() ?? false) {
                print(email);

                try {
                 UserCredential userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email!, password: password!);
                      if(userCredential.user!=null){
                        // add to database
                        var data =
                       { 'username':userName,
                        'email':email, 
                        'createdAt':DateTime.now()
                        };
                        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(data);
                      }
                  if (mounted) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              }
            },
          ),
          SizedBox(
            height: 12.0,
          ),
          Row(
            children: [
              Text("Already Hava an Account? "),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ]),
      ),
    );
  }
}
