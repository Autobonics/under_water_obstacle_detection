import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vehicle_safety/ui/smart_widgets/online_status.dart';
import 'package:stacked/stacked.dart';
import 'dart:math' as math;
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Angle: ${model.data!.angle}°"),
                  ),
                ),
                SizedBox(height: 150),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: RadarWidget(
                      angle: model.data!.angle.toDouble(),
                      distance: model.data!.distance),
                )
              ],
            ),
          ),
        ),
        if (model.data!.distance < 30)
          Positioned.fill(
            child: NoFinger(
              angle: model.data!.angle,
              distance: (model.data!.distance.round()),
              onTap: model.sendCurrentLocationAsSMS,
            ),
          )
      ],
    );
  }
}

class NoFinger extends StatelessWidget {
  final int angle;
  final int distance;
  final VoidCallback onTap;
  const NoFinger(
      {super.key,
      required this.angle,
      required this.distance,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Center(
        child: InkWell(
          onTap: onTap,
          child: Card(
            // elevation: 10,
            color: Colors.black.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                        'Obstacle detected at $distance cm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Angle $angle°',
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
        ),
      ),
    );
  }
}

class RadarWidget extends StatefulWidget {
  final double angle;
  final double distance;

  RadarWidget({
    required this.angle,
    required this.distance,
  });

  @override
  _RadarWidgetState createState() => _RadarWidgetState();
}

class _RadarWidgetState extends State<RadarWidget> {
  Map<double, double> _positions = {};

  @override
  void initState() {
    super.initState();
    _positions[widget.angle] = widget.distance;
  }

  @override
  void didUpdateWidget(RadarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.angle != widget.angle) {
      _positions[widget.angle] = widget.distance;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: CustomPaint(
        painter: _RadarPainter(
          positions: _positions,
          currentAngle: widget.angle,
          currentDistance: widget.distance,
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Map<double, double> positions;
  final double currentAngle;
  final double currentDistance;

  _RadarPainter({
    required this.positions,
    required this.currentAngle,
    required this.currentDistance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      paint,
    );

    for (final angle in positions.keys) {
      final distance = positions[angle]!;
      final x = centerX +
          (distance / 200) * radius * math.sin(math.pi / 180 * (angle - 90));
      final y = centerY +
          (distance / 200) * radius * math.cos(math.pi / 180 * (angle - 90));
      final linePaint = Paint()
        ..color = currentAngle == angle ? Colors.green : Colors.red
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(x, y),
        linePaint,
      );
    }

    final currentX = centerX +
        (currentDistance / 200) *
            radius *
            math.sin(math.pi / 180 * (currentAngle - 90));
    final currentY = centerY +
        (currentDistance / 200) *
            radius *
            math.cos(math.pi / 180 * (currentAngle - 90));
    final currentPoint = Offset(currentX, currentY);

    final currentPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(centerX, centerY),
      currentPoint,
      currentPaint,
    );
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) {
    return oldDelegate.positions != positions ||
        oldDelegate.currentAngle != currentAngle ||
        oldDelegate.currentDistance != currentDistance;
  }
}
