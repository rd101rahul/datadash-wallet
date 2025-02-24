import 'dart:io';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:datadashwallet/core/core.dart';
import 'package:datadashwallet/features/splash/secure_recovery_phrase/secure_recovery_phrase.dart';
import 'package:datadashwallet/features/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:intl/intl.dart';
import 'package:mxc_ui/mxc_ui.dart';
import 'package:path_provider/path_provider.dart';

import 'recovery_phrase_base_state.dart';

abstract class RecoveryPhraseBasePresenter<T extends RecoveryPhraseBaseState>
    extends CompletePresenter<T> {
  RecoveryPhraseBasePresenter(T state) : super(state);

  late final _authUseCase = ref.read(authUseCaseProvider);
  late final _accountUseCase = ref.read(accountUseCaseProvider);
  final AppinioSocialShare _socialShare = AppinioSocialShare();
  final _mnemonicTitle = 'DataDash Wallet Mnemonic Key';
  final _mnemonicFileName =
      '${DateFormat('y-M-d').format(DateTime.now())}-datadash-key.txt';

  void changeAcceptAggreement() =>
      notify(() => state.acceptAgreement = !state.acceptAgreement);

  Future<String> writeToFile(
    dynamic content,
  ) async {
    final tempDir = await getTemporaryDirectory();
    final fullPath = '${tempDir.path}/$_mnemonicFileName';
    File file = await File(fullPath).create();
    await file.writeAsString(content);
    return file.path;
  }

  Future<Map> generateMnemonicFile(bool settingsFlow) async {
    final phrases = settingsFlow
        ? _accountUseCase.getMnemonic()!
        : _authUseCase.generateMnemonic();
    final filePath = await writeToFile(phrases);

    return {
      'filePath': filePath,
      'phrases': phrases,
    };
  }

  void nextProcess(bool settingsFlow, String phrases) {
    if (settingsFlow) {
      BottomFlowDialog.of(context!).close();
      return;
    }

    pushSecurityNoticePage(context!, phrases);
  }

  void shareToTelegram(bool settingsFlow) async {
    final res = await generateMnemonicFile(settingsFlow);

    if (Platform.isAndroid) {
      await _socialShare.shareToTelegram(
        _mnemonicTitle,
        filePath: res['filePath'],
      );
    } else {
      await _socialShare.shareToSystem(
        _mnemonicTitle,
        '',
        filePath: res['filePath'],
      );
    }

    nextProcess(settingsFlow, res['phrases']);
  }

  void shareToWechat(bool settingsFlow) async {
    final res = await generateMnemonicFile(settingsFlow);

    if (Platform.isAndroid) {
      await _socialShare.shareToWechat(
        _mnemonicTitle,
        filePath: res['filePath'],
      );
    } else {
      await _socialShare.shareToSystem(
        _mnemonicTitle,
        '',
        filePath: res['filePath'],
      );
    }

    nextProcess(settingsFlow, res['phrases']);
  }

  void sendEmail(BuildContext ctx, bool settingsFlow) async {
    final res = await generateMnemonicFile(settingsFlow);

    final email = MailOptions(
      body: FlutterI18n.translate(ctx, 'email_secured_body'),
      subject: FlutterI18n.translate(ctx, 'email_secured_subject'),
      attachments: [res['filePath']],
      isHTML: false,
    );

    await FlutterMailer.send(email);

    nextProcess(settingsFlow, res['phrases']);
  }
}
