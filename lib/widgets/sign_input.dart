import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_utilities/widget_utils.dart';
import 'package:tic_tac_toe/bloc/single_device_game_lobby_player_list_cubit.dart';
import 'package:tic_tac_toe/models/player_signs.dart';
import 'package:tic_tac_toe/widgets/white_button.dart';
import 'package:my_utilities/color_utils.dart';

// TODO: This and the color input require so much refactoring

typedef void OnColorCangedCallback(Color newValue, ValueKey<int> changedPlayer);

class SignInput extends StatelessWidget {
  final int thisIndex;

  SignInput({this.thisIndex});

  void _openSignPicker(BuildContext context) {
    var cubit = BlocProvider.of<SingleDeviceGameLobbyPLayerListCubit>(context);

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SizedBox(
            // constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2.61803398875),
            height: MediaQuery.of(context).size.height / 2.61803398875,
            child: Card(
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.all(16),
              color: Theme.of(context).dialogBackgroundColor.inverted.withOpacity(0.6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Maybe add border
              child: BlocBuilder<SingleDeviceGameLobbyPLayerListCubit, SingleDeviceGameLobbyPLayerListState>(
                  cubit: cubit,
                  buildWhen: (previous, current) => current is PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState,
                  builder: (context, state) {
                    var thisPlayerSign = cubit.playerAt(thisIndex);
                    return GridView.extent(
                      padding: const EdgeInsets.all(5),
                      maxCrossAxisExtent: 90,
                      children: [
                        ...cubit.allDelegates
                            .map(
                              (e) => SignOption(
                                key: ValueKey(e.id),
                                delegate: e,
                                isOccupied: cubit.isSignGUIDelegateOccupied(e) != -1,
                                isSelected: thisPlayerSign.guiDelegate.id == e.id,
                                onSelected: () => cubit.changeSignGUIDeleagte(
                                  e,
                                  thisIndex,
                                  (occ) async {
                                    return await showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => Center(
                                        child: SizedBox(
                                          height: 300,
                                          child: Card(
                                            margin: const EdgeInsets.all(40),
                                            color: Theme.of(context).dialogBackgroundColor.inverted.withOpacity(0.6),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("This sign is already occupied. Do you want to swap sings to resolve the conflict?",
                                                      style: Theme.of(context).textTheme.headline5),
                                                  Spacer(),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      WhiteButton(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8),
                                                          child: Text(
                                                            "Swap",
                                                            style: Theme.of(context).textTheme.button,
                                                          ),
                                                        ),
                                                        onPressed: () => Navigator.pop(context, true),
                                                      ),
                                                      SizedBox(width: 20),
                                                      WhiteButton(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8),
                                                          child: Text(
                                                            "Cancel",
                                                            style: Theme.of(context).textTheme.button,
                                                          ),
                                                        ),
                                                        onPressed: () => Navigator.pop(context, false),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<SingleDeviceGameLobbyPLayerListCubit>(context);

    return WhiteButton(
      onPressed: () => _openSignPicker(context),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<SingleDeviceGameLobbyPLayerListCubit, SingleDeviceGameLobbyPLayerListState>(
            buildWhen: (previous, current) =>
                current is PlayerSignGUIDelegateChangedSingleDeviceGameLobbyState && current.playerIndex == thisIndex,
            builder: (context, state) {
              return cubit.playerAt(thisIndex).guiDelegate.guiSmall(context, Colors.white);
            }),
      ),
    );
  }
}

class SignOption extends StatefulWidget {
  const SignOption({
    Key key,
    @required this.delegate,
    @required this.isOccupied,
    @required this.isSelected,
    @required this.onSelected,
  }) : super(key: key);

  final SignGUIDelegate delegate;
  final bool isOccupied;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  _SignOptionState createState() => _SignOptionState();
}

class _SignOptionState extends State<SignOption> with TickerProviderStateMixin, StateHelperMixin {
  AnimationController _contr;

  @override
  void initState() {
    _contr = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    // _contr.addListener(rebuild);
    super.initState();
  }

  @override
  void dispose() {
    _contr.dispose();
    // _contr.removeListener(rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _contr.animateTo(widget.isSelected ? 1.0 : 0.0);

    // print(widget.isSelected);
    return Padding(
      padding: EdgeInsets.all(2 - (4 * _contr.value - 2).abs() + 8),
      child: GestureDetector(
        onTap: widget.onSelected, // TODO: On conflict
        child: AnimatedBuilder( // TODO: Change to Animated
            animation: _contr,
            builder: (context, animation) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: _contr.value * 5,
                    color: _contr.value == 0.0 ? Colors.transparent : Colors.white,
                  ),
                ),
                child: Center(
                  child: widget.delegate.guiSmall(context, Colors.white),
                ), // Maybe the representation will be different
              );
            }), // TODO: Add "occupied" indicator
      ),
    );
  }
}
