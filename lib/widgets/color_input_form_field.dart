import 'package:flutter/material.dart';
import 'package:tic_tac_toe/widgets/white_button.dart';

class ColorInputFormField extends FormField<Color> {
  ColorInputFormField({
    FormFieldValidator<Color> validator,
    FormFieldSetter<Color> onSaved,
    Color initialValue,
    LocalKey key,
  }) : super(
          key: key,
          validator: validator,
          onSaved: onSaved,
          initialValue: initialValue,
          builder: (state) => ConstrainedBox(
            constraints: BoxConstraints(minHeight: 30, minWidth: 60),
            child: WhiteButton(
              alignment: Alignment.centerRight,
              onPressed: () {/* Open color picker */},
              bodyColor: state.value.withOpacity(0.6),
              borderColor: state.value,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.color_lens),
              ),
            ),
          ),
        );
}
