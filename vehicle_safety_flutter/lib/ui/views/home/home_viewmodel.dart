import 'dart:async';

import 'package:vehicle_safety/models/models.dart';
import 'package:vehicle_safety/services/db_service.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
}
