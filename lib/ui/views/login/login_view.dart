import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
            ),
            children: <Widget>[
              OutlinedButton.icon(
                icon: Icon(Icons.bluetooth),
                label: Text("Bluetooth"),
                onPressed: () {},
              ),
              Icon(Icons.ac_unit),
              Icon(Icons.airport_shuttle),
              Icon(Icons.all_inclusive),
              Icon(Icons.beach_access),
              Icon(Icons.cake),
              Icon(Icons.free_breakfast)
            ]),
      ),
    );
  }
}
