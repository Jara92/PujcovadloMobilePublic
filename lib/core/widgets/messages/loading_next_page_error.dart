import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';

typedef RetryCallback = void Function();

class LoadingNextPageErrorWidget extends StatelessWidget {
  final String? message;
  final RetryCallback onRetry;

  const LoadingNextPageErrorWidget(
      {required this.onRetry, this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              message ?? context.loc.error_loading_new_page,
              textAlign: TextAlign.center,
            )),
          ],
        ),
        IconButton(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
