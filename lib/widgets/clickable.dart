import 'dart:async';

import 'package:flutter/material.dart';

const Duration _kClickDuration = const Duration(milliseconds: 90);

class Clickable extends StatefulWidget {
  final Widget child;
  final bool enableFeedback;
  final void Function()? onTap;
  final void Function()? onLongPressed;

  Clickable({
    required this.child,
    this.enableFeedback = true,
    this.onTap,
    this.onLongPressed,
  });

  @override
  _ClickableState createState() => _ClickableState();
}

class _ClickableState extends State<Clickable>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _kClickDuration,
      animationBehavior: AnimationBehavior.preserve,
    );

    _animation = Tween<double>(
      begin: 1,
      end: 0.94,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This makes sure that when onTap is null
    // we do not fire the onTap callback to push the
    // button down.
    final bool canTap = widget.onTap != null;

    // This makes sure that when LongPressed is null
    // we do not fire the onLongPressed callback to push the
    // button down.
    final bool canLongPress = widget.onLongPressed != null;

    var current = widget.child;

    if (widget.enableFeedback) {
      current = AnimatedOpacity(
        duration: _kClickDuration,
        opacity: _animation.value,
        child: ScaleTransition(
          scale: _animation,
          child: GestureDetector(
            onTap: !canTap
                ? null
                : () {
              _animationController.forward();
              Timer(_kClickDuration, () {
                _animationController.reverse();
                Timer(_kClickDuration, () {
                  if (widget.onTap != null) {
                    widget.onTap!();
                  }
                });
              });
            },
            // onTapDown: (details) {
            //   _animationController.forward();
            // },
            onLongPressStart: !canLongPress
                ? null
                : (details) {
              _animationController.forward();
            },
            onLongPressEnd: !canLongPress
                ? null
                : (details) {
              _animationController.reverse();

              if (widget.onLongPressed != null) {
                widget.onLongPressed!();
              }
            },
            // onTapUp: (details) {
            //   _animationController.forward();
            // },
            // onLongPress: () {
            //   if (widget.onLongPressed.isNotEmptyObj) {
            //     widget.onLongPressed();
            //   }
            // },
            child: current,
          ),
        ),
      );
    }

    return current;
  }
}