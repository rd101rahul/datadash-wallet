import 'package:datadashwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'portrait.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({
    super.key,
    required this.account,
    this.isSelected = false,
    this.onSelect,
  });

  final Account account;
  final bool isSelected;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.spaceSmall),
        child: Row(
          children: [
            Portrait(name: account.address),
            const SizedBox(width: Sizes.spaceNormal),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: FontTheme.of(context).body2.secondary(),
                ),
                Text(
                  Formatter.formatWalletAddress(account.address,
                      nCharacters: 10),
                  style: FontTheme.of(context).body1.primary(),
                ),
              ],
            ),
            const Spacer(),
            if (isSelected) ...[const Icon(Icons.check_rounded)]
          ],
        ),
      ),
    );
  }
}
