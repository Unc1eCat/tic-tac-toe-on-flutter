import 'package:flutter/cupertino.dart';

class MultiListenable extends ChangeNotifier {
  MultiListenable();

  MultiListenable.from(Iterable<Listenable> sources) {
    sources.forEach((e) => e.addListener(notifyListeners));
  }

  void addSource(Listenable source) {
    source.addListener(notifyListeners);
  }

  void removeSource(Listenable source) {
    source.removeListener(notifyListeners);
  }
}
