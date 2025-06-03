import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pretest/bloc/food_bloc/food_bloc.dart';
import 'package:pretest/bloc/order_bloc/order_event.dart';
import 'package:pretest/repositories/food_repository.dart';

import 'bloc/order_bloc/order_bloc.dart';
import 'views/welcome_view.dart';

class PretestApp extends StatelessWidget {
  const PretestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FoodBloc(foodRepository: FoodRepository())..add(LoadFood()),
        ),
        BlocProvider(create: (context) => OrderBloc()),
        BlocProvider(
          create: (context) => OrderBloc()..add(const ResetOrder()),
        ),
      ],
      child: const MaterialApp(
        title: 'Pre Test App',
        debugShowCheckedModeBanner: false,
        home: WelcomeView(),
      ),
    );
  }
}
