import 'package:my_utilities/math_utils.dart';

/// Represents a slot on the game grid where u can set X, O or whatever

abstract class GridSlot {
  /// Called whenever the slot's GUI representation(widgets) requires an update
  void rebuild();

  /// The coordinates of the slot on the game grid
  Vec2<int> get pos; 
}
