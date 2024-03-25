import 'package:flutter/material.dart';

class ItemFormHeading extends StatelessWidget {
  final String title;
  final String? description;

  const ItemFormHeading({required this.title, this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        ..._buildDescription(context),
      ],
    );
  }

  List<Widget> _buildDescription(BuildContext context) {
    if (description == null) {
      return [];
    }

    return [
      const SizedBox(height: 5),
      Row(
        children: [
          Expanded(
            child: Text(
              description!,
              style: Theme.of(context).textTheme.labelSmall!,
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ];
  }
}
