import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/custom_colors.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/size_fraction.dart';

class GradientBackground extends StatelessWidget {
  GradientBackground({
    required this.children,
    Color? color,
    super.key,
  }) {
    this.color = color ?? CustomColors.primary;
  }

  late final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: context.heightFraction(sizeFraction: 0.1),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
