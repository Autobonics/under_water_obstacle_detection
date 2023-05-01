import 'dart:async';

import 'package:vehicle_safety/models/models.dart';
import 'package:vehicle_safety/services/db_service.dart';
import 'package:stacked/stacked.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
// import '../../setup_snackbar_ui.dart';

class HomeViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');

  // final _snackBarService = locator<SnackbarService>();
  // final _navigationService = locator<NavigationService>();
  final _dbService = locator<DbService>();

  DeviceData? get data => _dbService.node;

  @override
  List<DbService> get reactiveServices => [_dbService];

  void onModelReady() {}

  Future<void> sendCurrentLocationAsSMS() async {
    log.i("Sending SMS");
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Display a message to the user explaining why the app needs access to the device's location and how they can enable it.
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Display a message to the user explaining why the app needs access to the device's location and how they can enable it.
      return;
    }
    // Get the current location
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // Do something with the position data
    } catch (e) {
      // Handle the exception by providing an error message to the user
    }

    // Create the SMS message
    final message =
        'Obstacle location is: ${position != null ? position.latitude : ""}, ${position != null ? position.longitude : ""}, distance: ${data!.distance}, Angle: ${data!.angle}';
    bool _result = await canSendSMS();
    if (_result)
      return sendSMSNow(message: message, recipient: "+918848668847");
    else {
      // Launch the device's SMS messaging app
      final url = 'sms:+919745359950?body=${Uri.encodeComponent(message)}';
      // if (await canLaunch(url)) {
      await launch(url);
      // } else {
      // Unable to launch SMS messaging app
      // }
    }
    // final String recipient =
    //     "+918848668847"; // replace with actual phone number
    // final Uri smsUri = Uri(
    //   scheme: 'sms',
    //   path: recipient,
    //   queryParameters: {
    //     'body': message,
    //   },
    // );
    //
    // if (await canLaunchUrl(smsUri)) {
    //   await launchUrl(smsUri);
    // } else {
    //   throw 'Could not launch $smsUri';
    // }
  }

  void sendSMSNow({required String recipient, required String message}) {
    List<String> recipients = [recipient];
    String body = message;

    try {
      sendSMS(message: body, recipients: recipients, sendDirect: true);
    } catch (error) {
      throw 'Could not send SMS message: $error';
    }
  }
}
