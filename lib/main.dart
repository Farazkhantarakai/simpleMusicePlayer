import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_players/provider/permission.dart';
import 'package:media_players/screens/audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:media_players/utils/constants.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = Get.put(PermissionHander());

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  requestPermission() async {
    _controller.setPermision();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        home: Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          'Music Player',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() => !_controller.getPermission
            ? Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Try to ask for storage permission',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      SizedBox(
                        width: double.infinity,
                        height: Get.height * 0.05,
                        child: ElevatedButton(
                            onPressed: () {
                              _controller.setPermision();
                            },
                            child: const Text('Retry')),
                      )
                    ],
                  ),
                ),
              )
            : const Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [Expanded(child: Audio())],
                ),
              )),
      ),
    ));
  }
}
