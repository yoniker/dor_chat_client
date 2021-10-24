import 'package:flutter/material.dart';

/// This Widget paints a gradient on whatever
/// widget is given to it as it's child.
///
/// You can use this in completion with the [LinearGradient]
/// object present in the [color_constants] file.
//
// It does not in any affect the Settings page UI but I feel
// we should keep it since it will be used in the Match Screen
// on the Long run.
class GradientWidget extends StatelessWidget {
  GradientWidget({
    required this.child,
    required this.gradient,
  });

  final Widget child;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }
}