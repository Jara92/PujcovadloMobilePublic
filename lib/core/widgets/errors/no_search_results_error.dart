import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';

class NoSearchResultsError extends StatelessWidget {
  final Widget? icon;
  final String? message;

  const NoSearchResultsError({this.icon, this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon ??
            Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
              size: 100,
            ),
        Text(
          message ?? context.loc.no_search_results,
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }
}
