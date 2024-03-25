import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';

class NotFoundError extends StatelessWidget {
  final String? title;
  final String? message;

  const NotFoundError({this.title, this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset("images/icons/not_found.png")),
          Text(title ?? context.loc.not_found,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          Text(
            message ?? context.loc.not_found_message,
            style: Theme.of(context).textTheme.labelMedium!,
          )
        ],
      ),
    );
  }
}
