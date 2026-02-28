import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration durationPerLine;
  final VoidCallback? onChanged;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.durationPerLine = const Duration(milliseconds: 300),
    this.onChanged,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  final List<String> _lines = [];
  int _currentLineIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _timer?.cancel();
    _lines.clear();
    final allLines = widget.text.split('\n');
    _currentLineIndex = 0;

    _timer = Timer.periodic(widget.durationPerLine, (timer) {
      if (_currentLineIndex < allLines.length) {
        setState(() {
          _lines.add(allLines[_currentLineIndex]);
          _currentLineIndex++;
        });
        widget.onChanged?.call();
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_lines.join('\n'), style: widget.style);
  }
}
