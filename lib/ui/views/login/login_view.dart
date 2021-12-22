import 'package:flutter/material.dart';
import 'package:flutter_plugins_example/core/app/app.locator.dart';
import 'package:flutter_plugins_example/core/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final navigationService = locator<NavigationService>();

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
                onPressed: () {
                  navigationService.navigateTo(Routes.bluetoothScreen);
                },
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.record_voice_over_rounded),
                label: Text("SoundRecord"),
                onPressed: () {
                  navigationService.navigateTo(Routes.soundRecordScreen);
                },
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
