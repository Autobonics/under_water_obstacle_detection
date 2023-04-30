import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vehicle_safety/ui/smart_widgets/online_status.dart';
import 'package:stacked/stacked.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as g;

import 'package:lottie/lottie.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Vehicle tracker'),
              centerTitle: true,
              actions: [IsOnlineWidget()],
            ),
            body: model.data != null
                ? const _HomeBody()
                : Center(child: Text("No data")));
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class _HomeBody extends ViewModelWidget<HomeViewModel> {
  const _HomeBody({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Distance: ${model.data!.distance}"),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (model.data!.distance < 30) Positioned.fill(child: NoFinger())
      ],
    );
  }
}

class NoFinger extends StatelessWidget {
  const NoFinger({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Center(
        child: Card(
          // elevation: 10,
          color: Colors.black.withOpacity(0.5),
          child: Container(
            height: 400,
            width: 250,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.network(
                      'https://assets2.lottiefiles.com/packages/lf20_Tkwjw8.json'),
                  SizedBox(height: 20),
                  Text(
                    'Head or Hand detected outside',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
