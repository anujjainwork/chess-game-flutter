import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SimpleShaderExample extends StatefulWidget {
  const SimpleShaderExample({super.key});

  @override
  State<SimpleShaderExample> createState() => _SimpleShaderExampleState();
}

class _SimpleShaderExampleState extends State<SimpleShaderExample>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final Stopwatch _stopwatch = Stopwatch()..start();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      setState(() {}); // Force rebuild to update the shader time
    })
      ..start();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: SafeArea(
        left: false,
        top: false,
        right: false,
        bottom: false,
        child: FutureBuilder<FragmentShader?>(
          future: _loadShader(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  painter: ShaderPainter(
                    snapshot.data!,
                    resolution:
                        Size(constraints.maxWidth, constraints.maxHeight),
                    time: _stopwatch.elapsedMilliseconds / 1000.0,
                  ),
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                );
              },
            );
          },
        ),
      ),
    );
  }

 Future<FragmentShader?> _loadShader() async {
  try {
    final program = await FragmentProgram.fromAsset('shaders/simple.frag');
    return program.fragmentShader();
  } catch (e) {
    debugPrint("Shader loading failed: $e");
    return null;
  }
}
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final Size resolution;
  final double time;

  ShaderPainter(
    this.shader, {
    required this.resolution,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, resolution.width);
    shader.setFloat(1, resolution.height);
    shader.setFloat(2, time);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}
