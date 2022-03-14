import 'package:flutter/material.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';

Future<T?> showAppDialog<T>(
        {required BuildContext context,
        required Widget child,
        required bool barrierDismissible,
        required Color barrierColor,
        String barrierLabel = ''}) =>
    showGeneralDialog<T>(
      transitionBuilder: (context, animation, secondaryAnimation, widget) {
        final curveAnimation =
            CurvedAnimation(parent: animation, curve: Curves.decelerate);

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1).animate(curveAnimation),
          child: FadeTransition(
            child: widget,
            opacity: curveAnimation,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor.withOpacity(0.8),
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => AppDialog(
        child: child,
      ),
    );
