import 'package:datadashwallet/common/common.dart';
import 'package:datadashwallet/features/dapps/entities/bookmark.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_ui/mxc_ui.dart';
import 'package:web3_provider/web3_provider.dart';

import 'open_dapp_presenter.dart';
import 'open_dapp_state.dart';
import 'widgets/bridge_params.dart';

class OpenAppPage extends HookConsumerWidget {
  const OpenAppPage({Key? key, required this.bookmark}) : super(key: key);

  final Bookmark bookmark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presenter = ref.read(openDAppPageContainer.actions(bookmark));
    final state = ref.watch(openDAppPageContainer.state(bookmark));
    const primaryVelocity = 500;

    return Scaffold(
      backgroundColor: ColorsTheme.of(context).screenBackground,
      body: SafeArea(
        child: PresenterHooks(
          presenter: presenter,
          child: Stack(
            children: [
              GestureDetector(
                onHorizontalDragEnd: (details) async {
                  final webViewController = state.webviewController!;

                  if (details.primaryVelocity! < 0 - primaryVelocity &&
                      (await webViewController.canGoForward())) {
                    webViewController.goForward();
                  }

                  if (details.primaryVelocity! > primaryVelocity &&
                      (await webViewController.canGoBack())) {
                    webViewController.goBack();
                  }

                  if (details.primaryVelocity! > primaryVelocity &&
                      !(await webViewController.canGoBack())) {
                    if (BottomFlowDialog.maybeOf(context) != null) {
                      BottomFlowDialog.of(context).close();
                    }
                  }
                },
                onDoubleTap: () => state.webviewController!.reload(),
                child: InAppWebViewEIP1193(
                  chainId: state.network?.chainId,
                  rpcUrl: state.network?.web3RpcHttpUrl,
                  isDebug: false,
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                    ),
                  ),
                  onProgressChanged: (controller, progress) async {
                    presenter.changeProgress(progress);
                    if (progress == 100) {
                      await controller.evaluateJavascript(
                        source: 'window.ethereum.isMetaMask = true;',
                      );
                    }
                  },
                  signCallback: (params, eip1193, controller) {
                    final id = params['id'];
                    switch (eip1193) {
                      case EIP1193.requestAccounts:
                        if (state.wallletAddress != null) {
                          controller?.setAddress(state.wallletAddress!, id);
                        }
                        break;
                      case EIP1193.signTransaction:
                        Map<String, dynamic> object = params['object'];
                        BridgeParams bridge = BridgeParams.fromJson(object);
                        presenter.signTransaction(
                            bridge: bridge,
                            cancel: () {
                              controller?.cancel(id);
                            },
                            success: (idHash) {
                              controller?.sendResult(idHash, id);
                            });
                        break;
                      case EIP1193.signMessage:
                      case EIP1193.signPersonalMessage:
                        break;
                      case EIP1193.signTypedMessage:
                        break;
                      case EIP1193.addEthereumChain:
                        break;
                      default:
                        break;
                    }
                  },
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(bookmark.url),
                  ),
                  onWebViewCreated: (controller) =>
                      presenter.onWebViewCreated(controller),
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer(),
                    ),
                  },
                ),
              ),
              if (state.progress != 100)
                LinearProgressIndicator(
                  value: state.progress / 100,
                  color: Colors.greenAccent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
