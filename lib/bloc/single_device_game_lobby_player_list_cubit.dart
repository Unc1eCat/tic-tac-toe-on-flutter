import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/models/player_signs.dart';
import 'package:tic_tac_toe/models/sd_game_args.dart';

class SingleDeviceGameLobbyPLayerListCubit extends Cubit {
  List<PlayerSign> _playersList;
  List<Color> _allColors;
  List<SignGUIDelegate> _allDelegates;

  SingleDeviceGameLobbyPLayerListCubit({
    List<Color> allColors,
    List<SignGUIDelegate> allDelegates,
    List<PlayerSign> playersList,
  })  : _allColors = allColors,
        _allDelegates = allDelegates,
        _playersList = playersList,
        super(SingleDeviceGameLobbyPLayerListState());

  void changeColor(Color color, ValueKey<int> playerKey) {
    emit(PlayerColorChangedSingleDeviceGameLobbyState(playerKey, color));
  }

  void changeSignGUIDeleagte(SignGUIDelegate signGUIDelegate, ValueKey<int> playerKey) {
    emit(PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState(playerKey, signGUIDelegate));
  }
}

// STATES

class SingleDeviceGameLobbyPLayerListState {}

class PlayerChangedSingleDeviceGameLobbyState extends SingleDeviceGameLobbyPLayerListState {
  final ValueKey<int> playerKey;

  PlayerChangedSingleDeviceGameLobbyState(this.playerKey);
}

class PlayerColorChangedSingleDeviceGameLobbyState extends PlayerChangedSingleDeviceGameLobbyState {
  final Color color;

  PlayerColorChangedSingleDeviceGameLobbyState(ValueKey<int> playerKey, this.color) : super(playerKey);
}

class PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState extends PlayerChangedSingleDeviceGameLobbyState {
  final SignGUIDelegate signGUIDelegate;

  PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState(ValueKey<int> playerKey, this.signGUIDelegate) : super(playerKey);
}
