// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:my_utilities/math_utils.dart';

// import '../models/grid_slot.dart';
// import '../models/player_signs.dart';

// class GameInherited extends InheritedModel {
//   final List<List<GridSlot>> _gridSlots;
//   final Vec2<int> _size;
//   final List<PlayerSign> _playerSigns;
//   final int currentSignIndex;

//   List<PlayerSign> get playerSigns => List.unmodifiable(_playerSigns);

//   Vec2<int> get size => _size;

//   GameInherited(this._size, this._playerSigns, this.currentSignIndex) : _gridSlots = List.filled(_size.x, List.filled(_size.y, null));

//   void bindSlot(GridSlot gridSlot) {
//     assert(isInRange(gridSlot.pos), "The grid slot is outside of the grid's boundaries");

//     _gridSlots[gridSlot.pos.x][gridSlot.pos.y] = gridSlot;
//   }

//   GlobalKey bindSlotByKey(GlobalKey key) {
//     bindSlot(key.currentState as GridSlot);

//     return key;
//   }

//   void nextTurn() {
//     currentSignIndex turnSign = _playerSigns[currentSignIndex];
//   }

//   bool isInRange(Vec2<int> value) => value.x < _size.x && value.y < _size.y && value.x >= 0 && value.y >= 0;

//   Vec2<int> indexToPos(int index) {
//     return Vec2<int>((index % _size.y).floor(), (index / _size.x).floor());
//   }

//   @override
//   bool updateShouldNotifyDependent(InheritedModel oldWidget, Set dependencies) {
//     return true;
//   }

//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) {
//     return this != oldWidget;
//   }
// }

// enum GameDependencies { Any, NextTurn }

// class GameWidget extends StatefulWidget {
//   @override
//   _GameWidgetState createState() => _GameWidgetState();
// }

// class _GameWidgetState extends State<GameWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
