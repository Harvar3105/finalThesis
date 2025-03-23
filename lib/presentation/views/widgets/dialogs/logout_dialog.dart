

import '../../../../app/models/dialog/dialog_model.dart';
import '../../../../configurations/strings.dart';

class LogoutDialog extends AlertDialogModel<bool> {
  const LogoutDialog()
      : super(
    title: Strings.logOut,
    message: Strings.areYouSureThatYouWantToLogOutOfTheApp,
    buttons: const {
      Strings.cancel: false,
      Strings.logOut: true,
    },
  );
}