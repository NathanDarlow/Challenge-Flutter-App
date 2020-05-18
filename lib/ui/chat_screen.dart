import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tbb/models/user.dart';
import 'package:tbb/resources/repository.dart';
import 'package:tbb/ui/chat_detail_screen.dart';
import 'package:tbb/utils/colors.dart';

import 'insta_home_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _repository = Repository();
  User currentUser, user, followingUser;
  List<User> usersList = List<User>();
  Future<List<DocumentSnapshot>> _future;
  bool _isLiked = false;
  List<String> followingUIDs = List<String>();

  @override
  void initState() {
    super.initState();
    fetchFeed();
  }

  void fetchFeed() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();

    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    setState(() {
      this.currentUser = user;
    });

    followingUIDs = await _repository.fetchUserNames(currentUser);

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DSDASDASD : ${followingUIDs[i]}");
      // _future = _repository.retrievePostByUID(followingUIDs[i]);
      this.user = await _repository.fetchUserDetailsById(followingUIDs[i]);
      print("user : ${this.user.uid}");
      usersList.add(this.user);
      print("USERSLIST : ${usersList.length}");

      for (var i = 0; i < usersList.length; i++) {
        setState(() {
          followingUser = usersList[i];
          print("FOLLOWING USER : ${followingUser.uid}");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar(),
        body: ListView.builder(
          itemCount: usersList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => ChatDetailScreen(
                                photoUrl: usersList[index].photoUrl,
                                name: usersList[index].displayName,
                                receiverUid: usersList[index].uid,
                              ))));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(usersList[index].photoUrl),
                  ),
                  title: Text(usersList[index].displayName),
                ),
              ),
            );
          }),
        ));
  }

  _getAppBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Stack(children: <Widget>[
          ClipRRect(
              child: Container(
            decoration: BoxDecoration(color: primaryColor),
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: InstaHomeScreen()));
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        15.0,
                        15.0,
                        30.0,
                        0.0,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      15.0,
                      15.0,
                      30.0,
                      0.0,
                    ),
                    child: Text('Your Follows',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 5.0,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ],
          ),
        ]));
  }
}
