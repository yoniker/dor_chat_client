import 'package:flutter/material.dart';

class AppStateInfo extends ChangeNotifier with WidgetsBindingObserver {

  AppLifecycleState _appState=AppLifecycleState.resumed;
  AppLifecycleState get appState => _appState;


  AppStateInfo._privateConstructor(){
    WidgetsBinding.instance!.addObserver(this);
  }

  static final AppStateInfo instance = AppStateInfo._privateConstructor();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appState = state;
    notifyListeners();
  }

}