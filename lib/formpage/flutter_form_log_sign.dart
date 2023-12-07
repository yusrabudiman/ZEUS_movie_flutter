import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spons/menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKeySignUp = GlobalKey<FormBuilderState>();
  final _formKeySignin = GlobalKey<FormBuilderState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void someFunction() async {
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      print(context.widget);
    }
  }

  String? Function(String?)? emailValidator = (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  };

  String? Function(String?)? passwordValidator = (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    var validator;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Login'),
              Tab(text: 'Sign Up'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // Login form
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FormBuilder(
                key: _formKeySignin,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      name: 'email',
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: emailValidator,
                    ),
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'password',
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: passwordValidator,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text("Submit"),
                      onPressed: () async {
                        _formKeySignin.currentState?.save();
                        if (_formKeySignin.currentState?.validate() == true) {
                          try {
                            // ignore: unused_local_variable
                            UserCredential userCredential =
                                await _auth.signInWithEmailAndPassword(
                              email: _formKeySignin
                                  .currentState?.fields['email']?.value,
                              password: _formKeySignin
                                  .currentState?.fields['password']?.value,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyWidget()),
                            );
                          } on FirebaseAuthException catch (e) {
                            String errorMessage =
                                'alamat email atau password tidak benar';
                            if (e.code == 'user-not-found') {
                              errorMessage = 'alamat email tidak tersedia';
                            } else if (e.code == 'wrong-password') {
                              errorMessage = 'password tidak benar';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                              ),
                            );
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            // Sign up form
            // TODO: Add sign up form here
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: FormBuilder(
                  key: _formKeySignUp,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: ListView(
                    children: <Widget>[
                      FormBuilderTextField(
                        name: 'realName',
                        decoration: InputDecoration(
                          labelText: 'Real Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: validator,
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: validator,
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'password',
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: validator,
                      ),
                      SizedBox(height: 10),

                      // FormBuilderTextField(
                      //   name: 'photoProfile',
                      //   decoration: InputDecoration(
                      //     labelText: 'Profile Picture URL',
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   validator: validator,
                      // ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'bio',
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          border: OutlineInputBorder(),
                        ),
                        validator: validator,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        child: Text("Submit"),
                        onPressed: () async {
                          _formKeySignUp.currentState?.save();
                          if (_formKeySignUp.currentState?.validate() == true) {
                            try {
                              // Sign up the user
                              UserCredential userCredential =
                                  await _auth.createUserWithEmailAndPassword(
                                email: _formKeySignUp
                                    .currentState?.fields['email']?.value,
                                password: _formKeySignUp
                                    .currentState?.fields['password']?.value,
                              );

                              // Save the user data to Firebase Realtime Database
                              DatabaseReference dbRef = FirebaseDatabase
                                  .instance
                                  .reference()
                                  .child('users')
                                  .child(userCredential.user!.uid);
                              await dbRef.set({
                                'realName': _formKeySignUp
                                    .currentState?.fields['realName']?.value,
                                'photoProfile': _formKeySignUp.currentState
                                    ?.fields['photoProfile']?.value,
                                'bio': _formKeySignUp
                                    .currentState?.fields['bio']?.value,
                              });

                              // Navigate to MyWidget after successful sign up
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyWidget()),
                              );
                            } catch (e) {
                              // Handle sign up error
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'An error occurred while signing up.'),
                                ),
                              );
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
