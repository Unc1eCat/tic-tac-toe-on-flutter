import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_utilities/math_utils.dart';
import 'package:rainbow_color/rainbow_color.dart';

import '../models/player_signs.dart';
import '../widgets/grid_slot_simple.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({
    // TODO: Add winLenght validation depended on the size
    @required this.size, // TODO: Make it private
    @required playerSigns,
    @required winLenght,
  })  : _playerSigns = playerSigns,
        this._winLenght = winLenght,
        super(GameState()) {
    _gridSlots = List.generate(size.x, (_) => List.generate(size.y, (_) => null));
    _signsColorSpectrum = Rainbow(spectrum: _playerSigns.map((e) => e.color).toList());
  }

  factory GameCubit.of(BuildContext context) {
    return BlocProvider.of<GameCubit>(context);
  }

  final Vec2<int> size;

  final List<Undoable> _actionsRecording = List();

  final List<PlayerSign> _playerSigns;
  List<PlayerSign> get playerSigns => List.unmodifiable(_playerSigns);

  int _winLenght; // Number of same signs in a row required to make this sign win
  int get winLenght => _winLenght;

  int _previousIndex = 0;
  int get previousIndex => _previousIndex;

  PlayerSign get currentSign => _playerSigns[_currentTurnIndex];

  int get slotsAmount => size.x * size.y;

  var _currentTurnIndex = 0;
  int get currentTurnIndex => _currentTurnIndex;

  List<List<PlayerSign>> _gridSlots;

  Rainbow _signsColorSpectrum;
  Rainbow get signColorSpectrum => _signsColorSpectrum;

  var _slotsSet = 0; // Used to check for draw and optimizaton. Represents amount of signs set on the grid

  var gridActive = true;

  bool isInRange(Vec2<int> value) => value.x < size.x && value.y < size.y && value.x >= 0 && value.y >= 0;
  void throwIfNotInRange(Vec2<int> value) {
    assert(isInRange(value), "The $value is not within range of the game grid that is $size");
  }

  PlayerSign slotAt(Vec2<int> pos) {
    return _gridSlots[pos.x][pos.y];
  }

  Vec2<int> indexToPos(int index) {
    return Vec2<int>((index % size.x).floor(), (index / size.x).floor());
  }

  void setSlotSign(Vec2<int> pos) {
    if (!gridActive) return;

    throwIfNotInRange(pos);

    _gridSlots[pos.x][pos.y] = _playerSigns[currentTurnIndex];
    _slotsSet++;
    emit(SetSlotSignGameState(pos, _playerSigns[currentTurnIndex]));

    var gameOverCheckResult = checkGameOver();
    if (gameOverCheckResult == null) {
      nextTurn();
      _actionsRecording.add(TurnUndoable(pos));
    } else {
      gridActive = false;
      emit(GameOverGameState(gameOverCheckResult));
    }
  }

  void nextTurn() {
    _previousIndex = _currentTurnIndex;
    _currentTurnIndex++;
    if (currentTurnIndex >= _playerSigns.length) _currentTurnIndex = 0;
    emit(TurnChangeGameState());
  }

  void undo() {
    if (_actionsRecording.isEmpty) return; // Nothing to undo
    var action = _actionsRecording.removeLast();
    action.undo(this);
    emit(ActionUndoneGameState(action));
  }

  /// Returns game over check result(winning player or draw). If the game can continue then returns null
  GameOverResult checkGameOver() {
    List<Vec2<int>> _collectWinningSlots(Vec2<int> finalPoint, int winLenght, CheckDirection checkDirection) {
      List<Vec2<int>> ret = [];
      for (var i = 0; i < winLenght; i++) {
        switch (checkDirection) {
          case CheckDirection.right:
            ret.add(Vec2<int>(finalPoint.x - i, finalPoint.y));
            break;
          case CheckDirection.down:
            ret.add(Vec2<int>(finalPoint.x, finalPoint.y - i));
            break;
          case CheckDirection.rightDown:
            ret.add(Vec2<int>(finalPoint.x - i, finalPoint.y - i));
            break;
          case CheckDirection.leftDown:
            ret.add(Vec2<int>(finalPoint.x + i, finalPoint.y - i));
            break;
        }
      }
      return ret;
    }

    // TODO: Otimize it. Make it check depending on the changed slot
    // Maybe make it pure function
    for (var i = 0; i < size.x; i++) {
      for (var j = 0; j < size.y; j++) {
        Vec2<int> point = Vec2<int>(i, j);
        PlayerSign sign = slotAt(point);

        if (sign == null) continue;

        for (var o = 1; o < _winLenght; o++) {
          // Right horizontal check -
          point.x++;
          if (point.x >= size.x) break;
          if (slotAt(point) != sign) break;
          print(point.x);
          if (o == _winLenght - 1) return PlayerWonGameOverResult(sign, _collectWinningSlots(point, _winLenght, CheckDirection.right));
        }

        point = Vec2<int>(i, j);
        for (var o = 1; o < _winLenght; o++) {
          // Down vertical check |
          point.y++;
          if (point.y >= size.y) break;
          if (slotAt(point) != sign) break;
          if (o == _winLenght - 1) return PlayerWonGameOverResult(sign, _collectWinningSlots(point, _winLenght, CheckDirection.down));
        }

        point = Vec2<int>(i, j);
        for (var o = 1; o < _winLenght; o++) {
          // Right-down diagonal check \
          point.x++;
          point.y++;
          if (point.x >= size.x || point.y >= size.y) break;
          if (slotAt(point) != sign) break;
          if (o == _winLenght - 1) return PlayerWonGameOverResult(sign, _collectWinningSlots(point, _winLenght, CheckDirection.rightDown));
        }

        point = Vec2<int>(i, j);
        for (var o = 1; o < _winLenght; o++) {
          // Left-down diagonal check /
          point.x--;
          point.y++;
          if (point.x < 0 || point.y >= size.y) break;
          if (slotAt(point) != sign) break;
          if (o == _winLenght - 1) return PlayerWonGameOverResult(sign, _collectWinningSlots(point, _winLenght, CheckDirection.leftDown));
        }
      }
    }

    if (_slotsSet >= slotsAmount) {
      return DrawGameOverResult();
    } else {
      return null;
    }
  }

  @override
  void onChange(Change<GameState> change) {
    print("$this emmited state: ${change.nextState}");
    super.onChange(change);
  }
}

// UNDOABLE

// Maybe mess with Equatable
abstract class Undoable {
  void undo(GameCubit cubit);

  // /// Must return false if actions cannot be redone any further
  // bool redo(GameCubit cubit);
}

class TurnUndoable implements Undoable {
  Vec2<int> position;

  TurnUndoable(this.position);

  // @override
  // bool redo(GameCubit cubit) {
  //   cubit._gridSlots[position.x][position.y] = cubit.currentSign;
  //   cubit._slotsSet++;
  //   cubit._currentTurnIndex = (cubit._currentTurnIndex + 1) % cubit._playerSigns.length;

  //   return true;
  // }

  @override
  bool undo(GameCubit cubit) {
    cubit._gridSlots[position.x][position.y] = null;
    cubit._slotsSet--;
    cubit._currentTurnIndex = (cubit._currentTurnIndex - 1) % cubit._playerSigns.length;

    return true;
  }
}

// STATES

class GameState extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class GridSlotGameState extends GameState {
  final Vec2<int> slotPosition;

  GridSlotGameState(this.slotPosition);

  @override
  List<Object> get props => super.props..add(slotPosition);
}

class ActionUndoneGameState extends GameState {
  final Undoable action;

  ActionUndoneGameState(this.action);

  @override
  List<Object> get props => super.props..add(action);
}

// class ActionRedoneGameState extends GameState {
//   final Undoable action;

//   ActionRedoneGameState(this.action);

//   @override
//   List<Object> get props => super.props..add(action);
// }

class TurnChangeGameState extends GameState {}

class SetSlotSignGameState extends GridSlotGameState {
  final PlayerSign sign;
  SetSlotSignGameState(Vec2<int> slotPosition, this.sign) : super(slotPosition);

  @override
  List<Object> get props => super.props..add(sign);
}

class GameOverGameState extends GameState {
  final GameOverResult result;

  GameOverGameState(this.result);

  @override
  List<Object> get props => super.props..add(result);
}

// GAME OVER RESULTS

class GameOverResult extends Equatable {
  // Maybe generalise it down to some kind of GridCheckResult
  @override
  List<Object> get props => [];
}

class DrawGameOverResult extends GameOverResult {}

class PlayerWonGameOverResult extends GameOverResult {
  final PlayerSign winner;
  final List<Vec2<int>> winningSlots;

  PlayerWonGameOverResult(this.winner, this.winningSlots);

  @override
  List<Object> get props => super.props..add(winner)..add(winningSlots);
}

// OTHER

enum CheckDirection { right, down, rightDown, leftDown }
