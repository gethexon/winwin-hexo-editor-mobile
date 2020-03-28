import 'package:flutter/material.dart';
import 'package:winwin_hexo_editor_mobile/api/user_api.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController serverEditingController;
  TextEditingController nameEditingController;
  TextEditingController passwordEditingController;

  @override
  void initState() {
    super.initState();
    serverEditingController = TextEditingController();
    nameEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
  }

  void onLoginButtonClick() {
    print("onLoginButtonClick");
    UserApi.login(serverEditingController.text, nameEditingController.text,
        passwordEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: serverEditingController,
            obscureText: false,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "server",
            ),
          ),
          TextField(
            controller: nameEditingController,
            obscureText: false,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "name",
            ),
          ),
          TextField(
            controller: passwordEditingController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "password",
            ),
          ),
          FlatButton(
            child: Text("Login"),
            onPressed: onLoginButtonClick,
          ),
        ],
      ),
    );
  }
}
