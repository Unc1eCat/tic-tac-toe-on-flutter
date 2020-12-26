import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tic_tac_toe/widgets/animated_in_out.dart';
import '../utils/golden_ration_utils.dart' as gr;
import 'package:my_utilities/color_utils.dart';
import 'dart:math' as math;

// enum _PartId { leading, trailing }

// class SettingsTile extends StatelessWidget {
//   final Widget leading;
//   final Widget trailing;

//   SettingsTile({
//     this.leading,
//     this.trailing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomMultiChildLayout(
//       delegate: _SettingsTileLayoutDelegate(),
//       children: [
//         LayoutId(
//           id: _PartId.leading,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 3),
//             child: Card(
//               elevation: 2,
//               child: SizedBox(
//                 width: double.infinity,
//                 child: leading,
//               ),
//             ),
//           ),
//         ),
//         LayoutId(
//           id: _PartId.trailing,
//           child: AnimatedIn(
//             duration: Duration(milliseconds: 250),
//             builder: (context, child, animation) => FadeTransition(
//               opacity: animation,
//               child: ScaleTransition(
//                 scale: animation,
//                 child: child,
//               ),
//             ),
//             child: Card(
//               elevation: 4,
//               color: Theme.of(context).cardColor.blendedWithInversion(0.025),
//               child: trailing,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _SettingsTileLayoutDelegate extends MultiChildLayoutDelegate {
//   @override
//   void performLayout(Size size) {
//     print(size.height);
//     final trailingSize = layoutChild(_PartId.trailing, BoxConstraints(maxWidth: size.width - size.width * gr.invphi * gr.invphi));

//     layoutChild(_PartId.leading, BoxConstraints(maxWidth: size.width - trailingSize.width + 10));

//     positionChild(_PartId.trailing, Offset(size.width - trailingSize.width, 0));
//   }

//   @override
//   bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
//     return false;
//   }
// }

class SettingsTile extends MultiChildRenderObjectWidget {
  final Widget leading;
  final Widget trailing;

  SettingsTile({
    this.leading,
    this.trailing,
  }) : super(
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.all(0),
            ),
            Builder(
              builder: (context) {
                return Card(
                  elevation: 4,
                  color: Theme.of(context).cardColor.blendedWithInversion(0.025),
                  margin: const EdgeInsets.all(0),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: leading,
            ),
            trailing,
          ],
        );

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSettingsTile();
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}

class RenderSettingsTile extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ContainerBoxParentData<RenderBox>>,
        RenderBoxContainerDefaultsMixin<RenderBox, ContainerBoxParentData<RenderBox>> {
  RenderBox get leadingCard => firstChild;
  RenderBox get trailingCard => childAfter(firstChild);
  RenderBox get leading => childBefore(lastChild);
  RenderBox get trailing => lastChild;

  @override
  void setupParentData(covariant RenderObject child) {
    child.parentData = MultiChildLayoutParentData();
  }

  @override
  void performLayout() {
    // Ask the children how big they want to be
    trailing.layout(
      BoxConstraints(
        minWidth: 0,
        minHeight: constraints.minHeight,
        maxWidth: constraints.maxWidth - constraints.maxWidth * gr.invphi * gr.invphi,
        maxHeight: constraints.maxHeight,
      ),
      parentUsesSize: true,
    );
    leading.layout(
      BoxConstraints(
        minWidth: 0,
        minHeight: constraints.minHeight,
        maxWidth: constraints.maxWidth - trailing.size.width,
        maxHeight: constraints.maxHeight,
      ),
      parentUsesSize: true,
    );

    // Get highest of them
    final height = math.max(leading.size.height, trailing.size.height);

    // Force them to be as high as the highest of them and retain their width
    trailing.layout(
      BoxConstraints.tightFor(
        width: trailing.size.width,
        height: height,
      ),
      parentUsesSize: true,
    );
    leading.layout(
      BoxConstraints.tightFor(
        width: leading.size.width,
        height: height,
      ),
      parentUsesSize: true,
    );

    size = Size(constraints.maxWidth, height);

    // Adjust their card backgrounds
    trailingCard.layout(
      BoxConstraints.tightFor(
        width: trailing.size.width,
        height: height,
      ),
    );
    leadingCard.layout(
      BoxConstraints.tightFor(
        width: constraints.maxWidth,
        height: height - 6,
      ),
    );

    // Position everithing
    (trailing.parentData as ContainerBoxParentData).offset = Offset(constraints.maxWidth - trailing.size.width, 0);
    (trailingCard.parentData as ContainerBoxParentData).offset = Offset(constraints.maxWidth - trailing.size.width, 0);
    (leadingCard.parentData as ContainerBoxParentData).offset = Offset(0, 3);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
