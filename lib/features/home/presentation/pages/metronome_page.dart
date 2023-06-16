import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:guitar_tuner/features/home/presentation/pages/home_page.dart';
import "package:rive/rive.dart" as rv;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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
  final _isElevated = false;
  static AudioPlayer player = AudioPlayer();
  AudioCache audioCache1  = AudioCache(prefix: 'assets/audio'); 



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

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
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: Row(
              children: [
                IconButton(
                  onPressed: ()=> Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const HomePage(), ) ), 
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white, )),
                Center(child: Text("Metronome",style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white,fontWeight: FontWeight.w200 ), )),

              ],
            ),
          ),
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
          children:  [
            Text(
              percentage.roundToDouble().ceil().toString(),
              style: const TextStyle(color: Colors.white, fontSize: 60,fontWeight: FontWeight.w200  ), 
            ),
            const Text(
              'BPM',
              style: TextStyle(color: Colors.amber, fontSize: 30,fontWeight: FontWeight.w600  ),
            ),
          ],
        ),
      ),
      onChange: (double value) {
        log(value.toStringAsFixed(0));
      }
    );
  }

  neumprhicBtn(){
    return Center(
        child: GestureDetector(
          onTap: () {
            Timer.periodic(const Duration(seconds: 1), (timer) {
          player.play(AssetSource(metronomeAudioPath));

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


