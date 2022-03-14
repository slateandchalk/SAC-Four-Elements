import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/typography/typography.dart';

class ShareYourScore extends StatelessWidget {
  const ShareYourScore({Key? key, required this.animation}) : super(key: key);

  final PuzzleDialogEnterAnimation animation;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final titleAndMessageCrossAxisAlignment =
            currentSize == ResponsiveLayoutSize.large ? CrossAxisAlignment.start : CrossAxisAlignment.center;

        final titleTextStyle =
            currentSize == ResponsiveLayoutSize.small ? PuzzleTextStyle.headline4 : PuzzleTextStyle.headline;

        final messageTextStyle =
            currentSize == ResponsiveLayoutSize.small ? PuzzleTextStyle.bodyXSmall : PuzzleTextStyle.bodySmall;

        final textAlign = currentSize == ResponsiveLayoutSize.large ? TextAlign.left : TextAlign.center;

        final messageWidth = currentSize == ResponsiveLayoutSize.large
            ? double.infinity
            : (currentSize == ResponsiveLayoutSize.medium ? 434.0 : 307.0);

        final buttonsMainAxisAlignment =
            currentSize == ResponsiveLayoutSize.large ? MainAxisAlignment.start : MainAxisAlignment.center;

        return Column(
          key: const Key('share_your_score'),
          children: [
            SlideTransition(
              position: animation.shareYourScoreOffset,
              child: Opacity(
                opacity: animation.shareYourScoreOpacity.value,
                child: Column(
                  crossAxisAlignment: titleAndMessageCrossAxisAlignment,
                  children: [
                    Text(
                      context.l10n.successShareYourScoreTitle,
                      key: const Key('share_your_score_title'),
                      textAlign: textAlign,
                      style: titleTextStyle.copyWith(
                        color: PuzzleColors.white,
                      ),
                    ),
                    const Gap(16),
                    SizedBox(
                      width: messageWidth,
                      child: Text(
                        context.l10n.successShareYourScoreMessage,
                        key: const Key('share_your_score_message'),
                        textAlign: textAlign,
                        style: messageTextStyle.copyWith(
                          color: PuzzleColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const ResponsiveGap(
              small: 40,
              medium: 40,
              large: 24,
            ),
            SlideTransition(
              position: animation.socialButtonsOffset,
              child: Opacity(
                opacity: animation.socialButtonsOpacity.value,
                child: Row(
                  mainAxisAlignment: buttonsMainAxisAlignment,
                  children: [
                    PuzzleRedButton(
                      onPressed: () async {
                        Navigator.pop(context, ["Close"]);
                      },
                      child: Text(
                        context.l10n.closeGame,
                        style: PuzzleTextStyle.text,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
