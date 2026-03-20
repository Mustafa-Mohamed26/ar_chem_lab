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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<int> _shells;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(300.w, 300.h),
          painter: BohrPainter(
            symbol: widget.element.symbol,
            shells: _shells,
            rotation: _controller.value,
          ),
        );
      },
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

  BohrPainter({
    required this.symbol,
    required this.shells,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 4;
    final shellSpacing = size.width / (shellMaxCount() * 2 + 2);

    // Paint for Shells
    final shellPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Paint for Nucleus
    final nucleusPaint = Paint()
      ..color = AppColors.lightBlue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    final nucleusBorderPaint = Paint()
      ..color = AppColors.lightBlue.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw Nucleus
    canvas.drawCircle(center, baseRadius / 1.5, nucleusPaint);
    canvas.drawCircle(center, baseRadius / 1.5, nucleusBorderPaint);

    // Draw Symbol in Nucleus
    final textPainter = TextPainter(
      text: TextSpan(
        text: symbol,
        style: AppStyles.bold24whiteOrbitron.copyWith(fontSize: 24.sp),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    // Draw Shells and Electrons
    for (int i = 0; i < shells.length; i++) {
      final shellRadius = baseRadius + (i + 1) * shellSpacing;
      final electronCount = shells[i];

      // Draw shell orbit
      canvas.drawCircle(center, shellRadius, shellPaint);

      // Draw electrons
      if (electronCount > 0) {
        final double angleStep = 2 * math.pi / electronCount;
        // Alternate rotation direction for shells
        final double currentRotation = (i % 2 == 0) ? rotation : -rotation;
        
        for (int j = 0; j < electronCount; j++) {
          final double angle = j * angleStep + (currentRotation * 2 * math.pi);
          final electronX = center.dx + shellRadius * math.cos(angle);
          final electronY = center.dy + shellRadius * math.sin(angle);
          
          _drawElectron(canvas, Offset(electronX, electronY));
        }
      }
    }
  }

  void _drawElectron(Canvas canvas, Offset position) {
    final glowPaint = Paint()
      ..color = AppColors.lightBlue.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    final corePaint = Paint()
      ..color = AppColors.lightBlue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, 5, glowPaint);
    canvas.drawCircle(position, 3, corePaint);
  }

  int shellMaxCount() {
      // Logic to determine max spacing needed
      return math.max(shells.length, 1);
  }

  @override
  bool shouldRepaint(BohrPainter oldDelegate) => true;
}
