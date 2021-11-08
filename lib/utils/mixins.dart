import 'package:flutter/widgets.dart';

/// A container for useful utils
mixin MountedStateMixin<T extends StatefulWidget> on State<T> {
  /// This method allows implementing classes to call setState only when the
  /// widget is mounted.
  ///
  /// Note that calling aschoronous functions is strictly prohibited as this will
  /// break the setState logic and throw an error as well.
  setStateIfMounted(void Function() setter) {
    if (mounted) setState(setter);
  }

  /// This method is similar to [setStateIfMounted] except if the widget is not mounted it wraps
  /// the provide `call` parameter in a [WidgetsBinding.instance.addPostFrameCallback] fucntion which
  /// makes sure the function is called only after the Frames for the current context is completely built which in turn
  /// helps to avoid Errors and Exceptions related to calling `setState` or `notifyListeners` during build calls.
  mountedLoader(void Function() loader) {
    // we call the Function first before calling [setState] so that we don't run asynchoronous operations which is
    // not allowed in setState.
    loader.call();

    if (mounted) {
      setState(() {});
    } else {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  /// Runs the given function/computation if the StatefulWidget is `mounted`.
  ifMounted(void Function() fn) {
    if (mounted) fn.call();
  }
}