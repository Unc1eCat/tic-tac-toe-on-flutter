import 'package:flutter/material.dart';
import 'package:my_utilities/color_utils.dart';
import 'package:tic_tac_toe/bruh.dart';
import 'package:tic_tac_toe/main.dart';
import 'package:tic_tac_toe/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as ul;

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
      bottomNavigationBar: FutureBuilder<http.Response>(
          future: http.get(
              "http://${TheApp.backendUrl}/game/app_update_check&current_version=${TheApp.appVersion}"), // "no" - no updates available, "update" - not required update available, "required" - required update available
          builder: (context, snap) {
            var tabBar = SizedBox(
              height: 60,
              child: ColoredBox(
                color: Theme.of(context).bottomAppBarColor,
                child: TabBar(
                  controller: _controller,
                  indicator: BoxDecoration(),
                  tabs: [
                    ColoredTab(
                      icon: Icon(Icons.play_arrow),
                      text: AppLocalizations.of(context).tabBarPlay,
                      index: 0,
                      controller: _controller,
                      selectedColor: Colors.green,
                      unselectedColor: Theme.of(context).bottomAppBarColor.blendedWithInversion(0.9),
                    ),
                    ColoredTab(
                      icon: Icon(Icons.widgets),
                      text: AppLocalizations.of(context).tabBarBrowse,
                      index: 1,
                      controller: _controller,
                      selectedColor: Colors.orange[600],
                      unselectedColor: Theme.of(context).bottomAppBarColor.blendedWithInversion(0.9),
                    ),
                    ColoredTab(
                      icon: Icon(Icons.settings),
                      text: AppLocalizations.of(context).tabBarSettings,
                      index: 2,
                      controller: _controller,
                      selectedColor: Colors.blue,
                      unselectedColor: Theme.of(context).bottomAppBarColor.blendedWithInversion(0.9),
                    ),
                  ],
                ),
              ),
            );

            return snap.hasData && (snap.data.body.startsWith("update") || snap.data.body.startsWith("required"))
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).accentColor.withHsvValue(0.8).withRangedHsvSaturation(0.7),
                              Theme.of(context).accentColor.withRangedHsvSaturation(0.8),
                              Theme.of(context).accentColor.withHsvValue(0.8).withRangedHsvSaturation(0.7),
                            ],
                            stops: [
                              0.1,
                              0.5,
                              1.0,
                            ],
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Theme.of(context).accentColor.withRotatedHsvHue(20).withOpacity(0.24),
                            onTap: () async {
                              var data = snap.data.body.split("&");
                              
                              if (data.length >= 1 && await ul.canLaunch(data[1]))
                              {
                                await ul.launch(data[1]);
                              }
                            },
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 100,
                                maxWidth: double.infinity,
                                minHeight: 0,
                                minWidth: double.infinity,
                              ),
                              child: Align(
                                heightFactor: 1,
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Text("New update is available! Tap to update"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      tabBar,
                    ],
                  )
                : tabBar;
          }),
    );
  }
}
