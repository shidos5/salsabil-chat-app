import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:salsabil/auth/signup.dart';
import 'package:salsabil/views/home/home.dart';
import 'package:salsabil/widget/mybutton.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;
  GlobalKey<FormState> Key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Login"),
      ),
      body: Form(
        key: Key,
        child: ListView(padding: const EdgeInsets.all(12.0), children: [
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
                border: OutlineInputBorder(), labelText: "Password"),
            validator: ValidationBuilder().maxLength(15).minLength(6).build(),
            onChanged: (value) {
              password = value;
            },
          ),
          SizedBox(
            height: 12.0,
          ),
          SizedBox(
            height: 12.0,
          ),
          Mybutton(
            text: 'Login',
            onPressed: () async {
              if (Key.currentState?.validate() ?? false) {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email!, password: password!);
                  if (mounted) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    // ignore: avoid_print
                    print('That user not found');
                  }
                  if (e.code == 'wrong-password') {
                    // ignore: avoid_print
                    print('That password is wrong.');
                  }
                } catch (e) {
                  // ignore: avoid_print
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
              Text("Don't Hava an Account? "),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: Text(
                    'Sign Up',
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
