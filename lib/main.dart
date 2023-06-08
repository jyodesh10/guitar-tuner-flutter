import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guitar_tuner/features/home/presentation/bloc/home_bloc.dart';

import 'features/home/presentation/bloc/tunings_cubit/tunings_cubit.dart';
import 'features/home/presentation/pages/home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(),
          ),
          BlocProvider<TuningsCubit>(
            create: (context) => TuningsCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: 
          // const MetronomePage()
          const HomePage(),
          // const RiveBackground(),
        ));
  }
}


