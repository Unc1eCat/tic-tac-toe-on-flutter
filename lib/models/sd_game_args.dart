import 'package:tic_tac_toe/models/player_signs.dart';

class SingleDeviceGameArguments // TODO: Make it extend Equatable
{
  int gridWidth;
  int gridHeight;
  int winLenght;
  List<PlayerSign> players = [];
}
