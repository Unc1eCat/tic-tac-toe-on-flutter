import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocBuilderOfStateType<BLOC extends Cubit<BASE>, BASE, STATE extends BASE> extends BlocBuilder<BLOC, BASE> {
  BlocBuilderOfStateType({
    Key key,
    @required BlocWidgetBuilder<BASE> builder,
    BLOC cubit,
    bool Function(BASE, STATE) buildWhen,
  }) : super(
          key: key,
          builder: builder,
          cubit: cubit,
          buildWhen: (old, cur) {
            return cur is STATE && (buildWhen == null ? true : buildWhen(old, cur));
          },
        );
}
