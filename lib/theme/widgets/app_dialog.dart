import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final dialogWidth =
            currentSize == ResponsiveLayoutSize.large ? 740.0 : 700.0;
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2,
              ),
              child: Dialog(
                elevation: 0,
                clipBehavior: Clip.hardEdge,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: SizedBox(
                  child: child,
                  width: dialogWidth,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
