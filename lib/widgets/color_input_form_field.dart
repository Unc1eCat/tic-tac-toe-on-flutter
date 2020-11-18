import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/bloc/single_device_game_lobby_player_list_cubit.dart';
import 'package:tic_tac_toe/models/player_signs.dart';
import 'package:tic_tac_toe/widgets/white_button.dart';
import 'package:my_utilities/color_utils.dart';
import 'animated_in_out.dart';

typedef void OnColorCangedCallback(Color newValue, ValueKey<int> changedPlayer);

// class ColorOptionData {
//   Color color;

//   /// Null if the option is free
//   ValueKey<int> occupierKey;

//   ColorOptionData(this.color, this.occupierKey);
// }

class ColorInput extends StatelessWidget {
  final int thisIndex;

  const ColorInput({
    Key key,
    @required this.thisIndex,
  }) : super(key: key);

  void _openColorPicker(BuildContext context) {
    var cubit = BlocProvider.of<SingleDeviceGameLobbyPLayerListCubit>(context);
    // var thisPlayerSign = cubit.playerAt(thisIndex);
    // var screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical;
    // var screenWidth = MediaQuery.of(context).size.width - MediaQuery.of(context).padding.horizontal;
    // RenderBox rb = context.findRenderObject();
    // var position = rb.localToGlobal(Offset.zero);

    // // position = Offset(
    // //   position.dx,
    // //   position.dy - MediaQuery.of(context).padding.top,
    // // );

    // var isUpper = position.dy > screenHeight / 2;
    // var size = rb.size;
    // var popupAreaSize = Size(
    //   screenWidth,
    //   isUpper ? position.dy - MediaQuery.of(context).padding.top - size.height : screenHeight - position.dy - size.height,
    // );
    // OverlayEntry entry;

    // // print(isUpper);

    // entry = OverlayEntry(
    //   builder: (context) => Stack(
    //     children: [
    //       AnimatedIn(
    //           duration: Duration(milliseconds: 80),
    //           builder: (context, child, anim) {
    //             return Listener(
    //               onPointerDown: (_) => entry.remove(),
    //               child: BackdropFilter(
    //                 filter: ImageFilter.blur(
    //                   sigmaX: 2 * anim.value,
    //                   sigmaY: 2 * anim.value,
    //                 ),
    //                 child: Container(
    //                   height: double.infinity,
    //                   width: double.infinity,
    //                   color: Colors.black.withOpacity(0.4 * anim.value),
    //                 ),
    //               ),
    //             );
    //           }),
    //       Positioned(
    //         top: isUpper ? MediaQuery.of(context).padding.top : position.dy + size.height,
    //         // bottom: ,
    //         left: 0,
    //         child: SizedBox(
    //           height: popupAreaSize.height,
    //           width: popupAreaSize.width,
    //           child: Align(
    //             alignment: Alignment(position.dx / screenWidth, isUpper ? 1 : -1),
    //             child: Card(
    //               margin: EdgeInsets.only(
    //                 right: 16,
    //                 left: 16,
    //                 top: isUpper ? 16 : 4,
    //                 bottom: isUpper ? 4 : 16,
    //               ),
    //               color: Theme.of(context).dialogBackgroundColor.inverted.withOpacity(0.6),
    //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Maybe add border
    //               child: GridView.extent(
    //                 padding: const EdgeInsets.all(8),
    //                 maxCrossAxisExtent: 70,
    //                 children: [
    //                   ...cubit.allColors
    //                       .map((e) => ColorOption(
    //                             color: e,
    //                             isOccupied: cubit.isColorOccupied(e) != -1,
    //                             isSelected: thisPlayerSign.color == e,
    //                             onSelected: () async {
    //                               await cubit.changeColor(
    //                                 e,
    //                                 thisIndex,
    //                                 (occ) async {
    //                                   return await showDialog<bool>(
    //                                     context: context,
    //                                     builder: (context) => Card(
    //                                       color: Theme.of(context).dialogBackgroundColor.inverted.withOpacity(0.6),
    //                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //                                       child: Column(
    //                                         children: [
    //                                           Text("This color is already occupied. Do you want to swap colors to resolve the conflict?",
    //                                               style: Theme.of(context).dialogTheme.contentTextStyle),
    //                                           Row(
    //                                             children: [
    //                                               WhiteButton(
    //                                                 child: Text(
    //                                                   "Swap",
    //                                                   style: Theme.of(context).textTheme.button,
    //                                                 ),
    //                                                 onPressed: () => Navigator.pop(context, true),
    //                                               ),
    //                                               WhiteButton(
    //                                                 child: Text(
    //                                                   "Cancel",
    //                                                   style: Theme.of(context).textTheme.button,
    //                                                 ),
    //                                                 onPressed: () => Navigator.pop(context, false),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                   );
    //                                 },
    //                               );
    //                             },
    //                           ))
    //                       .toList(),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    // Overlay.of(context).insert(entry);
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2.61803398875,
          child: Card(
            margin: EdgeInsets.all(16),
            color: Theme.of(context).dialogBackgroundColor.inverted.withOpacity(0.6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Maybe add border
            child: BlocBuilder<SingleDeviceGameLobbyPLayerListCubit, SingleDeviceGameLobbyPLayerListState>(
                cubit: cubit,
                buildWhen: (previous, current) => current is PlayerColorChangedSingleDeviceGameLobbyState,
                builder: (context, state) {
                  var thisPlayerSign = cubit.playerAt(thisIndex);
                  return GridView.extent(
                    padding: const EdgeInsets.all(8),
                    maxCrossAxisExtent: 70,
                    children: [
                      ...cubit.allColors
                          .map((e) => ColorOption(
                                color: e,
                                isOccupied: cubit.isColorOccupied(e) != -1,
                                isSelected: thisPlayerSign.color == e,
                                onSelected: () async {
                                  if (thisPlayerSign.color == e) return;
                                  await cubit.changeColor(
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
                                                    Text(
                                                        "This color is already occupied. Do you want to swap colors to resolve the conflict?",
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
                                  );
                                },
                              ))
                          .toList(),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  } // TODO: Move the "custom popup menu button in a separate widget"!!!!!

  @Deprecated("Use the analog in the players list cubit")
  bool _isColorOccupied(Color color, List<PlayerSign> players) {
    var ret = false;

    players.forEach((e) => e.color == color);

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 30, minWidth: 60),
      child: BlocBuilder<SingleDeviceGameLobbyPLayerListCubit, SingleDeviceGameLobbyPLayerListState>(
        builder: (context, snapshot) {
          return AnimatedWhiteButton(
            duration: Duration(milliseconds: 160),
            alignment: Alignment.centerRight,
            onPressed: () => _openColorPicker(context),
            bodyColor: BlocProvider.of<SingleDeviceGameLobbyPLayerListCubit>(context).playerAt(thisIndex).color.withOpacity(0.6),
            borderColor: BlocProvider.of<SingleDeviceGameLobbyPLayerListCubit>(context).playerAt(thisIndex).color,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.color_lens),
            ),
          );
        }
      ),
    );
  }
}

class ColorOption extends StatefulWidget {
  final Color color;
  final bool isSelected;
  final bool isOccupied;
  final VoidCallback onSelected;

  const ColorOption({Key key, this.color, this.isSelected, this.isOccupied, this.onSelected}) : super(key: key);

  @override
  _ColorOptionState createState() => _ColorOptionState();
}

class _ColorOptionState extends State<ColorOption> with TickerProviderStateMixin {
  AnimationController
      _selectionContr; // TODO: It's to heavy to make all of the options have the controller. There is idea of a trick in me head to use on controller instead

  @override
  void initState() {
    _selectionContr = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    super.initState();
  }

  @override
  void dispose() {
    _selectionContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _selectionContr.animateTo(widget.isSelected ? 1 : 0);

    return GestureDetector(
      onTap: widget.onSelected,
      child: AnimatedBuilder(
        animation: _selectionContr,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.all(3 - (6 * _selectionContr.value - 3).abs() + 5),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: _selectionContr.value <= 0
                    ? null
                    : Border.all(color: Theme.of(context).colorScheme.onBackground, width: _selectionContr.value * 8),
                borderRadius: BorderRadius.circular(100),
                color: widget.color,
              ),
              child: child,
            ),
          );
        },
        child: widget.isOccupied && !widget.isSelected
            ? Center(
                child: Icon(
                  Icons.not_interested_rounded,
                  size: 44,
                ),
              )
            : null,
      ),
    );
  }
}
