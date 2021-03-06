import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_color/random_color.dart';
import 'package:tic_tac_toe/models/player_signs.dart';
import 'package:tic_tac_toe/models/sd_game_args.dart';

typedef Future<bool> OnConflictCallback(int occupier);

class SingleDeviceGameLobbyPLayerListCubit extends Cubit<SingleDeviceGameLobbyPLayerListState> {
  static const maxPlayers = 7;

  var _lastId;
  int get lastId => _lastId;

  SingleDeviceGameLobbyPLayerListCubit({
    List<Color> allColors,
    List<SignGUIDelegate> allDelegates,
    List<PlayerSign> playersList,
  })  : _allColors = allColors,
        _allDelegates = allDelegates,
        _playersList = playersList,
        _lastId = playersList.length,
        super(SingleDeviceGameLobbyPLayerListState());

  List<PlayerSign> _playersList;
  List<PlayerSign> get playersList => List.unmodifiable(_playersList);

  List<Color> _allColors;
  List<Color> get allColors => List.unmodifiable(_allColors);

  List<SignGUIDelegate> _allDelegates;
  List<SignGUIDelegate> get allDelegates => List.unmodifiable(_allDelegates);

  /// Returns -1 if it's not occupied
  int isColorOccupied(Color color) {
    return _playersList.indexWhere((e) => e.color == color);
  }

  /// Returns -1 if it's not occupied
  int isSignGUIDelegateOccupied(SignGUIDelegate delegate) {
    return _playersList.indexWhere((e) => e.guiDelegate == delegate);
  }

  Color uncoccupiedColor() {
    return _allColors.firstWhere((c) => _playersList.every((p) => p.color != c));
  }

  SignGUIDelegate uncoccupiedSignGUIDelegate() {
    return _allDelegates.firstWhere((d) => _playersList.every((p) => p.guiDelegate != d));
  }

  PlayerSign playerOfId(Key id) {
    return _playersList.firstWhere(((e) => e.id == id));
  }

  PlayerSign playerAt(int index) {
    return _playersList[index];
  }

  int indexOfId(Key id) {
    return _playersList.indexWhere((e) => e.id == id);
  }

  bool isFullPlayers() {
    return _playersList.length >= maxPlayers;
  }

  Future<void> changeColor(Color color, int index, OnConflictCallback onConflict) async {
    var occupier = isColorOccupied(color);

    if (occupier == index) return;

    if (occupier == -1) {
      _playersList[index] = _playersList[index].copyWith(color: color);
      emit(PlayerColorChangedSingleDeviceGameLobbyState(index, color));
    } else if (await onConflict(occupier) ?? false) {
      _playersList[occupier] = _playersList[occupier].copyWith(color: _playersList[index].color);
      _playersList[index] = _playersList[index].copyWith(color: color);
      emit(PlayerColorChangedSingleDeviceGameLobbyState(occupier, _playersList[occupier].color));
      emit(PlayerColorChangedSingleDeviceGameLobbyState(index, color));
    }
  }

  void changeSignGUIDeleagte(SignGUIDelegate delegate, int index, OnConflictCallback onConflict) async {
    var occupier = isSignGUIDelegateOccupied(delegate);

    if (occupier == index) return;

    if (occupier == -1) {
      _playersList[index] = _playersList[index].copyWith(guiDelegate: delegate);
      emit(PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState(index, delegate));
    } else if (await onConflict(occupier) ?? false) {
      _playersList[occupier] = _playersList[occupier].copyWith(guiDelegate: _playersList[index].guiDelegate);
      _playersList[index] = _playersList[index].copyWith(guiDelegate: delegate);
      emit(PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState(occupier, _playersList[occupier].guiDelegate));
      emit(PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState(index, delegate));
    }
  }

  void changePlayerName(String name, int index) {
    _playersList[index] = _playersList[index].copyWith(name: name);
    emit(PlayerNameChangedSingleDeviceGameLobbyState(index, name));
  }

  void addPlayer(PlayerSign newPlayer) {
    _playersList.add(newPlayer);
    print(_playersList);
    emit(AddedPlayerSingleDeviceGameLobbyPLayerListState(newPlayer));
  }

  void constructAndAddPlayer() {
    if (isFullPlayers()) return;

    print("Last ID: $lastId");
    var signGUIDelegate = uncoccupiedSignGUIDelegate();
    var newPlayer = PlayerSign(
      // TODO: Make players amount limit
      color: uncoccupiedColor(),
      id: ValueKey(_lastId++), // Pray it doesn't reach the integer limit
      guiDelegate: signGUIDelegate,
      name: signGUIDelegate.defaultName,
    );
    print("New last ID: $lastId");
    addPlayer(newPlayer);
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
    // print("Reoredering [$oldIndex] -> [$newIndex]");
    print(_playersList);
    emit(ReorderedPlayersSingleDeviceGameLobbyPLayerListState(oldIndex));
  }

  @override
  void onChange(Change<SingleDeviceGameLobbyPLayerListState> change) {
    print("$this emitted ${change.nextState}");
    super.onChange(change);
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

class ReorderedPlayersSingleDeviceGameLobbyPLayerListState extends PlayerChangedSingleDeviceGameLobbyState {
  ReorderedPlayersSingleDeviceGameLobbyPLayerListState(int playerIndex) : super(playerIndex);
}
