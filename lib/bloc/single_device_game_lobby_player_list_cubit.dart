import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_color/random_color.dart';
import 'package:tic_tac_toe/models/player_signs.dart';
import 'package:tic_tac_toe/models/sd_game_args.dart';

class SingleDeviceGameLobbyPLayerListCubit extends Cubit<SingleDeviceGameLobbyPLayerListState> {
  static var _lastId = 0;

  static int get lastId => _lastId;

  SingleDeviceGameLobbyPLayerListCubit({
    List<Color> allColors,
    List<SignGUIDelegate> allDelegates,
    List<PlayerSign> playersList,
  })  : _allColors = allColors,
        _allDelegates = allDelegates,
        _playersList = playersList,
        super(SingleDeviceGameLobbyPLayerListState());

  List<PlayerSign> _playersList;
  List<PlayerSign> get playersList => List.unmodifiable(_playersList);

  List<Color> _allColors;
  List<Color> get allColors => List.unmodifiable(_allColors);

  List<SignGUIDelegate> _allDelegates;

  PlayerSign playerOfId(Key id) {
    return _playersList.firstWhere(((e) => e.id == id));
  }

  PlayerSign playerAt(int index) {
    return _playersList[index];
  }

  int indexOfId(Key id) {
    return _playersList.indexWhere((e) => e.id == id);
  }

  void changeColor(Color color, int index) {
    _playersList[index] = _playersList[index].copyWith(color: color);
    emit(PlayerColorChangedSingleDeviceGameLobbyState(index, color));
  }

  void changeSignGUIDeleagte(SignGUIDelegate signGUIDelegate, int index) {
    _playersList[index] = _playersList[index].copyWith(guiDelegate: signGUIDelegate);
    emit(PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState(index, signGUIDelegate));
  }

  void changePlayerName(String name, int index) {
    _playersList[index] = _playersList[index].copyWith(name: name);
    emit(PlayerNameChangedSingleDeviceGameLobbyState(index, name));
  }

  void addPlayer(PlayerSign newPlayer) {
    _playersList.add(newPlayer);
    emit(AddedPlayerSingleDeviceGameLobbyPLayerListState(newPlayer));
  }

  void constructAndAddPlayer() {
    var newPlayer = PlayerSign(
      color: RandomColor().randomColor(), // TODO: Make it automatically choose the most contrast color to colors of the existing players
      id: ValueKey(_lastId++), // Pray it doesn't reach the integer limit
      guiDelegate: SignGUIDelegates.values[_playersList.length],
      name: SignGUIDelegates.values[_playersList.length].defaultName,
    );
    _playersList.add(newPlayer);
  }

  void removePlayer(int index) {
    _playersList.removeAt(index);
    emit(RemovePlayerSingleDeviceGameLobbyPLayerListState(index));
  }

  void reorder(Key draggedItem, Key newPosition) {
    var oldIndex = _playersList.indexWhere((e) => e.id == draggedItem);
    var newIndex = _playersList.indexWhere((e) => e.id == newPosition);
    final item = _playersList[oldIndex];

    _playersList.removeAt(oldIndex);
    _playersList.insert(newIndex, item);
    print("Reoredering [$oldIndex] -> [$newIndex]");
  }
}

// STATES

class SingleDeviceGameLobbyPLayerListState {}

class PlayerChangedSingleDeviceGameLobbyState extends SingleDeviceGameLobbyPLayerListState {
  final int playerIndex;

  PlayerChangedSingleDeviceGameLobbyState(this.playerIndex);
}

class PlayerColorChangedSingleDeviceGameLobbyState extends PlayerChangedSingleDeviceGameLobbyState {
  final Color color;

  PlayerColorChangedSingleDeviceGameLobbyState(int playerIndex, this.color) : super(playerIndex);
}

class PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState extends PlayerChangedSingleDeviceGameLobbyState {
  final SignGUIDelegate signGUIDelegate;

  PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState(int playerIndex, this.signGUIDelegate) : super(playerIndex);
}

class PlayerNameChangedSingleDeviceGameLobbyState extends PlayerChangedSingleDeviceGameLobbyState {
  final String name;

  PlayerNameChangedSingleDeviceGameLobbyState(int playerIndex, this.name) : super(playerIndex);
}

class AddedPlayerSingleDeviceGameLobbyPLayerListState extends SingleDeviceGameLobbyPLayerListState {
  final PlayerSign newPlayer;

  AddedPlayerSingleDeviceGameLobbyPLayerListState(this.newPlayer);
}

class RemovePlayerSingleDeviceGameLobbyPLayerListState extends PlayerChangedSingleDeviceGameLobbyState {
  RemovePlayerSingleDeviceGameLobbyPLayerListState(int playerIndex) : super(playerIndex);
}

class ReorderedPlayersSingleDeviceGameLobbyPLayerListState extends PlayerChangedSingleDeviceGameLobbyState
{
  ReorderedPlayersSingleDeviceGameLobbyPLayerListState(int playerIndex) : super(playerIndex);
}
