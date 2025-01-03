import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoLoading extends StatefulWidget {
  const LogoLoading({super.key});

  @override
  _LogoLoadingAnimationState createState() => _LogoLoadingAnimationState();
}

class _LogoLoadingAnimationState extends State<LogoLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Loops the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Calculate the animated gradient radius
          double animatedRadius = _controller.value;

          return ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return RadialGradient(
                center: Alignment.center,
                radius: animatedRadius, // Gradually increase the radius
                colors: [
                  brightness == Brightness.light ? Colors.black: Colors.grey,
                  Colors.transparent, // Invisible area
                ],
                stops: [0.8, 1.0], // Smooth edge transition
              ).createShader(bounds);
            },
            child: SvgPicture.asset(
              'assets/svgs/logo.svg', // Replace with your SVG file path
              width: 100,
              height: 100,
            ),
          );
        },
      ),
    );
  }
}