import 'package:flutter/material.dart';

class WaveBackground extends StatelessWidget {
  WaveBackground({this.child});

  @required
  final Widget child;

  Widget background() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background(),
        child,
      ],
    );
  }
}
