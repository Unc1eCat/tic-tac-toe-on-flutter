import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ItemData {
  ItemData(this.title, this.key);

  final String title;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

enum DraggingMode {
  iOS,
  Android,
}

class _MyHomePageState extends State<MyHomePage> {
  List<ItemData> _items;
  _MyHomePageState() {
    _items = List();
    for (int i = 0; i < 500; ++i) {
      String label = "List item $i";
      if (i == 5) {
        label += ". This item has a long label and will be wrapped.";
      }
      _items.add(ItemData(label, ValueKey(i)));
    }
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.iOS;

  Widget build(BuildContext context) {
    return Scaffold(
        body: ReorderableList(
      onReorder: this._reorderCallback,
      onReorderDone: this._reorderDone,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Item(
            data: _items[index],
            draggingMode: _draggingMode,
          );
        },
        itemCount: _items.length,
      ),
    ));
  }
}

class Item extends StatelessWidget {
  Item({
    this.data,
    this.draggingMode,
  });

  final ItemData data;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    // if (state == ReorderableItemState.dragProxy || state == ReorderableItemState.dragProxyFinished) {
    //   // slightly transparent background white dragging (just like on iOS)
    //   decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    // } else {
    //   bool placeholder = state == ReorderableItemState.placeholder;
    //   decoration = BoxDecoration(
    //       border: Border(
    //           top: isFirst && !placeholder
    //               ? Divider.createBorderSide(context) //
    //               : BorderSide.none,
    //           bottom: isLast && placeholder
    //               ? BorderSide.none //
    //               : Divider.createBorderSide(context)),
    //       color: placeholder ? null : Colors.white);
    // }

    Widget dragHandle = ReorderableListener(
      child: Container(
        padding: EdgeInsets.only(right: 18.0, left: 18.0),
        color: Color(0x08000000),
        child: Center(
          child: Icon(Icons.reorder, color: Color(0xFF888888)),
        ),
      ),
    );

    Widget content = Container(
      child: Opacity(
        // hide content for placeholder
        opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
              child: Text(data.title, style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black)),
            ),
            dragHandle,
          ],
        ),
      ),
    );

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}
