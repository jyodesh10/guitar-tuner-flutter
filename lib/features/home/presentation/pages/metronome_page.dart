import 'dart:developer';
import 'dart:ui';

import 'package:guitar_tuner/features/home/presentation/pages/home_page.dart';
import "package:rive/rive.dart" as rv;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:reliable_interval_timer/reliable_interval_timer.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// number of milliseconds in a minute
const minute = 1000 * 60;
const double _minimumTempoValue = 30;
const double _maximumTempoValue = 200;
const double _tempoIncrement = 10;
const double tempoRange = _maximumTempoValue - _minimumTempoValue;
const double _tempoDivisions = tempoRange / _tempoIncrement;

const metronomeAudioPath =
    'audio/sound.wav';


class MetronomePage extends StatefulWidget {
  const MetronomePage({super.key});


  @override
  State<MetronomePage> createState() => MetronomePageState();
}

// this is made public so it is visible in the unit test
// Note: there may be a better way to test private state
class MetronomePageState extends State<MetronomePage> {
  double _tempo = 80;

  // Used to toggle metronome click
  // It is set to be a public member,
  // so it is visible in the unit test
  bool soundEnabled = true;
  bool paused = true;
  bool _isElevated = false;


  late ReliableIntervalTimer _timer;
  // late AudioPlayer player;
  static AudioPlayer player = AudioPlayer();


  int _calculateTimerInterval(int tempo) {
    double timerInterval = minute / tempo;

    return timerInterval.round();
  }

  void onTimerTick(int elapsedMilliseconds) async {
    if (soundEnabled) {
      player.play(AssetSource(metronomeAudioPath));
    }
  }

  ReliableIntervalTimer _scheduleTimer([int milliseconds = 10000]) {
    return ReliableIntervalTimer(
      interval: Duration(milliseconds: milliseconds),
      callback: onTimerTick,
    );
  }

  @override
  void initState() {
    super.initState();

    _timer = _scheduleTimer(_calculateTimerInterval(_tempo.round()));

    // _timer.start();
  }

  @override
  void dispose() {
    _timer.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:  [
          const rv.RiveAnimation.asset(
            "assets/shapes.riv",

          ),
          const rv.RiveAnimation.asset("assets/shapes.riv",
              alignment: Alignment.center),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: const SizedBox(),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                gradient: RadialGradient(
                    colors: <Color>[
                  Color.fromRGBO(3, 0, 28, 0.6),
                  Color.fromRGBO(17, 20, 42, 0.723)
                ],
                    // begin: Alignment.topCenter,
                    // end: Alignment.bottomCenter,
                    stops: <double>[
                  0.25,
                  0.75
                ])),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customSlider(),
                  neumprhicBtn()

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     // MaterialButton(
                  //     //   onPressed: ()  async {
                          
                            
                  //     //       _timer = _scheduleTimer(
                  //     //         _calculateTimerInterval(_tempo.round()),
                  //     //       );
             
                  //     //       if(paused){
                  //     //         await _timer.start();
                  //     //         paused=false;
                  //     //         log(paused.toString());
                  //     //       }else{
                  //     //         await _timer.stop();
                  //     //         paused=true;
                  //     //         log(paused.toString());
          
                  //     //       }
                  //     //     setState(() {
                  //     //     });
                  //     //   },
                  //     //   shape: ,
                  //     //   child: Icon(
                  //     //     paused?
                  //     //     Icons.play_arrow:
                  //     //     Icons.pause,
                  //     //   ),
                  //     // ),
                  //     // OutlinedButton(
                  //     //   style: _buttonStyle,
                  //     //   onPressed: () async {
                  //     //     await _timer.stop();
                  //     //   },
                  //     //   child: const Icon(
                  //     //     Icons.stop,
                  //     //   ),
                  //     // ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              onPressed: ()=> Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const HomePage(), ) ), 
              icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white, )),
          )
        ],
      ),
    );
  }
  
  customSlider() {
    return SleekCircularSlider(
      appearance:  CircularSliderAppearance(
        size: 300,
        customColors: CustomSliderColors(
          trackColor: Colors.amber,
          progressBarColors:
          // [const Color(0xFF667db6),const Color(0xFF0082c8),const Color(0xFFDBDBDB),const Color(0xFFEAEAEA), ]
           [const Color(0xFFACB6E5),const Color(0xFF74ebd5)],
          dynamicGradient: true,
          shadowStep: 20 ,
          shadowColor: Colors.white,
          shadowMaxOpacity: 0.02,
        ),
      ),
      max: 240,
      min: 40,
      innerWidget: (percentage) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _tempo.round().toString(),
              style: const TextStyle(color: Colors.white, fontSize: 60,fontWeight: FontWeight.w200  ), 
            ),
            const Text(
              'BPM',
              style: TextStyle(color: Colors.amber, fontSize: 30,fontWeight: FontWeight.w600  ),
            ),
          ],
        ),
      ),
      onChange: (double value)async {
        await _timer.stop();

        setState(() {
          _tempo = value;
        });
    });
  }

  neumprhicBtn(){
    return Center(
        child: GestureDetector(
          onTap: ()async {
              _timer = _scheduleTimer(
                _calculateTimerInterval(_tempo.round()),
              );

              if(_isElevated){
                await _timer.start();
                _isElevated=false;
                log(_isElevated.toString());
              }else{
                await _timer.stop();
                _isElevated=true;
                log(_isElevated.toString());

              }
            setState(() {
              _isElevated = !_isElevated;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 200,
            ),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              shape: BoxShape.circle,
              boxShadow: _isElevated
              ? 
              // Elevated Effect
              [
                  
                const BoxShadow(
                  color: Colors.white30,
                  // Shadow for bottom right corner
                  offset: Offset(10, 10),
                  blurRadius: 30,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Colors.white10,
                  // Shadow for top left corner
                  offset: Offset(-10, -10),
                  blurRadius: 30,
                  spreadRadius: 1,
                ),
              ]
              : 
              // Depth Effect
              [
                  
                const BoxShadow(
                  color: Colors.white54,
                  // Shadow for bottom right corner
                  offset: Offset(10, 10),
                  blurRadius: 30,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Colors.white30,
                  // Shadow for top left corner
                  offset: Offset(-10, -10),
                  blurRadius: 30,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              _isElevated?
              Icons.play_circle:
              Icons.pause_circle,
              size: 40,
              // Changing icon color on 
              // the basis of it's elevation
              color:
                  _isElevated ? Colors.white : const Color.fromARGB(255, 83, 220, 230),
            ),
          ),
        ),
      );
  }
}


