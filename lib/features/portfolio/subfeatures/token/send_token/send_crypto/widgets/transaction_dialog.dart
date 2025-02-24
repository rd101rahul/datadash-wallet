import 'package:flutter/material.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'transaction_info.dart';

enum TransactionProcessType { confirm, send, done }

Future<bool?> showTransactionDialog(
  BuildContext context, {
  String? title,
  required String amount,
  required String balance,
  required Token token,
  required String newtork,
  required String from,
  required String to,
  String? estimatedFee,
  TransactionProcessType? processType,
  VoidCallback? onTap,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 44),
      decoration: BoxDecoration(
        color: ColorsTheme.of(context).screenBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MxcAppBarEvenly.title(
            titleText: title ?? '',
            action: Container(
              alignment: Alignment.centerRight,
              child: InkWell(
                child: const Icon(Icons.close),
                onTap: () => Navigator.of(context).pop(false),
              ),
            ),
          ),
          TransactionInfo(
            amount: amount,
            balance: balance,
            token: token,
            newtork: newtork,
            from: from,
            to: to,
            estimatedFee: estimatedFee,
            processType: processType,
            onTap: onTap,
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}
