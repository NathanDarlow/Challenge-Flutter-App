import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tbb/ui/login_screen.dart';
import 'package:tbb/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tbb/resources/repository.dart';
import 'package:tbb/ui/insta_home_screen.dart';
import 'package:tbb/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  final Firestore _firestore = Firestore.instance;


  var _repository = Repository();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String displayName = "";
  String photoUrl = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.sackettwaconia.com%2Fdefault-profile%2F&psig=AOvVaw0j60JtkJf43JiLWcYHRHiW&ust=1586733128442000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCLi6j-K_4egCFQAAAAAdAAAAABAD";

  File _image;
  
  Future getImage() async {
      var photoUrl = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = photoUrl;
          print('Image Path $_image');
      });
    }

    

  @override
  Widget build(BuildContext context) {
    final appBar = Padding(
      padding: EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return LoginScreen();
        })),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          )
        ],
      ),
    );

    final pageTitle = Container(
      child: Text(
        "Tell us about you.",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 40.0,
        ),
      ),
    );

    final photoUrlField = Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Color(0xff476cfb),
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image!=null)?Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ):Image.network(
                            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.sackettwaconia.com%2Fdefault-profile%2F&psig=AOvVaw0j60JtkJf43JiLWcYHRHiW&ust=1586733128442000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCLi6j-K_4egCFQAAAAAdAAAAABAD",
                            fit: BoxFit.fill,
                          ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 30.0,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]
          );

    final displayNameField = TextFormField(
      validator: 
        (input) {
            if(input.isEmpty) {
              return 'Please enter a Username';
          }
        },
        onChanged: (val) {
                  setState(() => displayName = val);
                },
      onSaved: ((input) => displayName = input),
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.black,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
    );


    final emailField = TextFormField(
      validator: 
        (input) {
            if(input.isEmpty) {
              return 'Please enter an email';
          }
        },
        onChanged: (val) {
          setState(() => email = val);
        },
        onSaved: (input) => email = input,
        decoration: InputDecoration(
          labelText: 'Email Address',
          labelStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(
            Icons.mail,
            color: Colors.black,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
    );

    final passwordField = TextFormField(
      validator: (input) {
                if(input.length < 6) {
                  return 'Your passwords needs to be atleast 6 characters';
                }
              },
              onChanged: (val) {
                  setState(() => password = val);
                },
              onSaved: (input) => password = input,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.black,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      obscureText: true,
    );

    final registerForm = Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[photoUrlField, displayNameField, emailField, passwordField],
        ),
      ),
    );

    final submitBtn = Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
        height: 60.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(color: Colors.black),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(7.0),
          color: primaryColor,
          elevation: 10.0,
          shadowColor: Colors.white,
          child: MaterialButton(
            onPressed: () {
              if(_formKey.currentState.validate()){
              _formKey.currentState.save();
                  registerWithEmailAndPassword(email, password).then((user) {
                    if (user != null) {
                      print('user');
                    } else {
                      print("Error");
                    }
                  });
                };
              },
            child: Text(
              'CREATE ACCOUNT',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 40.0),
          child: Column(
            children: <Widget>[
              appBar,
              Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    pageTitle,
                    registerForm,
                    submitBtn
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, IconData icon) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(
          icon,
          color: Colors.black38,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
    );
  }

  

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    print("Inside addDataToDb Method");

    _firestore
        .collection("display_names")
        .document(this.displayName)
        .setData({'displayName': this.displayName});

    user = User(
        uid: currentUser.uid,
        email: this.email,
        displayName: this.displayName,
        photoUrl: this.photoUrl,
        // photoUrl: this.photoUrl,
        followers: '0',
        following: '0',
        bio: '',
        posts: '0',
        phone: '');

    //  Map<String, String> mapdata = Map<String, dynamic>();

    //  mapdata = user.toMap(user);

    return _firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      print('User Created');
      addDataToDb(user).then((user) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return InstaHomeScreen();
          }));
        });
      return _userFromFirebaseUser(user);
      
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }
}