import 'package:flutter/material.dart';
import 'package:my_utilities/color_utils.dart';
import 'package:tic_tac_toe/bruh.dart';
import 'package:tic_tac_toe/screens/settings_screen.dart';

import '../widgets/colored_tab.dart';
import 'play_tab.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _controller,
        children: [
          PlayTab(),
          HomePage(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Theme.of(context).bottomAppBarColor,
        child: TabBar(
          controller: _controller,
          indicator: BoxDecoration(),
          tabs: [
            ColoredTab(
              icon: Icon(Icons.play_arrow),
              text: "Play",
              index: 0,
              controller: _controller,
              selectedColor: Colors.green,
              unselectedColor:
                  Colors.green.blendedWith(Theme.of(context).bottomAppBarColor.blendedWithInversion(0.45), 0.7),
            ),
            ColoredTab(
              icon: Icon(Icons.widgets),
              text: "Browse",
              index: 1,
              controller: _controller,
              selectedColor: Colors.orange[600],
              unselectedColor: Colors.deepOrange.blendedWith(Theme.of(context).bottomAppBarColor.blendedWithInversion(0.45), 0.7),
            ),
            ColoredTab(
              icon: Icon(Icons.settings),
              text: "Settings",
              index: 2,
              controller: _controller,
              selectedColor: Colors.blue,
              unselectedColor: Colors.blue.blendedWith(Theme.of(context).bottomAppBarColor.blendedWithInversion(0.45), 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
