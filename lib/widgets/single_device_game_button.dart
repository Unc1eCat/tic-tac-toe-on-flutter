import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:my_utilities/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/bloc/single_device_game_lobby_player_list_cubit.dart';
import 'package:tic_tac_toe/main.dart';
import 'package:tic_tac_toe/models/player_signs.dart';
import 'package:tic_tac_toe/models/sd_game_args.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/widgets/animated_in_out.dart';
import 'package:tic_tac_toe/widgets/color_input_form_field.dart';
import 'package:tic_tac_toe/widgets/number_input_form_field.dart';
import 'package:tic_tac_toe/widgets/sign_input.dart';
import 'package:tic_tac_toe/widgets/white_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        color: Color.fromRGBO(250, 235, 230, 0.08),
        width: 1.5,
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

  void _play() async {
    _form.currentState.save();
    args.players = _playerSignsListState.currentState.playerSigns.toList();
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
                                    TheApp.localization(context).playOnThisDeviceGridWidth,
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                SizedBox(width: 10),
                                NumberInputFormField(
                                  onSaved: (newValue) => args.gridWidth = newValue,
                                  initialValue: 3,
                                  min: 1,
                                  max: 10,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    TheApp.localization(context).playOnThisDeviceGridHeight,
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                SizedBox(width: 10),
                                NumberInputFormField(
                                  onSaved: (newValue) => args.gridHeight = newValue,
                                  initialValue: 3,
                                  min: 1,
                                  max: 10,
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
                                    TheApp.localization(context).playOnThisDeviceWinStrike,
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                SizedBox(width: 10),
                                NumberInputFormField(
                                  onSaved: (newValue) => args.winLenght = newValue,
                                  initialValue: 3,
                                  min: 2,
                                  max: 10,
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
                            PlayerSign(id: ValueKey<int>(0), color: Colors.red, name: "x", guiDelegate: SignGUIDelegates().x),
                            PlayerSign(id: ValueKey<int>(1), color: Colors.blue, name: "o", guiDelegate: SignGUIDelegates().o),
                          ],
                          availableColors: [
                            Colors.red,
                            Colors.purple,
                            Colors.blue,
                            Colors.amber,
                            Colors.green,
                            Colors.indigo,
                            Colors.pink,
                            Colors.orangeAccent[400],
                          ],
                          key: _playerSignsListState,
                        ),
                      ),
                    ),
                  if (expanded) Divider(),
                  if (expanded)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: WhiteButton(
                          child: Text(
                            TheApp.localization(context).playOnThisDevicePlay,
                            style: Theme.of(context).textTheme.button,
                          ),
                          onPressed: _play,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        : null;

    return IconTheme(
      data: IconThemeData(color: Colors.white),
      child: Material(
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
                  AppLocalizations.of(context).playOnThisDeviceTitle,
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
      ),
    );
  }
}

// class SingleDeviceGameSettingsPlayerListItem {
//   ValueKey<int> key; // Maybe I will replace it with the id of the player sign.
//   PlayerSign value;

//   SingleDeviceGameSettingsPlayerListItem(
//     this.key,
//     this.value,
//   );
// }

class SingleDeviceGameSettingsPlayerList extends StatefulWidget {
  /// Set [playerSigns] to null or don't change them to keep old state
  final List<PlayerSign> _playerSigns;
  final List<Color> availableColors;

  const SingleDeviceGameSettingsPlayerList(
    this._playerSigns, {
    Key key,
    @required this.availableColors,
  }) : super(key: key);

  @override
  _SingleDeviceGameSettingsPlayerListState createState() => _SingleDeviceGameSettingsPlayerListState();
}

class _SingleDeviceGameSettingsPlayerListState extends State<SingleDeviceGameSettingsPlayerList> {
  SingleDeviceGameLobbyPLayerListCubit _playerListCubit;

  List<PlayerSign> get playerSigns => List.unmodifiable(_playerListCubit.playersList);

  @override
  void initState() {
    if (widget._playerSigns != null) {
      _applyInitialPlayerSigns();
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
    setState(
      () => _playerListCubit = SingleDeviceGameLobbyPLayerListCubit(
        playersList: widget._playerSigns,
        allColors: widget.availableColors,
        allDelegates: SignGUIDelegates.values,
      ),
    );
  }

  Widget _buildChild(BuildContext context, ReorderableItemState state, int index) {
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
      onDismissed: (direction) => _playerListCubit.removePlayer(index),
      key: _playerListCubit.playerAt(index).id,
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
                  onChanged: (newValue) {
                    _playerListCubit.changePlayerName(newValue, index);
                  },
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Player name",
                  ),
                  cursorColor: Colors.white54,
                  controller: TextEditingController(text: _playerListCubit.playerAt(index).name),
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
            // WhiteButton(
            //   onPressed: () {/* Open sign selector */},
            //   child: Padding(
            //     padding: const EdgeInsets.all(8),
            //     child: _playerListCubit.playersList[index].guiDelegate.guiSmall(context, Colors.white),
            //   ),
            // ),
            SignInput(
              thisIndex: index,
            ),
            SizedBox(width: 16),
            ColorInput(
              thisIndex: index,
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
    return BlocProvider<SingleDeviceGameLobbyPLayerListCubit>(
      create: (context) => _playerListCubit,
      child: ReorderableList(
        decoratePlaceholder: (widget, decorationOpacity) => DecoratedPlaceholder(
          offset: 0,
          widget: DecoratedBox(
            child: widget,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(decorationOpacity * 0.1),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple[100].withRangedHsvValue(0.8).withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 2,
                ),
              ],
              // border: Border.symmetric(
              //   horizontal: BorderSide(
              //     color: Colors.white.withOpacity(decorationOpacity * 0.4),
              //     width: 1.2,
              //   ),
              // ),
            ),
          ),
        ),
        onReorder: (draggedItem, newPosition) {
          _playerListCubit.reorder(draggedItem, newPosition);
          return true;
        },
        child: BlocBuilder<SingleDeviceGameLobbyPLayerListCubit, SingleDeviceGameLobbyPLayerListState>(
            buildWhen: (previous, current) =>
                current is RemovePlayerSingleDeviceGameLobbyPLayerListState ||
                current is AddedPlayerSingleDeviceGameLobbyPLayerListState ||
                current is ReorderedPlayersSingleDeviceGameLobbyPLayerListState,
            builder: (context, state) {
              var full = _playerListCubit.isFullPlayers();

              return Column(
                children: [
                  ..._playerListCubit.playersList
                      .map((e) => AnimatedIn(
                            key: e.id,
                            duration: Duration(milliseconds: 300),
                            builder: (context, child, animation) => FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(0, 0.8),
                                  end: Offset(0, 0),
                                ).animate(animation),
                                child: child,
                              ),
                            ),
                            child: ReorderableItem(
                              key: e.id,
                              childBuilder: (context, state) =>
                                  _buildChild(context, state, _playerListCubit.indexOfId(e.id)), // Optimize index
                            ),
                          ))
                      .toList(),
                  if (_playerListCubit.playersList.length < 2) SizedBox(height: 12),
                  if (_playerListCubit.playersList.length < 2)
                    Text(
                      TheApp.localization(context).playOnThisDeviceNotEnoughPlayers,
                      style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.red[300]),
                    ),
                  SizedBox(height: 12),
                  WhiteButton(
                    onPressed: full ? null : (() => _playerListCubit.constructAndAddPlayer()),
                    borderColor: full ? Theme.of(context).errorColor.withOpacity(0.5) : Colors.white24,
                    bodyColor: full ? Theme.of(context).errorColor.withOpacity(0.1) : Colors.white12,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: full
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_add_disabled_rounded,
                                  color: Theme.of(context).errorColor,
                                ),
                                Text(
                                  TheApp.localization(context).playOnThisDeviceFullPlayers,
                                  style: Theme.of(context).textTheme.button.copyWith(
                                        color: Theme.of(context).errorColor,
                                      ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_rounded),
                                Text(
                                  " " + TheApp.localization(context).playOnThisDeviceAddPLayer,
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
