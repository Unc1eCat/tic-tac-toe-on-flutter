import 'package:flutter/material.dart';
import 'package:tic_tac_toe/models/player_signs.dart';

class SingleDeviceGameArguments // TODO: Make it extend Equatable
{
  int gridWidth;
  int gridHeight;
  int winLenght;
  List<PlayerSign> players = [];

  SingleDeviceGameArguments();

  SingleDeviceGameArguments.initial()
      : gridWidth = 3,
        gridHeight = 3,
        winLenght = 3,
        players = [
          PlayerSign(
            id: ValueKey(0),
            color: Colors.red,
            guiDelegate: SignGUIDelegates().x,
            name: "X",
          ),
          PlayerSign(
            id: ValueKey(1),
            color: Colors.blue,
            guiDelegate: SignGUIDelegates().o,
            name: "O",
          ),
        ];
}
