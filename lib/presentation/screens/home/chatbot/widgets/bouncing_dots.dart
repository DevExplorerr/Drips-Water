import 'package:drips_water/presentation/screens/home/chatbot/widgets/dot.dart';
import 'package:flutter/material.dart';

class BouncingDots extends StatefulWidget {
  const BouncingDots({super.key});

  @override
  State<BouncingDots> createState() => BouncingDotsState();
}

class BouncingDotsState extends State<BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();
    _animations = List.generate(3, (i) {
      return Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _animations[i].value),
            child: const Dot(),
          ),
        );
      }),
    );
  }
}
