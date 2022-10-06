import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Activity.dart';

class SignIn extends StatefulWidget {
  final Function toggleForm;
  SignIn({Key? key, required this.toggleForm}) : super(key: key);

  @override
  SignInForm createState() => SignInForm();
}

class SignInForm extends State<SignIn> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String errors = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => widget.toggleForm(),
            icon: Icon(Icons.person),
            label: Text('Sign Up'),
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white)),
          )
        ],
      ),
      body: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
              onChanged: (val) {
                setState(() => email = val);
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                return null;
              },
            ),
            TextFormField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
              onChanged: (val) {
                setState(() => password = val);
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_signInFormKey.currentState!.validate()) {
                    // Process data.
                    dynamic result = await signIn(email, password);
                    if (result is User) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Activity()));
                    } else {
                      setState(() => errors = result);
                    }
                  }
                },
                child: const Text('Log in'),
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              errors,
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
      ),
    );
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential _userCreds = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return _userCreds.user;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
