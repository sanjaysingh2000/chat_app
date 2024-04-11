import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _eneteredEmail = '';
  var _enteredPassword = '';
  var _isLogin = true;

  void _submit() async {
    final isValid = _form.currentState!.validate(); // validate() returns boolean

    if (isValid) {
      _form.currentState!.save();
    }
    try{
    if (_isLogin) {
      final userCredential = await _firebase.signInWithEmailAndPassword(
          email: _eneteredEmail, password: _enteredPassword);
      print(userCredential);
    } else {
      final userCredential = await _firebase.createUserWithEmailAndPassword(
          email: _eneteredEmail, password: _enteredPassword);
      print(userCredential);
    }
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {

        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Authentication failed')));
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                elevation: 1,
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            onSaved: (newValue) {
                              _eneteredEmail = newValue!;
                              print(_eneteredEmail);
                            },
                            validator: (value) {
                              if (value == null ||
                                  value
                                      .trim()
                                      .isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter valid email address';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              label: Text('Email'),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              _enteredPassword = newValue!;
                              print(_enteredPassword);
                            },
                            validator: (value) {
                              if (value == null || value
                                  .trim()
                                  .length != 6) {
                                return ' Password must be at least 6 character long';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              label: Text('Password'),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme
                                    .of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(_isLogin ? 'Login' : 'Signup')),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I already have an account. Login Instead.'))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
