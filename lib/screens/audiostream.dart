import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:media_players/utils/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class AudioStream extends StatefulWidget {
  AudioStream(
      {super.key,
      required this.songModel,
      required this.allSongs,
      required this.currentIndex});

  SongModel songModel;
  final AsyncSnapshot<List<SongModel>> allSongs;
  int currentIndex = 0;

  @override
  State<AudioStream> createState() => _AudioStreamState();
}

class _AudioStreamState extends State<AudioStream> {
  final _player = AudioPlayer();
  Duration _position = const Duration();
  Duration _duration = const Duration();
  bool _startPlaying = false;
  @override
  void initState() {
    playSong();
    super.initState();
  }

  void playSong([SongModel? newsong]) async {
    try {
      _player.setAudioSource(AudioSource.uri(
        Uri.parse(
          newsong == null ? widget.songModel.uri! : newsong.uri!,
        ),
        tag: MediaItem(
          id: widget.songModel.id.toString(),
          album: widget.songModel.album,
          title: widget.songModel.title,
          artUri: Uri.parse('${widget.songModel.uri}'),
        ),
      ));
      await _player.play();
      _startPlaying = true;
    } catch (err) {
      if (kDebugMode) {
        debugPrint(err.toString());
      }
      Fluttertoast.showToast(msg: err.toString());
    }
    // this is giving the stream duration
    _player.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    // this is giving us the position
    _player.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

// this will move forward the audio file
  void playNext() {
    setState(() {
      int newIndex = widget.currentIndex++;
      int size = widget.allSongs.data!.length;
      if (newIndex >= 0 && newIndex <= size) {
        widget.songModel = widget.allSongs.data![newIndex];
        playSong(widget.songModel);
      }
    });
  }

// this will move back the songs/ audio files
  void playBack() {
    setState(() {
      int newIndex = widget.currentIndex--;
      int size = widget.allSongs.data!.length;
      if (newIndex >= 0 && newIndex <= size) {
        widget.songModel = widget.allSongs.data![newIndex];
        playSong(widget.songModel);
      }
    });
  }

  moveSong() {
    setState(() {
      _player.seek(Duration(seconds: _position.inSeconds + 20));
    });
  }

  sendBack() {
    setState(() {
      _player.seek(Duration(seconds: _position.inSeconds - 20));
    });
  }

  @override
  Widget build(BuildContext context) {
    final mdq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            await _player.stop();
            return true;
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _player.stop();
                        });
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: textColor,
                      )),
                  SizedBox(
                    width: mdq.width * 0.27,
                  ),
                  const Text(
                    'Now Playing ',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.07,
              ),
              const CircleAvatar(
                maxRadius: 100,
                backgroundColor: Colors.yellow,
                child: Icon(
                  Icons.audiotrack,
                  color: Color.fromARGB(255, 102, 102, 77),
                  size: 100,
                ),
              ),
              SizedBox(
                height: Get.height * 0.08,
              ),
              Text(
                widget.songModel.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: textColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Text(
                widget.songModel.artist.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: textColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              Slider(
                  min: const Duration(seconds: 0).inSeconds.toDouble(),
                  activeColor: textColor,
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (val) {
                    setState(() {
                      _player.seek(Duration(seconds: val.toInt()));
                      val = val;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _position.toString().split('.')[0],
                      style: const TextStyle(color: textColor),
                    ),
                    Text(
                      _duration.toString().split('.')[0],
                      style: const TextStyle(color: textColor),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onLongPress: () {
                      sendBack();
                    },
                    onTap: () {
                      playBack();
                    },
                    child: const Icon(
                      Icons.skip_previous,
                      size: 50,
                      color: textColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_startPlaying) {
                          _player.stop();
                          _startPlaying = false;
                        } else {
                          _player.play();
                          _startPlaying = true;
                        }
                      });
                    },
                    child: _startPlaying
                        ? const Icon(
                            Icons.pause,
                            color: textColor,
                            size: 50,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            color: textColor,
                            size: 50,
                          ),
                  ),
                  GestureDetector(
                    onLongPress: () {
                      moveSong();
                    },
                    onTap: () {
                      playNext();
                    },
                    child: const Icon(
                      Icons.skip_next,
                      size: 50,
                      color: textColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       GestureDetector(
              //         onTap: () {},
              //         child: Container(
              //           decoration: BoxDecoration(
              //               border: Border.all(color: ),
              //               shape: BoxShape.circle),
              //           child: const Icon(
              //             Icons.loop,
              //             size: 40,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () {},
              //         child: Container(
              //           decoration: BoxDecoration(
              //               border: Border.all(
              //                 color: Colors.white,
              //               ),
              //               shape: BoxShape.circle),
              //           child: const Icon(
              //             Icons.shuffle,
              //             size: 40,
              //             color: Colors.white,
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
