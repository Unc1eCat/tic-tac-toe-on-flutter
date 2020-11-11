import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_utilities/math_utils.dart';
import 'package:my_utilities/widget_utils.dart';
import 'package:tic_tac_toe/bloc/game_cubit.dart';
import 'package:tic_tac_toe/widgets/bloc_builder_of_state_type.dart';
import 'package:tic_tac_toe/widgets/slot_highlightment.dart';
import '../models/player_signs.dart';
import 'bloc_listener_of_state_type.dart';
import 'package:my_utilities/color_utils.dart';

class GridSlotSimpleWidget extends StatefulWidget {
  final Vec2<int> pos;

  GridSlotSimpleWidget(
    this.pos, {
    Key key,
  }) : super(key: key);

  @override
  GridSlotSimpleWidgetState createState() => GridSlotSimpleWidgetState();
}

class GridSlotSimpleWidgetState extends State<GridSlotSimpleWidget> with StateHelperMixin {
  PlayerSign sign;
  var highlight = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (previous, current) {
        if (current is SetSlotSignGameState && current.slotPosition == widget.pos) {
          sign = current.sign;
          return true;
        }
        if (current is GameOverGameState &&
            current.result is PlayerWonGameOverResult &&
            (current.result as PlayerWonGameOverResult).winningSlots.contains(widget.pos)) {
          highlight = true;
          return true;
        }
        return false;
      },
      builder: (context, state) {
        // var sign = (state as SetSlotSignGameState).sign;
        return sign == null
            ? FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () => GameCubit.of(context).setSlotSign(widget.pos),
                child: SizedBox.expand(),
              )
            : (highlight
                ? SlotHighlightment(
                    child: Center(
                      child: sign.guiSmall(context),
                    ),
                    color: sign.color,
                  )
                : Center(
                    child: sign.guiSmall(context),
                  ));
      },
    );
  }
}
