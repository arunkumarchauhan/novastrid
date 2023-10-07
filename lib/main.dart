import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novastrid/feature/home/bloc/home_bloc.dart';
import 'package:novastrid/feature/home/presentation/home_page.dart';
import 'package:novastrid/navigation/route_generator.dart';
import 'package:novastrid/navigation/routes_path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: RoutePath.home,
        onGenerateRoute: Routegenerator.generateRoute,
      ),
    );
  }
}
