import 'dart:ui';

import 'package:datadashwallet/core/core.dart';
import 'package:datadashwallet/features/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_ui/mxc_ui.dart';
import 'package:collection/collection.dart';

void showResetPasscodeDialog(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => ResetPasscode(
      onTap: () {
        resetProviders();
        ref.read(authUseCaseProvider).resetWallet();
        Navigator.of(context).replaceAll(
          route(
            const SplashSetupWalletPage(),
          ),
        );
      },
    ),
  );
}

class ResetPasscode extends StatelessWidget {
  const ResetPasscode({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  Widget content(BuildContext context) {
    return Column(
      children: ['log_out', 'create_new_wallet', 'automatically_log_out']
          .mapIndexed((index, item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}. '),
                    Expanded(
                      child: Text(
                        FlutterI18n.translate(context, item),
                        style: FontTheme.of(context).body1.primary(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 20,
        sigmaY: 20,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorsTheme.of(context).cardBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: InkWell(
                child: const Icon(Icons.close),
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Image(
                image: AssetImage(
                  'assets/images/security/unlock.png',
                ),
                width: 80,
                height: 80,
              ),
            ),
            Text(
              FlutterI18n.translate(context, 'to_reset_passcode'),
              style: FontTheme.of(context)
                  .h6
                  .white()
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            content(context),
            const SizedBox(height: 10),
            MxcButton.secondary(
              key: const ValueKey('logOutButton'),
              title: FlutterI18n.translate(context, 'log_out'),
              size: AxsButtonSize.xl,
              onTap: onTap,
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}
