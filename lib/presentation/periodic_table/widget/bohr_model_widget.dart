import 'dart:math' as math;
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BohrModelWidget extends StatefulWidget {
  final PeriodicTableResponse element;

  const BohrModelWidget({super.key, required this.element});

  @override
  State<BohrModelWidget> createState() => _BohrModelWidgetState();
}

class _BohrModelWidgetState extends State<BohrModelWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late List<int> _shells;
  Offset _tilt = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _shells = _parseElectronConfiguration(widget.element.electronicConfiguration);
  }

  @override
  void didUpdateWidget(BohrModelWidget oldWidget) {
    if (oldWidget.element.electronicConfiguration !=
        widget.element.electronicConfiguration) {
      _shells =
          _parseElectronConfiguration(widget.element.electronicConfiguration);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _tilt += details.delta * 0.01;
        });
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _pulseController]),
        builder: (context, child) {
          return CustomPaint(
            size: Size(300.w, 300.h),
            painter: BohrPainter(
              symbol: widget.element.symbol,
              shells: _shells,
              rotation: _controller.value,
              pulse: _pulseController.value,
              userTilt: _tilt,
            ),
          );
        },
      ),
    );
  }

  List<int> _parseElectronConfiguration(String config) {
    if (config.isEmpty) return [widget.element.electrons];

    // Standard shell capacities (Max electrons in shell n = 2n^2)
    // But we need to parse the actual configuration string to be accurate
    // Example: [Ar] 3d10 4s2 4p2
    
    Map<int, int> shellMap = {};

    // Handle Noble Gas shorthand
    String expandedConfig = config;
    if (config.startsWith('[')) {
      final gasMatch = RegExp(r'^\[([A-Za-z]+)\]').firstMatch(config);
      if (gasMatch != null) {
        final gas = gasMatch.group(1);
        final gasShells = _getNobleGasShells(gas!);
        for (int i = 0; i < gasShells.length; i++) {
          shellMap[i + 1] = gasShells[i];
        }
        expandedConfig = config.replaceFirst('[$gas]', '').trim();
      }
    }

    // Parse orbitals: e.g. 3d10, 4s2
    final orbitalRegex = RegExp(r'(\d)([spdf])(\d+)');
    final matches = orbitalRegex.allMatches(expandedConfig);

    for (final match in matches) {
      int shell = int.parse(match.group(1)!);
      int electrons = int.parse(match.group(3)!);
      shellMap[shell] = (shellMap[shell] ?? 0) + electrons;
    }

    // If parsing failed or gave 0 electrons, fallback to simple distribution
    if (shellMap.isEmpty) {
      return _distributeElectrons(widget.element.electrons);
    }

    // Convert map to sorted list
    List<int> result = [];
    int maxShell = shellMap.keys.fold(0, math.max);
    for (int i = 1; i <= maxShell; i++) {
        result.add(shellMap[i] ?? 0);
    }
    
    return result;
  }

  List<int> _getNobleGasShells(String symbol) {
    switch (symbol) {
      case 'He': return [2];
      case 'Ne': return [2, 8];
      case 'Ar': return [2, 8, 8];
      case 'Kr': return [2, 8, 18, 8];
      case 'Xe': return [2, 8, 18, 18, 8];
      case 'Rn': return [2, 8, 18, 32, 18, 8];
      case 'Og': return [2, 8, 18, 32, 32, 18, 8];
      default: return [];
    }
  }

  List<int> _distributeElectrons(int total) {
    List<int> shells = [];
    int remaining = total;
    int n = 1;
    while (remaining > 0) {
      int capacity = 2 * n * n;
      int count = math.min(remaining, capacity);
      shells.add(count);
      remaining -= count;
      n++;
    }
    return shells;
  }
}

class BohrPainter extends CustomPainter {
  final String symbol;
  final List<int> shells;
  final double rotation;
  final double pulse;
  final Offset userTilt;
  final List<double> _orbitalTilts;

  BohrPainter({
    required this.symbol,
    required this.shells,
    required this.rotation,
    required this.pulse,
    required this.userTilt,
  }) : _orbitalTilts = List.generate(shells.length, (i) => (i * 0.8) % math.pi);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 5;
    final shellSpacing = size.width / (shells.length * 2.5 + 4);

    // 1. Draw Nucleus Glow (Pulsing)
    final nucleusGlowPaint = Paint()
      ..color = AppColors.lightBlue.withValues(alpha: (0.1 + (pulse * 0.1)))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20 + (pulse * 10));
    canvas.drawCircle(center, baseRadius * (0.8 + pulse * 0.1), nucleusGlowPaint);

    // 2. Draw Nucleus Core
    final nucleusGradient = RadialGradient(
      colors: [
        Colors.white.withValues(alpha: 0.8),
        AppColors.lightBlue,
        AppColors.lightBlue.withValues(alpha: 0.4),
        Colors.transparent,
      ],
      stops: [0.0, 0.2 + (pulse * 0.1), 0.7, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: baseRadius / 1.5));

    final nucleusPaint = Paint()..shader = nucleusGradient;
    canvas.drawCircle(center, baseRadius / 1.5, nucleusPaint);

    // Draw Symbol
    final textPainter = TextPainter(
      text: TextSpan(
        text: symbol,
        style: AppStyles.bold24whiteOrbitron.copyWith(
          fontSize: 22.sp,
          shadows: [
            Shadow(color: Colors.blueAccent, blurRadius: 5 + (pulse * 5)),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    // 3. Draw Orbits and Electrons
    for (int i = 0; i < shells.length; i++) {
      final shellRadius = baseRadius + (i + 1) * shellSpacing;
      final electronCount = shells[i];
      final tilt = _orbitalTilts[i] + userTilt.dx + (userTilt.dy * i * 0.1);

      // Use an ellipse for 3D perspective
      final orbitRect = Rect.fromCenter(
        center: center,
        width: shellRadius * 2,
        height: shellRadius * 1.2,
      );

      // Save canvas state to apply rotation/tilt
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(tilt);
      canvas.translate(-center.dx, -center.dy);

      // Draw orbit path
      final orbitPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawOval(orbitRect, orbitPaint);

      // Draw electrons
      if (electronCount > 0) {
        final double angleStep = 2 * math.pi / electronCount;
        final double speedMultiplier = (shells.length - i) * 1.2;
        final double currentRotation = (i % 2 == 0) ? rotation : -rotation;
        
        for (int j = 0; j < electronCount; j++) {
          final double angle = j * angleStep + (currentRotation * speedMultiplier * 2 * math.pi);
          
          // Draw a small "trail" for the electron
          _drawTrail(canvas, center, orbitRect, angle, currentRotation * speedMultiplier);

          // Position on ellipse
          final electronX = center.dx + (orbitRect.width / 2) * math.cos(angle);
          final electronY = center.dy + (orbitRect.height / 2) * math.sin(angle);
          
          final double depthScale = 0.7 + (math.sin(angle) + 1) * 0.2;
          _drawEnhancedElectron(canvas, Offset(electronX, electronY), depthScale);
        }
      }
      canvas.restore();
    }
  }

  void _drawTrail(Canvas canvas, Offset center, Rect rect, double currentAngle, double direction) {
    const int trailSteps = 5;
    for (int t = 1; t <= trailSteps; t++) {
      final double trailAngle = currentAngle - (direction * t * 0.05);
      final double tx = center.dx + (rect.width / 2) * math.cos(trailAngle);
      final double ty = center.dy + (rect.height / 2) * math.sin(trailAngle);
      
      final trailPaint = Paint()
        ..color = AppColors.lightBlue.withValues(alpha: (0.3 / t))
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(tx, ty), 3.0 / t, trailPaint);
    }
  }

  void _drawEnhancedElectron(Canvas canvas, Offset position, double scale) {
    final double radius = 3.5 * scale;
    
    // Glow
    final glowPaint = Paint()
      ..color = AppColors.lightBlue.withValues(alpha: 0.4)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6 * scale);
    canvas.drawCircle(position, radius * 2.5, glowPaint);

    // Core with highlight
    final electronGradient = RadialGradient(
      center: const Alignment(-0.4, -0.4),
      colors: [
        Colors.white,
        AppColors.lightBlue,
        AppColors.lightBlue.withValues(alpha: 0.9),
      ],
    ).createShader(Rect.fromCircle(center: position, radius: radius));

    final corePaint = Paint()..shader = electronGradient;
    canvas.drawCircle(position, radius, corePaint);
  }

  @override
  bool shouldRepaint(BohrPainter oldDelegate) => true;
}
