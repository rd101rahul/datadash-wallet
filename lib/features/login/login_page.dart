import 'package:datadashwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'login_page_presentater.dart';

class LoginPage extends ConsumerWidget with SplashScreenMixin {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MxcContextHook(
      bridge: ref.watch(loginPageContainer.actions).bridge,
      child: Material(
        child: appLinearBackground(
          child: Column(
            children: [
              Expanded(
                child: appLogo(context),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 88),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MxcFullRoundedButton(
                        key: const ValueKey('createButton'),
                        title: FlutterI18n.translate(context, 'create_wallet'),
                        onTap: () {},
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      MxcFullRoundedButton(
                        key: const ValueKey('importButton'),
                        title: FlutterI18n.translate(context, 'import_wallet'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
