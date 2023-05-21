import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_players/screens/audiostream.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class Audio extends StatefulWidget {
  const Audio({super.key});

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<List<SongModel>>(
      // Default values:
      future: _audioQuery.querySongs(
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      ),
      builder: (context, item) {
        // Display error, if any.
        if (item.hasError) {
          return Text(item.error.toString());
        }

        // Waiting content.
        if (item.data == null) {
          return const CircularProgressIndicator();
        }

        // 'Library' is empty.
        if (item.data!.isEmpty) return const Text("Nothing found!");

        // You can use [item.data!] direct or you can create a:
        // List<SongModel> songs = item.data!;
        return ListView.builder(
          itemCount: item.data!.length,
          itemBuilder: (context, index) {
            if (kDebugMode) {
              print(item.data![index].data);
            }
            return GestureDetector(
              onTap: () {
                Get.to(() => AudioStream(
                      songModel: item.data![index],
                      allSongs: item,
                      currentIndex: index,
                    ));
              },
              child: Card(
                color: Colors.white,
                child: ListTile(
                    title: Text(item.data![index].title),
                    subtitle: Text(item.data![index].artist ?? "No Artist"),
                    leading: CircleAvatar(
                      backgroundColor: Colors.yellow.shade800,
                      child: const Icon(
                        Icons.audiotrack,
                        color: Colors.white,
                      ),
                    )),
              ),
            );
          },
        );
      },
    ));
  }
}
