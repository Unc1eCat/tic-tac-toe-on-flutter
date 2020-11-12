import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:my_utilities/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:tic_tac_toe/models/player_signs.dart';
import 'package:tic_tac_toe/models/sd_game_args.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/widgets/color_input_form_field.dart';
import 'package:tic_tac_toe/widgets/number_input_form_field.dart';
import 'package:tic_tac_toe/widgets/white_button.dart';

/* ! ATTENTION ! 
* Whoever writes this form more clear effective and performant is a hero. I would appreciate ur pr.
*/

// class SingleDeviceFormOutput
// {
//   int gridWidth;
//   int gridHeight;
//   int winLenght;
//   List<SingleDeviceGameSettingsPlayerListItem> players = [];
// }

class SingleDeviceGameButton extends StatefulWidget {
  @override
  _SingleDeviceGameButtonState createState() => _SingleDeviceGameButtonState();
}

Widget _wrapInCard(Widget child, {EdgeInsetsGeometry margin = const EdgeInsets.all(8)}) {
  return Container(
    margin: margin,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.white12,
        width: 1.2,
      ),
      color: Colors.white12,
      borderRadius: BorderRadius.circular(8),
    ),
    child: child,
  );
}

class _SingleDeviceGameButtonState extends State<SingleDeviceGameButton> with TickerProviderStateMixin {
  var _form = GlobalKey<FormState>();
  var _playerSignsListState = GlobalKey<_SingleDeviceGameSettingsPlayerListState>();
  var expanded = false;
  var args = SingleDeviceGameArguments();

  // Widget _buildButton(Widget child, VoidCallback onPressed) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         color: Colors.white12,
  //         width: 1.2,
  //       ),
  //       color: Colors.white10,
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         borderRadius: BorderRadius.circular(8),
  //         highlightColor: Colors.transparent,
  //         child: Center(child: child),
  //         onTap: onPressed,
  //       ),
  //     ),
  //   );
  // }

  void _play() async {
    _form.currentState.save();
    args.players = _playerSignsListState.currentState.playerSigns.map((e) => e.value).toList();
    // print(args.players);
    Navigator.pushReplacementNamed(context, GameScreen.ROUTE_NAME, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    _form = GlobalKey<FormState>();
    _playerSignsListState = GlobalKey<_SingleDeviceGameSettingsPlayerListState>();
    var content = expanded
        ? Form(
            key: _form,
            child: Provider.value(
              value: args,
              child: Column(
                children: [
                  if (expanded)
                    _wrapInCard(
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Grid width",
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                SizedBox(width: 10),
                                NumberInputFormField(
                                  onSaved: (newValue) => args.gridWidth = newValue,
                                  initialValue: 3,
                                  min: 2,
                                  max: 20,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Grid height",
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                SizedBox(width: 10),
                                NumberInputFormField(
                                  onSaved: (newValue) => args.gridHeight = newValue,
                                  initialValue: 3,
                                  min: 2,
                                  max: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (expanded)
                    _wrapInCard(
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Row lenght required to win",
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                SizedBox(width: 10),
                                NumberInputFormField(
                                  onSaved: (newValue) => args.winLenght = newValue,
                                  initialValue: 3,
                                  min: 2,
                                  max: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (expanded)
                    _wrapInCard(
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: SingleDeviceGameSettingsPlayerList(
                          [
                            PlayerSign(id: "0", color: Colors.red, name: "x", guiDelegate: SignGUIDelegates().x),
                            PlayerSign(id: "1", color: Colors.blue, name: "o", guiDelegate: SignGUIDelegates().o),
                          ],
                          key: _playerSignsListState,
                        ),
                      ),
                    ),
                  if (expanded) Divider(),
                  if (expanded)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(width: double.infinity, height: 50, child: WhiteButton(child: Text("PLAY"), onPressed: _play)),
                    ),
                ],
              ),
            ),
          )
        : null;

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
              Colors.blue[200].withRangedHsvSaturation(0.73),
              Colors.indigoAccent[200].withRangedHsvSaturation(0.55),
              Colors.blueAccent[100],
            ],
            stops: [
              0.3,
              0.7,
              1.0,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // TODO: Wrap it in a LimitedBox

          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 20,
              ),
              child: Text(
                "Play on this device",
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            if (expanded) Divider(),
            Flexible(
              child: AnimatedSize(
                alignment: Alignment.topCenter,
                vsync: this,
                duration: Duration(milliseconds: 320),
                child: SizedBox(
                  width: double.infinity,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 320),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween(begin: Offset(0, -0.3), end: Offset(0, 0)).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: expanded
                        ? content
                        : Material(
                            color: Colors.transparent,
                            shadowColor: Colors.transparent,
                            child: SizedBox.shrink(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  setState(() => expanded = true);
                                },
                                child: content,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Divider(height: 1),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() => expanded = !expanded);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  color: expanded ? Colors.white.withAlpha(40) : Colors.transparent,
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SingleDeviceGameSettingsPlayerListItem {
  ValueKey<int> key; // Maybe I will replace it with the id of the player sign.
  PlayerSign value;

  SingleDeviceGameSettingsPlayerListItem(
    this.key,
    this.value,
  );
}

class SingleDeviceGameSettingsPlayerList extends StatefulWidget {
  /// Set [_playerSigns] to null or don't change them to keep old state
  final List<PlayerSign> _playerSigns;

  const SingleDeviceGameSettingsPlayerList(
    this._playerSigns, {
    Key key,
  }) : super(key: key);

  @override
  _SingleDeviceGameSettingsPlayerListState createState() => _SingleDeviceGameSettingsPlayerListState();
}

class _SingleDeviceGameSettingsPlayerListState extends State<SingleDeviceGameSettingsPlayerList> {
  List<SingleDeviceGameSettingsPlayerListItem> _playerSigns = [];
  static var lastId = 0;

  List<SingleDeviceGameSettingsPlayerListItem> get playerSigns => List.unmodifiable(_playerSigns);

  @override
  void initState() {
    if (widget._playerSigns != null) {
      for (var i = 0; i < widget._playerSigns.length; i++) {
        _playerSigns.add(SingleDeviceGameSettingsPlayerListItem(
          ValueKey(i),
          widget._playerSigns[i], /*i*/
        ));
      }
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SingleDeviceGameSettingsPlayerList oldWidget) {
    if (oldWidget._playerSigns == widget._playerSigns || widget._playerSigns == null) return;

    _applyInitialPlayerSigns();
    super.didUpdateWidget(oldWidget);
  }

  void _applyInitialPlayerSigns() {
    for (var i = 0; i < widget._playerSigns.length; i++) {
      _playerSigns.add(SingleDeviceGameSettingsPlayerListItem(
        ValueKey(i),
        widget._playerSigns[i], /*i*/
      ));
    }
  }

  void _addPlayer() {
    print(SignGUIDelegates.values);
    PlayerSign newPlayer = PlayerSign(
      color: RandomColor().randomColor(), // TODO: Make it automatically choose the most contrast color to colors of the existing players
      id: String.fromCharCode(lastId++), // Pray it doesn't reach the integer limit
      guiDelegate: SignGUIDelegates.values[_playerSigns.length],
      name: SignGUIDelegates.values[_playerSigns.length].defaultName,
    );

    setState(
      () => _playerSigns.add(
        SingleDeviceGameSettingsPlayerListItem(
          ValueKey(_playerSigns.length),
          newPlayer, /*_playerSigns.length*/
        ),
      ),
    );
  }

  void _removePlayer(ValueKey<int> key) {
    var removedIndex = _playerSigns.indexWhere((e) => e.key == key);

    setState(() {
      _playerSigns.removeAt(removedIndex);
    });
  }

  Widget _buildChild(BuildContext context, ReorderableItemState state, SingleDeviceGameSettingsPlayerListItem data) {
    Widget content = Dismissible(
      direction: DismissDirection.endToStart,
      background: Card(
        color: Colors.red[300],
        shadowColor: Colors.redAccent[700],
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.delete),
          ),
        ),
      ),
      onDismissed: (direction) => _removePlayer(data.key),
      key: data.key,
      child: SizedBox(
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: _wrapInCard(
                TextField(
                  // TODO: Make the name have max lenght
                  cursorRadius: Radius.circular(2.5),
                  enableSuggestions: true,
                  keyboardType: TextInputType.name,
                  onChanged: (newValue) => data.value = data.value.copyWith(name: newValue),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Player name",
                  ),
                  cursorColor: Colors.white54,
                  controller: TextEditingController(text: data.value.name),
                  style: Theme.of(context).textTheme.headline6,
                ),
                margin: EdgeInsets.zero,
              ),
            ),
            SizedBox(width: 12),
            // FormField<SignGUIDelegate>(
            //   initialValue: data.value.guiDelegate,
            //   onSaved: (newValue) => data.value = data.value.copyWith(guiDelegate: newValue),
            //   builder: (field) => WhiteButton(
            //     child: Padding(
            //       padding: const EdgeInsets.all(8),
            //       child: field.value.guiSmall(context, Colors.white),
            //     ),
            //   ),
            // ),
            WhiteButton(
              onPressed: () {/* Open sign selector */},
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: data.value.guiDelegate.guiSmall(context, Colors.white),
              ),
            ),
            SizedBox(width: 16),
            ColorInput(
              initialValue: data.value.color,
              onChanged: (newValue) => data.value = data.value.copyWith(color: newValue),
            ),
            SizedBox(width: 10),
            DelayedReorderableListener(
              delay: Duration(milliseconds: 460),
              child: Icon(
                Icons.drag_indicator_rounded,
              ),
            ),
          ],
        ),
      ),
    );

    return Opacity(
      opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(_playerSigns);
    return ReorderableList(
      onReorder: (draggedItem, newPosition) {
        var oldIndex = _playerSigns.indexWhere((e) => e.key == draggedItem);
        var newIndex = _playerSigns.indexWhere((e) => e.key == newPosition);
        final item = _playerSigns[oldIndex];

        setState(() {
          // item.currentIndex = newIndex;
          _playerSigns.removeAt(oldIndex);
          _playerSigns.insert(newIndex, item);
          print("Reoredering [$oldIndex] -> [$newIndex]");
        });
        return true;
      },
      child: CustomScrollView(
        // TODO: Make be part of the "root" column
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              _playerSigns
                  .map((e) => ReorderableItem(
                        key: e.key,
                        childBuilder: (context, state) => _buildChild(context, state, e),
                      ))
                  .toList(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if (_playerSigns.length < 2) SizedBox(height: 12),
                if (_playerSigns.length < 2)
                  Text(
                    "There must be at least 2 players to be able to start the game",
                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.red[600]),
                  ),
                SizedBox(height: 12),
                WhiteButton(
                  onPressed: _addPlayer,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        Text(" ADD PLAYER"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
