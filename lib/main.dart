import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'member_page.dart';
import 'dart:convert';

var id;
TextEditingController user = new TextEditingController();
TextEditingController pass = new TextEditingController();
FormType _form = FormType.login;
String msg = '';

void main() => runApp(new MyApp());

String username = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car_Security',
      home: new MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/MemberPage': (BuildContext context) => new MemberPage(
              username: username,
            ),
        '/MyHomePage': (BuildContext context) => new MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum FormType { login, register }

class _MyHomePageState extends State<MyHomePage> {
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  Future<List> _login() async {
    final response = await http
        .post("http://192.168.43.162/Capstone/car-sec/AppLogin.php", body: {
      "username": user.text,
      "password": pass.text,
    });

    var datauser = json.decode(response.body);
    print(datauser);
    if (datauser.length == 0) {
      setState(() {
        msg = "";
      });
    } else {
      if (datauser[0]['level'] == 'member') {
        Navigator.pushReplacementNamed(context, '/MemberPage');
        id = datauser[0]['id'];
      }

      setState(() {
        username = datauser[0]['username'];
      });
    }

    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

/*Future<list>  _createAccountPressed() async{

}*/
  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Car Security"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: user,
              decoration: new InputDecoration(labelText: 'Username'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: pass,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('Login'),
              onPressed: () {
                _login();
              },
            ),
            new FlatButton(
              child: new Text('Dont have an account? Tap here to register.'),
              onPressed: _formChange,
            ),
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('Create an Account'),
              onPressed: _createAccountPressed,
            ),
            new FlatButton(
              child: new Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }

  _createAccountPressed() {
    return null;
  }
}
