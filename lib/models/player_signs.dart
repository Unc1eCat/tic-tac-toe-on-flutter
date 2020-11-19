import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// typedef HighlightableWidgetBuilder = Widget Function(BuildContext context, bool highlight);
typedef SignWidgetBuilder = Widget Function(BuildContext context, Color color);

// Represents GUI representation of a sign
class SignGUIDelegate extends Equatable {
  final String id;
  final String defaultName;
  final SignWidgetBuilder guiSmall; // That on the grid
  final SignWidgetBuilder guiMedium; // Usually in turn display
  final SignWidgetBuilder guiLarge; // Usually in win screen

  const SignGUIDelegate({
    @required this.id,
    @required this.defaultName,
    @required this.guiSmall,
    @required this.guiLarge,
    @required this.guiMedium,
  });

  @override
  List<Object> get props => [id];
}

class DefaultStringSignGUIDelegate extends SignGUIDelegate {
  DefaultStringSignGUIDelegate(String sign)
      : super(
          id: sign,
          defaultName: sign,
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

  factory SignGUIDelegates() {
    return _instance;
  }

  static final _instance = SignGUIDelegates._();

  static final values = List<SignGUIDelegate>();

  static SignGUIDelegate _add(SignGUIDelegate val) {
    values.add(val);
    return val;
  }

  final SignGUIDelegate x = _add(DefaultStringSignGUIDelegate("X"));

  final SignGUIDelegate o = _add(DefaultStringSignGUIDelegate("O"));

  /// Or "hashtag" or whatever it is, it's "#"
  final SignGUIDelegate sharp = _add(DefaultStringSignGUIDelegate("#"));

  final SignGUIDelegate y = _add(DefaultStringSignGUIDelegate("Y"));

  final SignGUIDelegate dollar = _add(DefaultStringSignGUIDelegate("\$"));

  final SignGUIDelegate g = _add(DefaultStringSignGUIDelegate("G"));

  final SignGUIDelegate at = _add(DefaultStringSignGUIDelegate("@"));

  final SignGUIDelegate exclamationMark = _add(DefaultStringSignGUIDelegate("!"));
}

class PlayerSign extends Equatable {
  final Key id;
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
