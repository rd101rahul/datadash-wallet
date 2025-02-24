import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:mxc_ui/mxc_ui.dart';

enum SnackBarType { success, fail }

void showSnackBar({
  required BuildContext context,
  required String content,
  SnackBarType? type = SnackBarType.success,
}) {
  final snackBar = SnackBar(
    elevation: 1000,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    margin: const EdgeInsets.symmetric(horizontal: Sizes.spaceNormal),
    padding: const EdgeInsets.all(Sizes.spaceXSmall),
    backgroundColor: SnackBarType.success == type
        ? ColorsTheme.of(context, listen: false).systemStatusActive
        : ColorsTheme.of(context, listen: false).systemStatusInActive,
    content: Row(
      children: [
        Icon(
          SnackBarType.success == type
              ? Icons.check_circle_rounded
              : Icons.warning_rounded,
          color: ColorsTheme.of(context, listen: false).iconBlack200,
          size: 20,
        ),
        const SizedBox(width: Sizes.space2XSmall),
        Expanded(
          child: Text(
            content,
            style: FontTheme.of(context, listen: false).body1().copyWith(
                color: ColorsTheme.of(context, listen: false).snackbarText),
            textAlign: TextAlign.start,
            softWrap: true,
          ),
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
