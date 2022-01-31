import 'package:boxes/board.dart';
import 'package:boxes/game_controller_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameController>(
      create: (context) => GameController(GameState.initial(4)),
      child: MaterialApp(
        home: Board(),
      ),
    );
  }
}
