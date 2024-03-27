import 'package:flutter/material.dart';

class LoanStatusBadge extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;

  const LoanStatusBadge(
      {required this.title, this.backgroundColor, this.textColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color:
            backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor ?? Theme.of(context).colorScheme.primary,
          fontSize: 10.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
