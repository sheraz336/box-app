import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    super.key,  // Corrected key usage
    this.blur = 10,
    this.color = Colors.black38,
    this.offset = const Offset(10, 10),
    required Widget child,
  }) : super(child: child);

  final double blur;
  final Color color;
  final Offset offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInnerShadow()
      ..color = color
      ..blur = blur
      ..dx = offset.dx
      ..dy = offset.dy;
  }

  @override
  void updateRenderObject(BuildContext context, _RenderInnerShadow renderObject) {
    renderObject
      ..color = color
      ..blur = blur
      ..dx = offset.dx
      ..dy = offset.dy;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  late double blur;
  late Color color;
  late double dx;
  late double dy;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final Rect rectOuter = offset & size;

    final Canvas canvas = context.canvas;
    canvas.saveLayer(rectOuter, Paint()); // Save initial layer

    // Draw child
    context.paintChild(child!, offset);

    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.dstOut // Correct blending mode for inner shadow
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcOut);

    // Draw shadow effect
    canvas.saveLayer(rectOuter, shadowPaint);
    canvas.translate(-dx, -dy); // Shift shadow inward
    context.paintChild(child!, offset);

    // Restore layers
    canvas.restore();
    canvas.restore();
  }
}
