import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('lib/ui/assets/logo.png'),
            ),
            Text(
              "Login",
              style: Theme.of(context).textTheme.headline1.copyWith(
                    color: Colors.white,
                  ),
            ),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "E-Mail",
                      labelStyle: Theme.of(context).textTheme.subtitle2,
                      icon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _emailUserNode,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: Theme.of(context).textTheme.subtitle2,
                      icon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    focusNode: _passwordNode,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
            ),
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {},
                child: Text(
                  "Sign Up",
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Colors.black,
                      ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            FlatButton.icon(
              onPressed: (){},
              icon: Icon(Icons.person),
              label: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }

  FocusNode _emailUserNode;
  FocusNode _passwordNode;

  @override
  void initState() {
    _emailUserNode = FocusNode();
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordNode.dispose();
    _emailUserNode.dispose();
    super.dispose();
  }
}
