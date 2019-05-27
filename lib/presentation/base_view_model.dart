import 'package:flutter/material.dart';

abstract class BaseViewModel<ViewState> extends ChangeNotifier {
  ViewState _state;

  ViewState get state => _state;

  void setState(ViewState viewState, {notify: true}) {
    _state = viewState;
    if (notify) notifyListeners();
  }
}
