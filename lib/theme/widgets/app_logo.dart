import 'package:flutter/material.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key, this.height, this.isColored = true}) : super(key: key);

  final double? height;

  final bool isColored;

  @override
  Widget build(BuildContext context) {
    var assetName = 'assets/images/logo_white.png';
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: height != null
          ? Image.asset(
              assetName,
              height: height,
            )
          : ResponsiveLayoutBuilder(
              key: Key(assetName),
              small: (context, child) => Image.asset(
                assetName,
                height: 24,
              ),
              medium: (context, child) => Image.asset(
                assetName,
                height: 29,
              ),
              large: (context, child) => Image.asset(
                assetName,
                height: 32,
              ),
            ),
    );
  }
}
