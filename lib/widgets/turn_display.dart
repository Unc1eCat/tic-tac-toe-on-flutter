import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_utilities/widget_utils.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:tic_tac_toe/widgets/bloc_builder_of_state_type.dart';
import '../bloc/game_cubit.dart';
import '../bloc/game_cubit.dart';
import 'bloc_listener_of_state_type.dart';
import 'game_widget.dart';
import 'package:my_utilities/math_utils.dart' as math;
import 'package:my_utilities/color_utils.dart';

class TurnDisplay extends StatefulWidget {
  // TODO: Replace all "GameCubit.of(context)"" with local variables where the cubit will be cached
  // TODO: Complete it
  @override
  _TurnDisplayState createState() => _TurnDisplayState();
}

class _TurnDisplayState extends State<TurnDisplay> with StateHelperMixin, TickerProviderStateMixin {
  AnimationController _turnChangeAnimation;

  @override
  void initState() {
    _turnChangeAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150 * GameCubit.of(context).playerSigns.length),
    );
    super.initState();
  }

  void _changeTurn() {
    var gameCubit = GameCubit.of(context);
    _turnChangeAnimation.animateTo(gameCubit.currentTurnIndex / (gameCubit.playerSigns.length - 1));
  }

  double _transformValueForLeft(double value, double tension, int length) {
    var l = length - 1;
    return (math.pow(l * (_turnChangeAnimation.value % (1 / l)), tension) + (l * _turnChangeAnimation.value).floor()) / l;
  }

  double _transformValueForRight(double value, double tension, int length) {
    var l = length - 1;
    var ret = (1 - math.pow(1 - l * (_turnChangeAnimation.value % (1 / l)), tension) + (l * _turnChangeAnimation.value).floor()) / l;
    return math.min(ret, 1.0); // It wasnt supposed to give something more than 1.0 for _turnChangeAnimation.value <= 1.0
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 1.61803398875;
    var maxOffset = width - width / GameCubit.of(context).playerSigns.length;
    return BlocListenerOfStateType<GameCubit, GameState, TurnChangeGameState>.voidListener(
      listener: _changeTurn,
      child: SizedBox(
        height: 80,
        width: width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.8),
              child: Material(
                borderRadius: BorderRadius.circular(8),
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey[50],
                        Colors.white,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilderOfStateType<GameCubit, GameState, TurnChangeGameState>(builder: (context, state) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.only(
                  top: 3.8,
                  right: 3.8,
                  bottom: 3.8,
                  left: 3.8 + width * GameCubit.of(context).currentTurnIndex / GameCubit.of(context).playerSigns.length,
                ),
                width: width / GameCubit.of(context).playerSigns.length - 3.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      GameCubit.of(context).currentSign.color.withRangedHsvSaturation(0.7).withRotatedHsvHue(-5).withOpacity(0.8),
                      GameCubit.of(context).currentSign.color.withRangedHsvSaturation(0.8).withRotatedHsvHue(10).withOpacity(0.8),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              );
            }),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: GameCubit.of(context)
                  .playerSigns
                  .map((e) => Expanded(child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: e.guiLarge(context)))))
                  .toList(),
              // children: [
              // const SizedBox(
              //   width: width / 2,
              //   child: const Center(
              //     child: const Text('X', style: TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold)),
              //   ),
              // ),
              //   const SizedBox(
              //     width: width / 2,
              //     child: const Center(
              //       child: const Text('O', style: TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold)),
              //     ),
              //   ),
              // ],
            ),
            AnimatedBuilder(
              animation: _turnChangeAnimation,
              builder: (ctx, _) {
                return Container(
                  margin: EdgeInsets.only(
                    top: 0,
                    bottom: 0,
                    left: maxOffset * _transformValueForLeft(_turnChangeAnimation.value, 4, GameCubit.of(context).playerSigns.length),
                    // Old: width * math.clip(_turnChangeAnimation.value * 2 - 1, 0.0, 1.0) / 2,
                    right:
                        maxOffset * (1 - _transformValueForRight(_turnChangeAnimation.value, 4, GameCubit.of(context).playerSigns.length)),
                    // Old: width * math.clip(1 - _turnChangeAnimation.value * 2, 0.0, 1.0) / 2,
                  ),
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: GameCubit.of(context).signColorSpectrum[_turnChangeAnimation.value],
                      width: 4,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
