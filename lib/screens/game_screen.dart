import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_utilities/math_utils.dart';
import 'package:tic_tac_toe/models/player_signs.dart';
import 'package:tic_tac_toe/models/sd_game_args.dart';
import 'package:tic_tac_toe/widgets/bloc_listener_of_state_type.dart';
import '../bloc/game_cubit.dart';
import '../widgets/game_grid.dart';
import '../widgets/grid_slot_simple.dart';
import '../widgets/turn_display.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/game';

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameCubit _gameCubit;
  SingleDeviceGameArguments args;

  void _gameOverRoutine(GameOverResult result) async {
    await Future.delayed(Duration(seconds: 1));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(result is PlayerWonGameOverResult ? AppLocalizations.of(context).gameOverPlayerWonTitle(result.winner.name.toUpperCase()) : "Draw"),
        actions: [
          FlatButton.icon(
            onPressed: () {
              Navigator.pop(context);
              return Navigator.pushReplacementNamed(context, GameScreen.ROUTE_NAME, arguments: args);
            },
            icon: Icon(Icons.replay),
            label: Text("PLAY AGAIN"),
          ),
          FlatButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/");
            },
            icon: Icon(Icons.home),
            label: Text("MAIN MENU"),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context).settings.arguments as SingleDeviceGameArguments;

    _gameCubit = GameCubit(
      size: Vec2<int>(args.gridWidth, args.gridHeight),
      winLenght: args.winLenght,
      playerSigns: args.players,
      //  [

      //   // DefaultStringSignAppearance("0", "x", "X", Colors.red),
      //   // if (args.playersAmount >= 3) DefaultStringSignAppearance("1", "#", "#", Colors.green),
      //   // if (args.playersAmount >= 4) DefaultStringSignAppearance("2", "\$", "\$", Colors.yellow),
      //   // DefaultStringSignAppearance("3", "o", "O", Colors.blue),
      //   // if (args.playersAmount >= 5) DefaultStringSignAppearance("4", "u", "U", Colors.purple),
      //   // DefaultStringSignAppearance("#", "#", Colors.green),
      // ],
    );

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _gameCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameCubit>(
      create: (ctx) => _gameCubit,
      child: BlocListener<GameCubit, GameState>(
        listenWhen: (previous, current) => current is GameOverGameState,
        listener: (context, state) {
          if (state is GameOverGameState) {
            _gameOverRoutine(state.result);
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 330,
                  width: 330,
                  child: GameGrid(
                    gridHeight: _gameCubit.size.x,
                    gridWidth: _gameCubit.size.y,
                    child: GridView(
                      // TODO: Make it not scrollable
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _gameCubit.size.x,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      padding: EdgeInsets.zero,
                      children: [
                        ...List.generate(_gameCubit.slotsAmount, (i) => GridSlotSimpleWidget(_gameCubit.indexToPos(i), key: ValueKey(i))),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: TurnDisplay(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
