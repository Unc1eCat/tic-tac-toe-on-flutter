import 'package:flutter/material.dart';
import 'package:tic_tac_toe/widgets/white_button.dart';

class _State {
  bool up;
  int value;

  _State(this.value, this.up);

  _State increase() {
    return _State(value + 1, true);
  }

  _State decrease() {
    return _State(value - 1, false);
  }
}

class NumberInputFormField extends FormField<_State> {
  NumberInputFormField({
    int initialValue = 0,
    FormFieldSetter<int> onSaved,
    FormFieldValidator<int> validator,
    int min = 0,
    int max = 10,
  }) : super(
          initialValue: _State(initialValue, false),
          validator: (state) => validator(state.value),
          onSaved: (state) => onSaved(state.value),
          builder: (state) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 35, minHeight: 15),
                child: WhiteButton(
                  child: Icon(Icons.chevron_left),
                  onPressed: () {
                    if (state.value.value - 1 < min) return;
                    state.didChange(state.value.decrease());
                  },
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 30,
                height: 25,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 150),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                                  begin: Offset(
                                      0,
                                      state.value.up
                                          ? (state.value.value == (child.key as ValueKey).value ? 0.7 : -0.7)
                                          : (state.value.value == (child.key as ValueKey).value ? -0.7 : 0.7)),
                                  end: Offset(0, 0))
                              .animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      state.value.value.toString(),
                      style: TextStyle(fontSize: 16),
                      key: ValueKey(state.value.value),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 35, minHeight: 15),
                child: WhiteButton(
                  child: Icon(Icons.chevron_right),
                  onPressed: () {
                    if (state.value.value + 1 > max) return;
                    state.didChange(state.value.increase());
                  },
                ),
              ),
            ],
          ),
        );
}
