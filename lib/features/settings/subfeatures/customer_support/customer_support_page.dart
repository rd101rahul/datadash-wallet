import 'package:datadashwallet/common/common.dart';
import 'package:datadashwallet/features/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'customer_support_presenter.dart';
import 'customer_support_state.dart';

class CustomerSupportPage extends HookConsumerWidget {
  const CustomerSupportPage({Key? key}) : super(key: key);

  @override
  ProviderBase<CustomerSupportPresenter> get presenter =>
      customerSupportContainer.actions;

  @override
  ProviderBase<CustomerSupportState> get state =>
      customerSupportContainer.state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String translate(String text) => FlutterI18n.translate(context, text);

    return MxcPage(
      presenter: ref.watch(presenter),
      crossAxisAlignment: CrossAxisAlignment.start,
      appBar: AppNavBar(
        title: Text(
          FlutterI18n.translate(context, 'costomer_support'),
          style: FontTheme.of(context).body1.primary(),
        ),
      ),
      children: [
        Text(
          FlutterI18n.translate(context, 'export_wallet_logs'),
          style: FontTheme.of(context).body2(),
        ),
        const SizedBox(height: Sizes.spaceNormal),
        Text(
          FlutterI18n.translate(context, 'diagnosing_logs'),
          style: FontTheme.of(context).subtitle1.secondary(),
        ),
        const SizedBox(height: Sizes.spaceNormal),
        MxcButton.secondary(
          key: const ValueKey('exportLogsButton'),
          title: FlutterI18n.translate(context, 'export_logs'),
          size: AxsButtonSize.xl,
          onTap: () => ref.read(presenter).exportedLogs(),
        ),
        if (ref.watch(state.select((v) => v.exportedLogsPath)).isNotEmpty) ...[
          const SizedBox(height: Sizes.spaceNormal),
          Text(
            ref.watch(state).exportedLogsPath,
            style: FontTheme.of(context).subtitle1.secondary().copyWith(
                  color: ColorsTheme.of(context).mainRed,
                ),
          ),
        ],
        const SizedBox(height: Sizes.space4XLarge),
        Text(
          FlutterI18n.translate(context, 'contact_chatgpt_support'),
          style: FontTheme.of(context).body2(),
        ),
        const SizedBox(height: Sizes.spaceNormal),
        MxcButton.secondary(
          key: const ValueKey('jumpToTelegramButton'),
          title: FlutterI18n.translate(context, 'jump_to_telegram'),
          size: AxsButtonSize.xl,
          onTap: () => openUrl('tg://'),
        ),
      ],
    );
  }
}
