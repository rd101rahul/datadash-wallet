import 'package:equatable/equatable.dart';
import 'package:mxc_logic/mxc_logic.dart';

import 'widgets/transaction_dialog.dart';

class SendNftState with EquatableMixin {
  bool online = false;
  Token? token;
  int discount = 0;
  bool valid = false;
  TransactionProcessType processType = TransactionProcessType.confirm;
  String? walletAddress;
  EstimatedGasFee? estimatedGasFee;

  @override
  List<Object?> get props => [
        token,
        online,
        discount,
        valid,
        processType,
        walletAddress,
        estimatedGasFee,
      ];
}
