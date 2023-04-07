import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ButtonLoader extends StatelessWidget {
  const ButtonLoader({super.key});

  // final AnimationController _controller = AnimationController(vsync: this);
  @override
  Widget build(BuildContext context) {
    return const SpinKitCircle(
      color: Colors.red,
      size: 45.0,
    );
  }
}
