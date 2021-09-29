import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class MemberPage extends StatefulWidget {
  @override
  final String username;
  MemberPage({this.username});

  _MemberPage createState() => _MemberPage();
}

String url =
    "http://192.168.43.162/Capstone/Users/user$id/notification/image.jpg?r=m";
Image the_image = Image.network(url);

class _MemberPage extends State<MemberPage> {
  // Main Build() context.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome member of Car Security !'),
        ),
        body: ListView(
          children: [
            Image.network(url, width: 250, height: 300, fit: BoxFit.cover),
            Row(
              children: [
                Expanded(
                  /*1*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*2*/
                      Container(
                        child: Text(
                          'Is This Person Allowed to ride the car ?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      child: Text("Yes"),
                      onPressed: _PostReqAllowed,
                    ),
                    RaisedButton(
                        child: Text("No"),
                        onPressed: () {
                          _PostReqNotAllowed();
                          setState(() {});
                        }),
                    RaisedButton(
                      child: Text("Log out"),
                      onPressed: () {
                        imageCache.clear();
                        Navigator.pushReplacementNamed(context, '/MyHomePage');
                      },
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  void changeImage() {
    setState(() {
      url = url + "m";
      the_image = Image.network(url);
    });
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      changeImage();
    });
    super.initState();
  }

  Future<List> _PostReqAllowed() async {
    final response =
        await http.post("http://192.168.43.162/Capstone/user_reply.php", body: {
      "username": user.text,
      "id": id,
      "is_allowed": "allowed",
    });
  }

  Future<List> _PostReqNotAllowed() async {
    final response =
        await http.post("http://192.168.43.162/Capstone/user_reply.php", body: {
      "username": user.text,
      "id": id,
      "is_allowed": "not allowed",
    });
  }
}
