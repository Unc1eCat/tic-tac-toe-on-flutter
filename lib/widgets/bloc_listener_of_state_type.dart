import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocListenerOfStateType<BLOC extends Cubit<BASE>, BASE, STATE extends BASE> extends BlocListener<BLOC, BASE> {BlocListenerOfStateType({
    Key key,
    @required BlocWidgetListener<BASE> listener,
    BLOC cubit,
    bool Function(BASE, STATE) listenWhen,
    child,
  }) : super(
          key: key,
          listener: listener,
          cubit: cubit,
          listenWhen: (old, cur) => cur is STATE && listenWhen == null ? true : listenWhen(old, cur),
          child: child,
        );

  BlocListenerOfStateType.voidListener({
    Key key,
    @required VoidCallback listener,
    BLOC cubit,
    bool Function(BASE, STATE) listenWhen,
    child,
  }) : super(
          key: key,
          listener: (_, __) => listener(),
          cubit: cubit,
          listenWhen: (old, cur) => cur is STATE && (listenWhen == null ? true : listenWhen(old, cur)),
          child: child,
        );
}
