import 'dart:math';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:vpn/toggle.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isActive
                ? [const Color(0xFF749589), const Color(0xFF2c443b), const Color(0xFF132721)]
                : [const Color(0xFF3b3b48), const Color(0xFF2b2c37), const Color(0xFF181921)],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    BurgerMenu(),
                    GoPremiumButton(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                painter: DotsPaint(active: isActive, initial: MediaQuery.of(context).size.width / 7),
              ),
            ),
            Opacity(
              opacity: isActive ? 1 : 0.25,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.6,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/world.png'),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width / 2 - MediaQuery.of(context).size.width / 7),
                child: Toggle(
                  onToggle: setOnOff,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setOnOff(bool state) {
    setState(() {
      isActive = state;
    });
  }
}

class GoPremiumButton extends StatelessWidget {
  const GoPremiumButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.black12,
      ),
      child: Row(
        children: const [
          Icon(
            Icons.security,
            color: Colors.white70,
          ),
          SizedBox(width: 8),
          Text(
            'Go Premium',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white38,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white38,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white38,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DotsPaint extends CustomPainter {
  DotsPaint({@required this.active, @required this.initial});
  final bool active;
  final double initial;
  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..translate(size.width / 2, size.height / 2)
      ..rotate(pi / -2);
    for (var circle = 0; circle <= 20; circle++) {
      final radius = initial + circle * initial / 5;
      final count = 2 * pi * radius ~/ 10;
      for (var dot = 1; dot <= count; dot++) {
        double factor() {
          if (dot / count < 0.5) {
            return dot / count * (dot / count * 4);
          }
          return (1 - dot / count) * ((1 - dot / count) * 4);
        }

        Color getColor() {
          return active
              ? circle == 2 || circle == 4 || circle == 6
                  ? const Color(0xFF0bfd2d).withOpacity(factor())
                  : Colors.grey[900].withOpacity(factor())
              : circle == 4
                  ? Colors.white.withOpacity(factor())
                  : const Color(0xFF121216).withOpacity(factor());
        }

        drawAxis(dot / count, canvas, radius.toDouble(), factor() * 2 + 1.5, Paint()..color = getColor());
      }
    }
  }

  void drawAxis(double dot, Canvas canvas, double radius, double size, Paint paint) {
    assert(dot > 0);
    final firstAxis = getCirclePath(radius);
    final pathMetrics = firstAxis.computeMetrics();
    final pathMetric = pathMetrics.first;
    final extractPath = pathMetric.extractPath(0, pathMetric.length * dot);
    final metric = extractPath.computeMetrics().first;
    final offset = metric.getTangentForOffset(metric.length).position;
    canvas.drawCircle(offset, size, paint);
  }

  Path getCirclePath(double radius) => Path()..addOval(Rect.fromCircle(center: const Offset(0, 0), radius: radius));

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
