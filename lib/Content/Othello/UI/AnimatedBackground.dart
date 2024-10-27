import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  AnimatedBackground(
      {required this.screenWidth,
      required this.screenHeight,
      required this.brickEdgeLength})
      : background = Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blueGrey[50]!],
                transform: GradientRotation(math.pi / 4),
              )),
        ),
        worldWidth = math.max(1, screenWidth / screenHeight),
        worldHeight = math.max(1, screenHeight / screenWidth);

  final double brickEdgeLength;
  final double screenWidth;
  final double screenHeight;

  final double worldWidth;
  final double worldHeight;
  final Widget background;

  @override
  _AnimatedBackground createState() => _AnimatedBackground();
}

class _AnimatedBackground extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
//  static const dt = 1 / 720; // 360
  static const dt = 1 / 4000; // 360
  static const double mass = .2;
  static const eps = 2; // 4
  static const double G = 1; // .001
  static const int N = 10; // 32

  // not too crazy
//  static const dt = 1 / 360;
//  static const double mass = .01;
//  static const eps = 4;
//  static const double G = 1;
//  static const int N = 10;

//  static const dt = 1 / 60;
//  static const double mass = .001;
//  static const eps = 2;
//  static const double G = 1;
//  static const double ballSize = 42;
//  static const int N = 8;

  // this is pretty good, still needs work
//  static const double mass = .01;
//  static const eps = .5;
//  static const double G = .01;
//  static const double ballSize = 32;
//  static const int N = 4;

//  static const eps = 1.0;
//  static const double G = .01;
//  static const double ballSize = 32;
//  static const int N = 2;

  // makes binary
//  static const eps = .5;
//  static const double mass = 2000;
//  static const double G = .0000001; // bigger => more energy
//  static const double ballSize = 32;
//  static const int N = 4;

  // slow
//  static const eps = .5;
//  static const double mass = 10;
//  static const double G = .0000001; // bigger => more energy
//  static const double ballSize = 32;
//  static const int N = 5;

//  static const eps = .5;
//  static const double mass = 10;
//  static const double G = .0000001; // bigger => more energy
//  static const double ballSize = 32;
//  static const int N = 10;

//  static const bool periodicForces = false;

  List<Offset> points = [];
  List<Offset> velocities = [];
  List<double> masses = [];

  Widget makeObj(mass, x, y) {
    final double ballSize = widget.brickEdgeLength / 4 * 3;
    return Container(
        transform: Matrix4.translationValues(x, y, 0) *
            Matrix4.diagonal3Values(1 / math.sqrt(2), .5 / math.sqrt(2), 1) *
            Matrix4.rotationZ(math.pi / 4),
        alignment: Alignment.center,
        height: ballSize,
        width: ballSize,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius:
                BorderRadius.all(Radius.circular(widget.brickEdgeLength / 4))));
  }

  void simulate() {
    final double ballSize = widget.brickEdgeLength;
//    double penergy = 0.0;
//    double kenergy = 0.0;
    for (int i = 0; i < N; i++) {
      // calculate force
      for (int j = 0; j < N; j++) {
        if (j == i) continue;
        for (int m = -1; m <= 1; m++) {
          for (int n = -1; n <= 1; n++) {
            Offset dir = Offset(
                points[j].dx - points[i].dx + m * widget.worldWidth,
                points[j].dy - points[i].dy + n * 2 * widget.worldHeight);
            double distance = dir.distance;
            if (distance <
                eps *
                    ballSize /
                    math.sqrt(widget.screenWidth * widget.screenWidth +
                        widget.screenHeight * widget.screenHeight)) {
              distance = eps *
                  ballSize /
                  math.sqrt(widget.screenWidth * widget.screenWidth +
                      widget.screenHeight * widget.screenHeight);
            }
            double force = G * mass * mass / (distance * distance);
//            if (m == 0 && n == 0) {
//              penergy += .25 * force * distance;
//              kenergy += mass * velocities[i].distanceSquared;
//            }
            velocities[i] = velocities[i].translate(
                force / mass * dt * (dir.dx / distance),
                force / mass * dt * (dir.dy / distance));
//        double force = G * masses[i] * masses[j] / (distance * distance);
//        velocities[i] = velocities[i]
//            .translate(force / masses[i] * dt * (dir.dx / distance), force / masses[i] * dt * (dir.dy / distance));
          }
        }
      }
    }
//    print([penergy, kenergy]);
//    print(penergy + kenergy);
    for (int i = 0; i < N; i++) {
      points[i] =
          points[i].translate(velocities[i].dx * dt, velocities[i].dy * dt);

      if (points[i].dy > widget.worldHeight) {
        points[i] = Offset(points[i].dx, points[i].dy - widget.worldHeight * 2);
      }
      if (points[i].dy < -widget.worldHeight) {
        points[i] = Offset(points[i].dx, points[i].dy + widget.worldHeight * 2);
      }
      if (points[i].dx > widget.worldWidth / 2) {
        points[i] = Offset(points[i].dx - widget.worldWidth, points[i].dy);
      }
      if (points[i].dx < -widget.worldWidth / 2) {
        points[i] = Offset(points[i].dx + widget.worldWidth, points[i].dy);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat()
          ..addListener(() {
            setState(simulate);
          });

    math.Random r = math.Random(4141);
    points = <Offset>[];
    velocities = <Offset>[];
//    masses = List<double>();
    for (int i = 0; i < N; i++) {
      points.add(Offset((2 * r.nextDouble() - 1), (2 * r.nextDouble() - 1)));
//      masses.add(massLow + (massHigh - massLow) * r.nextDouble());
      double d1 = r.nextDouble();
      double d2 = r.nextDouble();
      if (d2 > .5)
        velocities.add(Offset(.1 * d1, .1 * d1));
      else
        velocities.add(Offset(.1 * d1, -.1 * d1));
//      objects.add(makeObj(masses[i]));
    }

//    points = [Offset(0, 0), Offset(.4, 0)];
//    velocities = [Offset(0, 0), Offset(0, 1.0)];
//    masses = [50, .01];
//    objects = [makeObj(100), makeObj(30)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> animatedParticles = <Widget>[];
    for (int i = 0; i < N; i++) {
      animatedParticles.add(AnimatedBuilder(
        animation: _controller.view,
        builder: (context, _) => makeObj(
            mass,
            (points[i].dx / widget.worldWidth + .5) * widget.screenWidth,
            (points[i].dy / widget.worldHeight * .5 + .5) *
                widget.screenHeight),
      ));
    }
    return Stack(children: <Widget>[widget.background] + animatedParticles);
  }
}
