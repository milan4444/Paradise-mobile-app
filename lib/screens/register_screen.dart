import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../util/app_colors.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _selectedGender = TextEditingController();
  DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("UsersReg");


  bool _success;
  String _userEmail;

  String _validateName(String name) {
    if (name == null || name.isEmpty) return 'required';
    return null;
  }

  String _validateUsername(String email) {
    if (email == null || email.isEmpty) return 'required';
    bool valid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!valid) return 'invalid format';
    return null;
  }

  String _validatePassword(String password) {
    if (password == null || password.isEmpty) return 'required';
    return null;
  }

  String _validateConfirmPassword(String password) {
    if (password == null || password.isEmpty) return 'required';
    if (password != _passwordController.text) return 'passwords should match';
    return null;
  }

  String _validateGender(String gender) {
    if (gender == null) return 'required';
    return null;
  }

  String _validateBirthDay(DateTime date) {
    if (date == null) return 'required';
    return null;
  }

  void _login_page(){
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  void _register(){
    _auth.createUserWithEmailAndPassword(email: _usernameController.text, password: _passwordController.text)
        .then((result) {
      dbRef.child(result.user.uid).set({
        'email' :_usernameController.text,
        'name' : _nameController.text,
        'dob' : _ageController.text,
        'gender' : _selectedGender.text,
      }).then((res){
        _success = false;

      });
    }).catchError((err){
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                },
                  child: Text("OK!"),
                )
              ],
            );
          });
    });
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _selectedGender.dispose();
    _ageController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.iconColor,
            ),
            onPressed: _login_page
            ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2)),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'Name',
                      ),
                      validator: _validateName,
                    ),
                    TextField(
                      controller: _ageController,
                      decoration:InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'Age',
                      ),
                    ),
                    TextFormField(
                      controller: _selectedGender,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'Gender',
                      ),
                      validator: _validateGender,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'Email Address',
                      ),
                      validator: _validateUsername,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'Password',
                      ),
                      validator: _validatePassword,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'Confirm Password',
                      ),
                      validator: _validateConfirmPassword,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        elevation: 1,
                        textColor: Colors.white,
                        color: AppColors.primaryColor,
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            _register();
                            //_login_page();
                            AlertDialog(
                              title : Text ("Registration"),
                              content : Text ("Registred to Eat'D"),
                              actions: [
                                FlatButton(
                                  child: Text ('OK'),
                                  onPressed: _login_page,
                                )
                              ],
                            );
                          }
                        },

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
