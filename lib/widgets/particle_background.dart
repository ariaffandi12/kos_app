import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Widget child;
  const ParticleBackground({super.key, required this.child});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  List<Particle> particles = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    for (int i = 0; i < 50; i++) {
      particles.add(Particle(_random));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade50, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(particles, _controller.value),
                size: Size.infinite,
              );
            },
          ),
        ),
        widget.child
      ],
    );
  }
}

class Particle {
  late double x, y, vx, vy, size, alpha;
  
  Particle(Random random) {
    x = random.nextDouble();
    y = random.nextDouble();
    vx = (random.nextDouble() - 0.5) * 0.002;
    vy = (random.nextDouble() - 0.5) * 0.002;
    size = random.nextDouble() * 5 + 2;
    alpha = random.nextDouble() * 0.5;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.deepPurple.withValues(alpha: 0.2);
    for (var p in particles) {
      var newX = p.x + p.vx * progress * 1000;
      var newY = p.y + p.vy * progress * 1000;
      if (newX > 1) newX -= 1;
      if (newX < 0) newX += 1;
      if (newY > 1) newY -= 1;
      if (newY < 0) newY += 1;
      canvas.drawCircle(
        Offset(newX * size.width, newY * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}