import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_utilities/widget_utils.dart';
import 'package:tic_tac_toe/bloc/single_device_game_lobby_player_list_cubit.dart';
import 'package:tic_tac_toe/models/player_signs.dart';
import 'package:tic_tac_toe/screens/bottom_alert_message.dart';
import 'package:tic_tac_toe/widgets/popup_card.dart';
import 'package:tic_tac_toe/widgets/swap_dialog.dart';
import 'package:tic_tac_toe/widgets/white_button.dart';
import 'package:my_utilities/color_utils.dart';

import '../main.dart';

// TODO: This and the color input require so much refactoring

typedef void OnColorCangedCallback(Color newValue, ValueKey<int> changedPlayer);

class SignInput extends StatelessWidget {
  final int thisIndex;

  SignInput({this.thisIndex});

  void _openSignPicker(BuildContext context) {
    var cubit = BlocProvider.of<SingleDeviceGameLobbyPLayerListCubit>(context);
    print(cubit.playersList);

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SizedBox(
            // constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2.61803398875),
            height: MediaQuery.of(context).size.height / 2.61803398875,
            child: PopupCard(
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
                                    return await Navigator.of(context).push<bool>(
                                      BottomAlertMessage(
                                        header: Text(TheApp.localization(context).signPickerSwapDialogTitle),
                                        buttons: [
                                          BottomAlertMessageButton(
                                            child: Text(TheApp.localization(context).pickerSwapSwap),
                                            onPressed: () => Navigator.pop(context, true),
                                          ),
                                          BottomAlertMessageButton(
                                            child: Text(TheApp.localization(context).pickerSwapCancel),
                                            onPressed: () => Navigator.pop(context, false),
                                          )
                                        ],
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
        child: AnimatedBuilder(
          // TODO: Change to Animated
          animation: _contr,
          builder: (context, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: _contr.value * 5,
                  color: _contr.value == 0.0 ? Colors.transparent : Colors.white,
                ),
              ),
              child: Transform.scale(
                scale: 1.0 + _contr.value * 0.3,
                alignment: Alignment.center,
                child: child,
              ), // Maybe the representation will be different
            );
          },
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              if (widget.isOccupied && !widget.isSelected)
                Icon(
                  Icons.not_interested_rounded,
                  size: 50,
                  color: Colors.white38,
                ),
              Center(
                child: widget.delegate.guiSmall(context, Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
