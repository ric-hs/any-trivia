import 'package:flutter/widgets.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';

class Validators {
  static String? emailValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.validatorRequiredEmail;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.validatorInvalidEmail;
    }

    return null;
  }
}
