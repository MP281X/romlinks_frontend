import 'package:flutter/material.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

var devices = [];

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              child: TextField(
                onChanged: (text) async {
                  devices = await DeviceService.searchDeviceName(text);
                  setState(() {
                    devices = devices;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text(devices.toString()),
          ],
        ),
      ),
    );
  }
}
