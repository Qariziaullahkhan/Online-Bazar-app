import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController nameC, mobileC, cityC, emailC, passC, confirmPassC;

  int gender = 1;

  bool passVisible = false;
  bool confirmPassVisible = false;

  @override
  void initState() {
    nameC = TextEditingController();
    mobileC = TextEditingController();
    cityC = TextEditingController();
    emailC = TextEditingController();
    passC = TextEditingController();
    confirmPassC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    mobileC.dispose();
    cityC.dispose();
    emailC.dispose();
    passC.dispose();
    confirmPassC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: const Text(
          'Sign Up',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameC,
              decoration: InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              controller: mobileC,
              maxLength: 11,
              decoration: InputDecoration(
                  hintText: 'Mobile',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cityC,
              decoration: InputDecoration(
                  hintText: 'City',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailC,
              decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passC,
              obscureText: passVisible,
              decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passVisible = !passVisible;
                        });
                      },
                      icon: Icon(passVisible
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPassC,
              obscureText: confirmPassVisible,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          confirmPassVisible = !confirmPassVisible;
                        });
                      },
                      icon: Icon(confirmPassVisible
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                        value: 1,
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        }),
                    const Text('Male'),
                  ],
                ),
                const Gap(20),
                Row(
                  children: [
                    Radio(
                        value: 2,
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        }),
                    const Text('Female'),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(270, 60),
                primary: Colors.pink,
                onPrimary: Colors.white,
              ),
              onPressed: () async {
                String name = nameC.text.trim();

                if (name.isEmpty) {
                  // Toast
                  Fluttertoast.showToast(msg: 'Please provide Name');
                  return;
                }

                String mobile = mobileC.text.trim();
                if (mobile.isEmpty) {
                  Fluttertoast.showToast(msg: 'Please provide Mobile');
                  return;
                }

                if (mobile.length < 11) {
                  Fluttertoast.showToast(msg: 'Please provide a Valid Mobile');
                  return;
                }

                String pass = passC.text.trim();
                String confirmPass = confirmPassC.text.trim();

                if (pass != confirmPass) {
                  Fluttertoast.showToast(msg: 'Passwords do not match');
                  return;
                }

                String email = emailC.text.trim();

                try {
                  // Sign Up user using Firebase Auth
                  UserCredential? userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: pass,
                  );

                  if (userCredential.user != null) {
                    // Save data in Firestore database

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userCredential.user!.uid)
                        .set({
                      'id': userCredential.user!.uid,
                      'name': name,
                      'mobile': mobile,
                      'city': cityC.text.trim(),
                      'email': email,
                      'gender': gender == 1 ? 'Male' : 'Female',
                      'image': '',
                    });

                    Fluttertoast.showToast(msg: 'User Created');
                  } else {}
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already-in-use') {
                    Fluttertoast.showToast(msg: e.message.toString());
                  }

                  if (e.code == 'weak-password') {
                    Fluttertoast.showToast(msg: e.message.toString());
                  }
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
