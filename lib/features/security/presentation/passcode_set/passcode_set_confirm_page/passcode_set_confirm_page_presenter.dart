import 'package:datadashwallet/common/common.dart';
import 'package:datadashwallet/core/core.dart';
import 'package:collection/collection.dart';
import 'package:datadashwallet/features/security/security.dart';

final passcodeSetConfirmPageContainer = PresenterContainerWithParameter<
    PasscodeSetConfirmPagePresenter,
    PasscodeBasePageState,
    List<int>>((expectedNumbers) {
  return PasscodeSetConfirmPagePresenter(expectedNumbers);
});

enum PasscodeConfirmResult { ok, dontMatch }

class PasscodeSetConfirmPagePresenter extends PasscodeBasePagePresenter {
  PasscodeSetConfirmPagePresenter(this.expectedNumbers)
      : super(PasscodeBasePageState());

  late final PasscodeUseCase _passcodeUseCase =
      ref.read(passcodeUseCaseProvider);

  final List<int> expectedNumbers;

  @override
  void onAllNumbersEntered() {
    if (!const DeepCollectionEquality()
        .equals(state.enteredNumbers, expectedNumbers)) {
      navigator?.pop(PasscodeConfirmResult.dontMatch);
      return;
    }

    _passcodeUseCase.setNeedSetPasscode(false);
    _passcodeUseCase.setPasscode(expectedNumbers.join());
    
    
    if (Biometric.available) {
      navigator!.replaceAll(
        route(
          const SetupEnableBiometricPage(),
        ),
      );
    } else {
      // finishPasscodeSetup(navigator!);
    }
  }
}
