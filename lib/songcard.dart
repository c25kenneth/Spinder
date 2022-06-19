import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:spinder/song.dart';

class SongCard extends StatefulWidget {
  const SongCard({ Key? key, }) : super(key: key);
  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  List<Song> mySongs = [
    Song(imageURL: "https://m.media-amazon.com/images/M/MV5BMzBjNzIzODEtMzdiOC00ZmE0LTgyY2UtOGY0NTRiOTViY2JlXkEyXkFqcGdeQXVyNDE4OTY5NzI@._V1_FMjpg_UX1000_.jpg", songFile: 'https://www.ee.columbia.edu/~dpwe/sounds/music/africa-toto.wav', songArtist: "Toto", songTitle: "Africa"),
    Song(imageURL: "https://m.media-amazon.com/images/I/51jtXdQdYfL.jpg", songFile: "https://www.ee.columbia.edu/~dpwe/sounds/music/around_the_world-atc.wav", songArtist: "A Touch of Class", songTitle: "Around The World"),
    Song(imageURL: "https://m.media-amazon.com/images/I/810U6WdijVL._SS500_.jpg", songFile: "https://www.ee.columbia.edu/~dpwe/sounds/music/dont_speak-no_doubt.wav", songArtist: "No Doubt", songTitle: "Don't Speak"),
  ]; 
  final audioPlayer = AudioPlayer(); 
  bool isPlaying = false; 
  Duration duration = Duration.zero;
  Duration position = Duration.zero; 

  String formatTime (Duration duration) {
    String digits(int n) => n.toString().padLeft(2, '0');
    final hours = digits(duration.inHours); 
    final minutes = digits(duration.inMinutes.remainder(60));
    final seconds = digits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours, minutes, seconds
    ].join(":"); 
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) { 
      setState(() {
        isPlaying = state == PlayerState.PLAYING; 
      });
    });
    audioPlayer.onDurationChanged.listen((newduration) { 
      setState(() {
        duration = newduration; 
      });
    });
    audioPlayer.onAudioPositionChanged.listen((newposition) { 
      setState(() {
        position = newposition; 
      });
    });
  }
  @override
  void dispose() {
    audioPlayer.dispose(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.35,            
              child: AppinioSwiper(
                cards: mySongs.map((e) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(e.imageURL),
                        fit: BoxFit.cover),
                      ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(e.songTitle, style: TextStyle(
                          fontSize: 54, 
                          fontWeight: FontWeight.bold, 
                        ),),
                        Text("By " + e.songArtist, style: TextStyle(
                          fontSize: 32, 
                          fontWeight: FontWeight.bold, 
                        ),),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        SizedBox(height: 64), 
          Slider(value: position.inSeconds.toDouble(), onChanged: (value) async {
            final position = Duration(seconds: value.toInt());
            await audioPlayer.seek(position); 
            await audioPlayer.resume(); 
          }, max: duration.inSeconds.toDouble(), min: 0,),
          Row(children: [Text(formatTime(position)), SizedBox(width: 300,), Text(formatTime(duration))],),
          MaterialButton(color: Colors.blue, child: Text("Start/Pause"), onPressed: () async {
            if (isPlaying == true){
              await audioPlayer.pause();
            } else {
              
              await audioPlayer.play("https://www.ee.columbia.edu/~dpwe/sounds/music/dont_speak-no_doubt.wav"); 
            }
          },
          ),
      ],
    );
  }
}

