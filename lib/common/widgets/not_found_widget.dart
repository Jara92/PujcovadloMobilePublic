import 'package:flutter/material.dart';

class NotFoundWidget extends StatelessWidget {
  final String? title;
  final String? message;

  const NotFoundWidget({this.title, this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset("images/not_found.png"),
          Text(title ?? 'Not found'),
          Text(message ?? 'The requested item was not found'),
        ],
      ),
    );
  }
}
