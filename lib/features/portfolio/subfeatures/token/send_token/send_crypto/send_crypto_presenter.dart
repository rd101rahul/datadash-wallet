import 'package:datadashwallet/core/core.dart';
import 'package:datadashwallet/features/common/common.dart';
import 'package:datadashwallet/features/common/app_nav_bar/app_nav_bar_presenter.dart';
import 'package:datadashwallet/features/portfolio/subfeatures/token/send_token/choose_crypto/choose_crypto_presenter.dart';
import 'package:datadashwallet/features/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'send_crypto_state.dart';
import 'widgets/transaction_dialog.dart';

class MultiParameters {
  const MultiParameters({
    required this.token,
    this.qrCode,
  });

  final Token token;
  final String? qrCode;
}

final sendTokenPageContainer = PresenterContainerWithParameter<
    SendCryptoPresenter,
    SendCryptoState,
    MultiParameters>((params) => SendCryptoPresenter(params));

class SendCryptoPresenter extends CompletePresenter<SendCryptoState> {
  SendCryptoPresenter(this.params) : super(SendCryptoState());

  final MultiParameters params;

  late final TokenContractUseCase _tokenContractUseCase =
      ref.read(tokenContractUseCaseProvider);
  late final _accountUseCase = ref.read(accountUseCaseProvider);
  late final _chainConfigurationUserCase =
      ref.read(chainConfigurationUseCaseProvider);
  late final accountInfo = ref.read(appNavBarContainer.state);
  late final TextEditingController amountController = TextEditingController();
  late final TextEditingController recipientController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    listen(
      _accountUseCase.walletAddress,
      (value) => notify(() => state.walletAddress = value),
    );

    listen(
      _tokenContractUseCase.online,
      (value) => notify(() => state.online = value),
    );

    listen(_chainConfigurationUserCase.selectedNetwork, (value) {
      if (value != null) {
        notify(() => state.network = value);
      }
    });

    amountController.addListener(_onValidChange);
    recipientController.addListener(_onValidChange);

    recipientController.text = params.qrCode ?? '';

    loadPage();
  }

  void loadPage() async {
    await _tokenContractUseCase.checkConnectionToNetwork();
    _chainConfigurationUserCase.getCurrentNetwork();
  }

  void changeDiscount(int value) {
    amountController.text =
        ((params.token.balance ?? 0) * value / 100).toString();
    notify(() => state.discount = value);
  }

  void _onValidChange() {
    final result =
        amountController.text.isNotEmpty && recipientController.text.isNotEmpty;
    notify(() => state.valid = result);
  }

  void transactionProcess() async {
    final amount = amountController.text;
    final recipient = recipientController.text;
    EstimatedGasFee? estimatedGasFee;

    double sumBalance = params.token.balance! - double.parse(amount);

    if (TransactionProcessType.confirm != state.processType) {
      if (TransactionProcessType.send == state.processType) {
        estimatedGasFee = await _estimatedFee();
        notify(() => state.estimatedGasFee = estimatedGasFee);
      }
      sumBalance -= state.estimatedGasFee?.gasFee ?? 0.0;
    }

    final result = await showTransactionDialog(
      context!,
      title: _getDialogTitle(params.token.name ?? ''),
      amount: amount,
      balance: sumBalance.toString(),
      token: params.token,
      newtork: 'MXC zkEVM',
      from: state.walletAddress!,
      to: recipient,
      processType: state.processType,
      estimatedFee: state.estimatedGasFee?.gasFee.toString(),
      onTap: _nextTransactionStep,
    );

    if (result != null && !result) {
      notify(() => state.processType = TransactionProcessType.confirm);
    }
  }

  String _getDialogTitle(String tokenName) {
    if (TransactionProcessType.confirm == state.processType) {
      return translate('confirm_transaction')!;
    } else {
      return translate('send_x')!.replaceFirst('{0}', tokenName);
    }
  }

  void _nextTransactionStep() async {
    if (TransactionProcessType.confirm == state.processType) {
      notify(() => state.processType = TransactionProcessType.send);
      Future.delayed(const Duration(milliseconds: 300), transactionProcess);
    } else if (TransactionProcessType.send == state.processType) {
      _sendTransaction();
    } else {
      notify(() => state.processType = TransactionProcessType.confirm);
      BottomFlowDialog.of(context!).close();

      ref.read(chooseCryptoPageContainer.actions).loadPage();
      ref.read(walletContainer.actions).initializeWalletPage();
    }
  }

  Future<EstimatedGasFee?> _estimatedFee() async {
    final recipient = recipientController.text;

    loading = true;
    try {
      final gasFee = await _tokenContractUseCase.estimateGesFee(
        from: state.walletAddress!,
        to: recipient,
      );
      loading = false;

      return gasFee;
    } catch (e, s) {
      notify(() => state.processType = TransactionProcessType.confirm);
      addError(e, s);
    } finally {
      loading = false;
    }
  }

  void _sendTransaction() async {
    final amount = amountController.text;
    final recipient = recipientController.text;

    loading = true;
    try {
      final res = await _tokenContractUseCase.sendTransaction(
        privateKey: _accountUseCase.getPravateKey()!,
        to: recipient,
        amount: amount,
      );

      print(res);
      notify(() => state.processType = TransactionProcessType.done);
      transactionProcess();
    } catch (e, s) {
      notify(() => state.processType = TransactionProcessType.confirm);
      addError(e, s);
    } finally {
      loading = false;
    }
  }

  @override
  Future<void> dispose() async {
    super.dispose();

    amountController.removeListener(_onValidChange);
    recipientController.removeListener(_onValidChange);
  }
}
