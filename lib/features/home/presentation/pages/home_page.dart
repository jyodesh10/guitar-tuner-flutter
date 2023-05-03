import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:syncfusion_flutter_gauges/gauges.dart";

import "../bloc/home_bloc.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
      body: Container(
        // color: const Color.fromARGB(255, 5, 155, 155),
        decoration: const BoxDecoration(
            gradient: RadialGradient(
                        colors: <Color>[Color.fromRGBO(10, 56, 100, 1), Color.fromRGBO(2, 25, 81, 0.8) ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                        stops: <double>[0.25, 0.75]),),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Center(
              child: Column(children: [
                const Spacer(),
                Center(
                  child: Text(
                    context.watch<HomeBloc>().note,
                    style: TextStyle(
                        color:  context.read<HomeBloc>().status =="TuningStatus.tuned"?Colors.green: Colors.red,
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold
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
                const Spacer(),
      
              ]),
            );
          },
        ),
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
                    gradient: const SweepGradient(
                        colors: <Color>[
                          Color.fromRGBO(81, 163, 211, 1),
                          Color.fromRGBO(74, 102, 186, 1),
                         ],
                        stops: <double>[0.25, 0.75]),
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
                                          "TuningStatus.waytoohigh"?
                                          80:0,
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
}
