import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double? minHeight;

  const LoadingIndicator({this.minHeight, super.key});

  @override
  Widget build(BuildContext context) {
    if (minHeight != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight!,
        ),
        child: _buildIndicator(context),
      );
    }

    return _buildIndicator(context);
  }

  Widget _buildIndicator(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
