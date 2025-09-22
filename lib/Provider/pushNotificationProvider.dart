import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Repository/NotificationRepository.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';

class PushNotificationProvider extends ChangeNotifier {
  void registerToken(String? token, BuildContext context) async {
    print("registerToken------>${token}");
    if (token == null) return;

    final settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);

    if (settingsProvider.fcmId?.trim() != token) {
      var parameter = {
        FCMID: token,
        'device_type': Platform.isAndroid ? 'android' : 'ios'
      };

      final response =
          await NotificationRepository.updateFcmID(parameter: parameter);
      if (response['error'] == false) {
        await settingsProvider.setFcmId(token);
      }
    }
  }
}
