import 'package:flutter/material.dart';
import 'package:pluginexample/core/app/app.locator.dart';
import 'package:pluginexample/core/app/app.router.dart';
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
        padding: const EdgeInsets.all(8.0),
        child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
            ),
            children: <Widget>[
              OutlinedButton.icon(
                icon: const Icon(Icons.record_voice_over_rounded),
                label: const Text("SoundRecord"),
                onPressed: () {
                  navigationService.navigateTo(Routes.soundRecordScreen);
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.qr_code),
                label: const Text("qrCode"),
                onPressed: () {
                  navigationService.navigateTo(Routes.qrCodeScreen);
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.audiotrack),
                label: const Text("justAudio"),
                onPressed: () {
                  navigationService.navigateTo(Routes.justAudioScreen);
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.bluetooth),
                label: const Text("Bluetooth"),
                onPressed: () {
                  navigationService.navigateTo(Routes.bluetoothScreen);
                },
              ),
              const Icon(Icons.ac_unit),
              const Icon(Icons.airport_shuttle),
              const Icon(Icons.all_inclusive),
              const Icon(Icons.beach_access),
              const Icon(Icons.cake),
              OutlinedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text("home"),
                onPressed: () {
                  // navigationService.navigateTo(Routes.homeView);
                },
              ),
            ]),
      ),
    );
  }
}
