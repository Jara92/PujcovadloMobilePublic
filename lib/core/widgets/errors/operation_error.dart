import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';

typedef RetryCallback = void Function();

class OperationError extends StatelessWidget {
  final String? title;
  final String? message;
  final RetryCallback? onRetry;

  const OperationError({this.title, this.message, this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset("images/icons/error.png")),
          Text(title ?? context.loc.error,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          Text(
            message ?? context.loc.error_message,
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          if (onRetry != null)
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Icon(Icons.refresh),
              ),
            ),
        ],
      ),
    );
  }
}
