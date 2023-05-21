import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_players/provider/fetch_video.dart';
import 'package:media_players/provider/permission.dart';

class Video extends StatefulWidget {
  const Video({super.key});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  // List<File> _videos = [];

  final controller = Get.put(PermissionHander());
  final videoController = Get.put(FetchVideoFiles());

  @override
  void initState() {
    super.initState();
    // _getVideos();
  }

  // Future<void> _getVideos() async {
  //   videoController.fetchMusic();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder(
                future: videoController.fetchMusic(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('No Data');
                  } else {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    }
                    return ListView.builder(itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index]),
                      );
                    });
                  }
                })));
  }
}
