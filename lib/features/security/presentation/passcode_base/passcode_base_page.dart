import 'dart:developer';

import 'package:datadashwallet/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_ui/mxc_ui.dart';
import 'package:datadashwallet/common/common.dart';

import 'passcode_base_page_presenter.dart';
import 'passcode_base_page_state.dart';

abstract class PasscodeBasePage extends HookConsumerWidget {
  const PasscodeBasePage({
    Key? key,
  }) : super(key: key);

  String title(BuildContext context, WidgetRef ref);

  String hint(BuildContext context, WidgetRef ref);

  String description(BuildContext context, WidgetRef ref) => '';

  String? dismissedPage() => null;

  bool get showBackButton => false;

  bool get showCloseButton => true;

  ProviderBase<PasscodeBasePagePresenter> get presenter;

  ProviderBase<PasscodeBasePageState> get state;

  Widget numbersRow(BuildContext context, WidgetRef ref) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < ref.watch(state).expectedNumbersLength; i++) ...[
            SvgPicture.asset(
              'assets/svg/security/ic_ring.svg',
              height: 32,
              width: 32,
              colorFilter: filterFor(
                ref.watch(state).enteredNumbers.length > i
                    ? ColorsTheme.of(context).primary60
                    : ColorsTheme.of(context).iconWhite,
              ),
            ),
            if (i != ref.watch(state).expectedNumbersLength - 1)
              const SizedBox(width: 16),
          ],
        ],
      );

  Widget numpad(
    BuildContext context,
    WidgetRef ref, {
    bool showBiometrics = false,
  }) =>
      Column(
        children: [
          Row(
            children: [
              _numpadButton(context, ref, 1),
              _numpadButton(context, ref, 2),
              _numpadButton(context, ref, 3),
            ],
          ),
          Row(
            children: [
              _numpadButton(context, ref, 4),
              _numpadButton(context, ref, 5),
              _numpadButton(context, ref, 6),
            ],
          ),
          Row(
            children: [
              _numpadButton(context, ref, 7),
              _numpadButton(context, ref, 8),
              _numpadButton(context, ref, 9),
            ],
          ),
          Row(
            children: [
              if (showBiometrics)
                Expanded(
                  child: InkWell(
                    onTap: () => ref.read(presenter).requestBiometrics(),
                    child: Container(
                      height: 64,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/svg/ic_biometric.svg',
                        height: 24,
                        width: 24,
                        colorFilter: filterFor(ColorsTheme.of(context).white),
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),
              _numpadButton(context, ref, 0),
              Expanded(
                child: InkWell(
                  onTap: () => ref.read(presenter).onRemoveNumber(),
                  child: Container(
                    height: 64,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/svg/security/ic_delete.svg',
                      height: 19,
                      width: 25,
                      colorFilter: filterFor(ColorsTheme.of(context).white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  Widget buildErrorMessage(BuildContext context, WidgetRef ref) => Text(
        ref.watch(state).errorText ?? '',
        textAlign: TextAlign.center,
        style: FontTheme.of(context).subtitle1.error(),
      );

  Widget _numpadButton(BuildContext context, WidgetRef ref, int number) =>
      Expanded(
        child: InkWell(
          onTap: () => ref.read(presenter).onAddNumber(number),
          child: Container(
            height: 64,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: FontTheme.of(context).h5.white().copyWith(
                    fontSize: 28,
                  ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(state).dismissedPage = dismissedPage();
    useOnAppLifecycleStateChange((
      AppLifecycleState? previous,
      AppLifecycleState current,
    ) {
      ref.read(presenter).onAppLifecycleChanged(previous, current);
    });

    final children = [
      const SizedBox(height: 40),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dismissedPage() != null
                ? Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: IconButton(
                      onPressed: () {
                        appNavigatorKey.currentState!.popUntil((route) {
                          inspect(route);
                          return route.settings.name
                                  ?.contains(dismissedPage()!) ??
                              false;
                        });
                      },
                      icon: const Icon(MxcIcons.close, size: 32),
                    ),
                  )
                : Container(),
            Text(
              title(context, ref),
              style: FontTheme.of(context).h4.white(),
            ),
            const SizedBox(height: 16),
            Text(
              hint(context, ref),
              style: FontTheme.of(context).body1.white(),
            ),
            const SizedBox(height: 64),
            Center(
              child: numbersRow(context, ref),
            ),
          ],
        ),
      ),
      const SizedBox(height: 32),
      buildErrorMessage(context, ref),
      if (description(context, ref).isNotEmpty)
        Text(
          description(context, ref),
          style: FontTheme.of(context).body1.white().copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      const Spacer(),
      numpad(context, ref),
    ];

    return MxcPage(
      layout: LayoutType.column,
      useSplashBackground: true,
      presenter: ref.watch(presenter),
      children: children,
    );
  }
}
