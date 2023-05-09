import "dart:developer";
import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:rive/rive.dart" as rv;
import "package:syncfusion_flutter_gauges/gauges.dart";
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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(const StartRecordingEvent());
  }

  @override
  void dispose() {
    super.dispose();
    BlocProvider.of<HomeBloc>(context).add(const StopRecordingEvent());
    HomeBloc().close();
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
                  Color.fromRGBO(10, 56, 100, 0.5),
                  Color.fromRGBO(2, 25, 81, 0.6)
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
                                      ? Colors.green
                                      : Colors.red.shade500,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        spreadRadius: 20,
                                        color:
                                            context.read<HomeBloc>().status ==
                                                    "TuningStatus.tuned"
                                                ? Colors.green
                                                : Colors.red.shade500)
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
          Positioned(
            bottom: 700,
            left: 340,
            right: 100,
            top: 10,
            child: IconButton(
              onPressed: () {
                log('message');
              },
              icon: const Icon(Icons.menu, size: 30, color: Colors.white),
            ),
          )
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
                      Color.fromRGBO(85, 212, 229, 1),
                      Color.fromRGBO(81, 163, 211, 1)
                    ], stops: <double>[
                      0.25,
                      0.75
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
                      Color.fromRGBO(81, 163, 211, 1),
                      Color.fromRGBO(74, 102, 186, 1),
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
                      Color.fromRGBO(74, 102, 186, 1),
                      Color.fromRGBO(70, 60, 172, 1)
                    ], stops: <double>[
                      0.25,
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
                              selectedIntrumentIndex = index;
                            },
                            title: Text(
                              state.data.data[index].instrument,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 25),
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
                       Text( state.data.data[state.selectedInstrument].instrument[0].toUpperCase()+state.data.data[state.selectedInstrument].instrument.substring(1).toLowerCase(),style: const TextStyle(
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
                              title: Text(
                                state.data.data[selectedIntrumentIndex].tunings[index].name,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 25),
                              ),
                            )
                          )
                        ],
                      ),
                    ));
                  },
                  color: Colors.white.withOpacity(0.3),
                  child: Column(
                    children: const [
                      Text('Select Tuning',style: TextStyle(
                        color: Colors.white
                      ),),
                      Text('OpenD',style: TextStyle(
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:  [
                ...List.generate(
                   1,
                    (index) => Text(
                          state.data.data[0].instrument,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 25),
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
