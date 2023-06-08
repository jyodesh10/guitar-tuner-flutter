// ignore_for_file: use_build_context_synchronously

import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:guitar_tuner/features/home/presentation/pages/metronome_page.dart";
import "package:rive/rive.dart" as rv;
import "package:syncfusion_flutter_gauges/gauges.dart";
import 'package:permission_handler/permission_handler.dart';

import "../bloc/home_bloc.dart";
import "../bloc/tunings_cubit/tunings_cubit.dart";
import "../utils/dialogs.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List standard = ["E", "A", "D", "G", "B", "E"];
  var selectedIntrumentIndex  =3;
  var selectedTuningIndex  =0;
  String openr ="A#DA#D#GC";
  List  st =[];
  List<String> chars = [];


  @override
  void initState() {
    super.initState();
    recordPerm();
    BlocProvider.of<HomeBloc>(context).add(const StartRecordingEvent());
  }

  @override
  void dispose() {
    super.dispose();
    BlocProvider.of<HomeBloc>(context).add(const StopRecordingEvent());
    HomeBloc().close();
  }

  recordPerm()async{
    if (await Permission.microphone.request().isGranted) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
      //   "Permission Granted"
      // )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
            // color: const Color.fromARGB(255, 5, 155, 155),
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
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Center(
                  child: Column(children: [
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const IconButton(
                          onPressed: null,
                          icon: Icon(Icons.menu, size: 30, color: Colors.transparent),
                        ),
                        const Spacer(),
                        Center(
                          child: context.read<HomeBloc>().status ==
                                  "TuningStatus.undefined"
                              ? const SizedBox(
                                  height: 80,
                                  width: 80,
                                )
                              : Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: context.read<HomeBloc>().status ==
                                              "TuningStatus.tuned"
                                          ? Colors.green.shade200
                                          : Colors.red.shade200,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            spreadRadius: 20,
                                            color:
                                                context.read<HomeBloc>().status ==
                                                        "TuningStatus.tuned"
                                                    ? Colors.green.shade200
                                                    : Colors.red.shade200)
                                      ]),
                                  child: Center(
                                    child: Text(
                                      context.watch<HomeBloc>().note,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          // context.read<HomeBloc>().status =="TuningStatus.tuned"?Colors.green: Colors.red,
                                          fontSize: 60.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<HomeBloc>(context).add(const StopRecordingEvent());
                            HomeBloc().close();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MetronomePage(), ) );
                          },
                          icon: Image.asset("assets/metronome.png",color: Colors.white, )
                        ),
                      ],
                    ),
                    const Spacer(),
                    _buildRadialGauge(),
                    const Spacer(),
                    const Center(
                        child: Text(
                      "",
                      // context.read<HomeBloc>().status,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold),
                    )),
                    _buildTuningOption(),
                    const Spacer(),
                  ]),
                );
              },
            ),
          ),
          // Positioned(
          //   bottom: 700,
          //   left: 340,
          //   right: 100,
          //   top: 10,
          //   child: IconButton(
          //     onPressed: () {
          //       log('message');

          //     },
          //     icon: const Icon(Icons.menu, size: 30, color: Colors.white),
          //   ),
          // )
        ],
      ),
    );
  }

  _buildRadialGauge() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showAxisLine: false,
                showTicks: false,
                minimum: 0,
                maximum: 99,
                
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0, endValue: 33,
                    // color: const Color(0xFFFE2A25),
                    label: 'Low',
                    gradient: const SweepGradient(colors: <Color>[
                      Color(0xFFACB6E5)
                    ], stops: <double>[
                      0.25
                    ]),
                    sizeUnit: GaugeSizeUnit.factor,
                    labelStyle: const GaugeTextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20),
                    startWidth: 0.40, endWidth: 0.40,
                  ),
                  GaugeRange(
                    startValue: 33, endValue: 66,
                    // color:const Color(0xFFFFBA00),
                    label: 'Tuned',
                    gradient: const SweepGradient(colors: <Color>[
                       Color(0xFFACB6E5),
                      Color(0xFF74ebd5)
                    ], stops: <double>[
                      0.25,
                      0.75
                    ]),
                    labelStyle: const GaugeTextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20),
                    startWidth: 0.40, endWidth: 0.40,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  GaugeRange(
                    startValue: 66, endValue: 99,
                    // color:const Color(0xFF00AB47),
                    label: 'High',
                    gradient: const SweepGradient(colors: <Color>[
                      Color(0xFF74ebd5)
                    ], stops: <double>[
                      0.75
                    ]),
                    labelStyle: const GaugeTextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.40, endWidth: 0.40,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                      value: context.read<HomeBloc>().status ==
                              "TuningStatus.waytoolow"
                          ? 20
                          : context.read<HomeBloc>().status ==
                                  "TuningStatus.toolow"
                              ? 40
                              : context.read<HomeBloc>().status ==
                                      "TuningStatus.tuned"
                                  ? 50
                                  : context.read<HomeBloc>().status ==
                                          "TuningStatus.toohigh"
                                      ? 60
                                      : context.read<HomeBloc>().status ==
                                              "TuningStatus.waytoohigh"
                                          ? 80
                                          : 0,
                      needleStartWidth: 1,
                      needleEndWidth: 5,
                      needleColor: Colors.white,
                      knobStyle: const KnobStyle(
                          knobRadius: 0.09,
                          borderColor: Colors.white,
                          borderWidth: 0.02,
                          color: Colors.black))
                ])
          ],
        );
      },
    );
  }
  
  _buildTuningOption() {
    return BlocBuilder<TuningsCubit, TuningsState>(
      builder: (context, state) {
        if(state is TuningsLoadingState){
          return const Text('Loading....');
        }
        if(state is TuningsLoadedState){

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: (){
                    buildDialog(context, Column(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        ...List.generate(
                        state.data.data.length,
                        (index) => 
                          ListTile(
                            onTap: (){
                              selectedIntrumentIndex = 3;
                              selectedTuningIndex = 0;
                              setState(() {
                                selectedIntrumentIndex = index;
                                
                              });
                              Navigator.pop(context);
                            },
                            title: Text(
                              state.data.data[index].instrument,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 22),
                            ),
                          )
                        )
                      ],
                    ));
                  },
                  color: Colors.white.withOpacity(0.3),
                  child: Column(
                    children:   [
                      const Text('Select Instrument',style: TextStyle(
                        color: Colors.white
                      ),),
                       Text( state.data.data[selectedIntrumentIndex].instrument[0].toUpperCase()+state.data.data[selectedIntrumentIndex].instrument.substring(1).toLowerCase(),style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                      ),),
                    ],
                  ),
                ),


                ///tunings
                MaterialButton(
                  onPressed: (){
                    buildDialog(context, SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:  [
                          ...List.generate(
                            state.data.data[selectedIntrumentIndex].tunings.length,
                          (index) => 
                            ListTile(
                              onTap: (){
                                st = [];
                                setState(() {
                                  selectedTuningIndex = index;
                                });
                                Navigator.pop(context);
                              },
                              title: Text(
                                state.data.data[selectedIntrumentIndex].tunings[index].name,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 22),
                              ),
                            )
                          )
                        ],
                      ),
                    ));
                  },
                  color: Colors.white.withOpacity(0.3),
                  child: Column(
                    children:  [
                      const Text('Select Tuning',style: TextStyle(
                        color: Colors.white
                      ),),
                      Text( state.data.data[selectedIntrumentIndex].tunings[selectedTuningIndex].name,style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                      ),),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                ...List.generate(
                    state.data.data[selectedIntrumentIndex].tunings[selectedTuningIndex].notes.length,

                    (index) => Text(
                          state.data.data[selectedIntrumentIndex].tunings[selectedTuningIndex].notes[index],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
                        ))
              ],
            ),
          ],
        );
        }
        return const Text('Error');
      },
    );
  }
}
