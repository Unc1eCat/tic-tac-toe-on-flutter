import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// typedef HighlightableWidgetBuilder = Widget Function(BuildContext context, bool highlight);
typedef SignWidgetBuilder = Widget Function(BuildContext context, Color color);

// Represents GUI representation of a sign
class SignGUIDelegate {
  final SignWidgetBuilder guiSmall; // That on the grid
  final SignWidgetBuilder guiMedium; // Usually in turn display
  final SignWidgetBuilder guiLarge; // Usually in win screen

  const SignGUIDelegate({
    @required this.guiSmall,
    @required this.guiLarge,
    @required this.guiMedium,
  });

  // @override
  // List<Object> get props => [id];
}

class DefaultStringSignGUIDelegate extends SignGUIDelegate {
  DefaultStringSignGUIDelegate(String sign)
      : super(
          guiSmall: (context, color) => Text(sign,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              )),
          guiLarge: (context, color) => Text(sign, style: TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold)),
          guiMedium: null,
        );
}

class SignGUIDelegates {
  SignGUIDelegates._();

  static final SignGUIDelegate x = DefaultStringSignGUIDelegate("X");
  static final SignGUIDelegate o = DefaultStringSignGUIDelegate("O");

  /// Or "hashtag" or whatever it is, it's "#"
  static final SignGUIDelegate sharp = DefaultStringSignGUIDelegate("#");
  static final SignGUIDelegate y = DefaultStringSignGUIDelegate("Y");
  static final SignGUIDelegate dollar = DefaultStringSignGUIDelegate("\$");
  static final SignGUIDelegate g = DefaultStringSignGUIDelegate("G");
  static final SignGUIDelegate at = DefaultStringSignGUIDelegate("@");
  static final SignGUIDelegate exclamationMark = DefaultStringSignGUIDelegate("!");
}

class PlayerSign extends Equatable {
  final String id;
  final SignGUIDelegate guiDelegate;
  final Color color;
  final String name;

  PlayerSign({
    @required this.id,
    @required this.color,
    @required this.name,
    @required this.guiDelegate,
  });

  @override
  List<Object> get props => [id];

  Widget guiSmall(BuildContext context) => guiDelegate.guiSmall(context, color);
  Widget guiMedium(BuildContext context) => guiDelegate.guiMedium(context, color);
  Widget guiLarge(BuildContext context) => guiDelegate.guiLarge(context, color);

  PlayerSign copyWith({
    String id,
    Color color,
    String name,
    SignGUIDelegate guiDelegate,
  }) {
    return PlayerSign(
      id: id ?? this.id,
      color: color ?? this.color,
      name: name ?? this.name,
      guiDelegate: guiDelegate ?? this.guiDelegate,
    );
  }
}
