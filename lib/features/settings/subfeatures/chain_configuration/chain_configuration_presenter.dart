import 'package:datadashwallet/core/core.dart';
import 'package:datadashwallet/features/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'chain_configuration_state.dart';

final chainConfigurationContainer =
    PresenterContainer<ChainConfigurationPresenter, ChainConfigurationState>(
        () => ChainConfigurationPresenter());

class ChainConfigurationPresenter
    extends CompletePresenter<ChainConfigurationState> {
  ChainConfigurationPresenter() : super(ChainConfigurationState());

  late final _webviewUseCase = WebviewUseCase();
  late final _authUseCase = ref.read(authUseCaseProvider);
  late final _chainConfigurationUseCase =
      ref.read(chainConfigurationUseCaseProvider);

  final TextEditingController gasLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();

    listen(_chainConfigurationUseCase.networks, (value) {
      if (value.isEmpty) {
        // populates the default list
        final defaultList = Network.fixedNetworks();
        _chainConfigurationUseCase.addItems(defaultList);

        notify(() => state.networks =
            defaultList.where((element) => element.isAdded == true).toList());
      } else {
        notify(() => state.networks =
            value.where((element) => element.isAdded == true).toList());
      }
    });

    listen(_chainConfigurationUseCase.ipfsGateWayList, (newIpfsGateWayList) {
      if (newIpfsGateWayList.isNotEmpty) {
        if (state.ipfsGateWays == null) {
          notify(() => state.ipfsGateWays = newIpfsGateWayList);
        } else {
          state.ipfsGateWays!.clear();
          notify(() => state.ipfsGateWays!.addAll(newIpfsGateWayList));
        }
      }
    });

    listen(_chainConfigurationUseCase.selectedIpfsGateWay, (value) {
      if (value != null) {
        notify(() => state.selectedIpfsGateWay = value);
      }
    });
  }

  void selectIpfsGateWay(String text) async {
    final selectedItemIndex = state.ipfsGateWays!.indexOf(text);
    final selectedIpfsGateWay = state.ipfsGateWays![selectedItemIndex];
    _chainConfigurationUseCase.changeIpfsGateWay(selectedIpfsGateWay);
  }

  void setAsDefault(Network newDefault) {
    _chainConfigurationUseCase.switchDefaultNetwork(newDefault);
    _authUseCase.resetNetwork(newDefault);
    _webviewUseCase.clearCache();

    addMessage(
      translate('x_is_now_active')!.replaceFirst(
          '{0}',
          newDefault.label ??
              '${newDefault.web3RpcHttpUrl.substring(0, 16)}...'),
    );
  }

  void selectNetwork(Network network) {
    _chainConfigurationUseCase.selectNetwork(network);
  }
}
