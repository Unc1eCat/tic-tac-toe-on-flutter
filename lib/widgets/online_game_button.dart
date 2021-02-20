import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_toe/main.dart';
import 'package:url_launcher/url_launcher.dart';

enum ExpandedMenuType { collapsed, findGame, joinViaCode }

class OnlineGameButton extends StatefulWidget {
  @override
  _OnlineGameButtonState createState() => _OnlineGameButtonState();
}

class _OnlineGameButtonState extends State<OnlineGameButton> with TickerProviderStateMixin {
  ExpandedMenuType _expandedMenuType;

  set expandedMenuType(ExpandedMenuType value) => setState(() => _expandedMenuType = value);

  @override
  void initState() {
    _expandedMenuType = ExpandedMenuType.collapsed;
    super.initState();
  }

  Widget _wrapInCard(Widget child, {EdgeInsetsGeometry margin = const EdgeInsets.all(8)}) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(250, 235, 230, 0.08),
          width: 1.5,
        ),
        color: Colors.white12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _buildCollapseButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.white24,
        onTap: () => expandedMenuType = ExpandedMenuType.collapsed,
        child: SizedBox(
          height: 34,
          width: double.infinity,
          child: Icon(Icons.keyboard_arrow_up_rounded),
        ),
      ),
    );
  }

  Widget _buildButton(Widget child, VoidCallback onPressed) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: Center(
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.transparent,
      elevation: 5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              Colors.deepOrange[400],
              Colors.amberAccent[700],
              Colors.orangeAccent,
            ],
            stops: [
              0.2,
              0.7,
              1.0,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text("Play online", style: Theme.of(context).textTheme.headline5),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 14, top: 10),
              child: StreamBuilder<Future<int>>(
                  stream: Stream.periodic(
                    Duration(seconds: 6),
                    (n) => http
                        .get("http://${TheApp.backendUrl}/game/get_online_amount")
                        .then((value) => value.bodyBytes.first),
                  ),
                  builder: (context, snap) {
                    return FutureBuilder<int>(
                        future: snap.data,
                        builder: (context, snap2) => Text(snap2.hasData ? snap2.data.toString() + " online" : "Online players unavailable",
                            style: Theme.of(context).textTheme.bodyText1));
                  }),
            ),
            Divider(height: 1.2),
            if (_expandedMenuType == ExpandedMenuType.findGame) _wrapInCard(Column()),
            if (_expandedMenuType == ExpandedMenuType.findGame) Divider(height: 1.2),
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              vsync: this,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 190),
                child: _expandedMenuType == ExpandedMenuType.findGame
                    ? _buildCollapseButton()
                    : _buildButton(
                        Text("Find game"),
                        () => expandedMenuType = ExpandedMenuType.findGame,
                      ),
              ),
            ),
            Divider(height: 1.2),
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              vsync: this,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 190),
                child: _expandedMenuType == ExpandedMenuType.joinViaCode
                    ? _buildCollapseButton()
                    : _buildButton(
                        Text("Join via code"),
                        () => expandedMenuType = ExpandedMenuType.joinViaCode,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
