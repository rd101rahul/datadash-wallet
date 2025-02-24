import 'package:datadashwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_ui/mxc_ui.dart';
import 'splash_base_presenter.dart';
import 'splash_base_state.dart';

abstract class SplashBasePage extends HookConsumerWidget {
  const SplashBasePage({Key? key}) : super(key: key);

  ProviderBase<SplashBasePresenter> get presenter;

  ProviderBase<SplashBaseState> get state;

  bool get drawAnimated => false;

  Widget separator() {
    return const SizedBox(
      height: 16,
    );
  }

  List<Widget>? setButtons(BuildContext context, WidgetRef ref) => null;

  List<Widget> getButtons(BuildContext context, WidgetRef ref) {
    final children = setButtons(context, ref);

    if (children == null) return [];

    for (var i = children.length; i-- > 0;) {
      if (i > 0) children.insert(i, separator());
    }

    return children;
  }

  Widget buildAppBar(BuildContext context, WidgetRef ref) =>
      const SizedBox(height: 20);

  Widget? buildFooter(BuildContext context) => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget appLogo(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image(
            image: ImagesTheme.of(context).axsWithTitle,
          ),
        ],
      );
    }

    return MxcPage(
      layout: LayoutType.column,
      useSplashBackground: true,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 24),
      presenter: ref.read(presenter),
      appBar: buildAppBar(context, ref),
      footer: buildFooter(context),
      children: [
        const SizedBox(height: 40),
        appLogo(context),
        const SizedBox(height: 48),
        Expanded(
          child: Column(
            children: getButtons(context, ref),
          ),
        )
      ],
    );
  }
}
