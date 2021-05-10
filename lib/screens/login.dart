import 'package:flutter/material.dart';
import 'package:tour_wist/util/app_colors.dart';
import 'main_screen.dart';
import 'register_screen.dart';
import 'home.dart';

import '../util/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  bool _isSigningIn = false;

  @override
  void initState() {
    super.initState();
  }

  void _onSubmit() {
    Navigator.pushNamedAndRemoveUntil(
        context, Home.routeName, (route) => false);
  }

  void _createAccount(){
    Navigator.pushNamedAndRemoveUntil(
        context, RegisterScreen.routeName, (route) => false);
  }

  void _signInWithEmailAndPassword() async {
    final User user = (await _auth.signInWithEmailAndPassword(
      email: _usernameController.text,
      password: _passwordController.text,
    ))
        .user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
        _onSubmit();
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/logo.jpg')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 20.0
                    ),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 20.0
                    ),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            FlatButton(
              onPressed: () {

              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: ()  {
                  _signInWithEmailAndPassword();
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),

            ),
            SizedBox(
              height: 10,
            ),
            SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed:() async {
                  setState(() {
                    _isSigningIn = true;
                  });
                  User user = await Authentication.signInWithGoogle(context: context);
                  setState(() {
                    _isSigningIn = false;
                  });
                  if (user != null){
                    Navigator.pushNamed(context, MainScreen.routeName);
                  }
                },
            ),

            SizedBox(
              height: 90,
            ),
            TextButton(
              child: Text("Create Account"),
              onPressed: _createAccount,
            )
          ],
        ),
      ),
    );
  }
}
