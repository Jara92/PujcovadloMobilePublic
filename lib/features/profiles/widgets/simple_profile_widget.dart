import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/features/authentication/responses/user_response.dart';

import 'profile_rating_widget.dart';

class SimpleProfileWidget extends StatelessWidget {
  final UserResponse user;

  const SimpleProfileWidget({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          //backgroundImage: NetworkImage(widget.item.owner?.profileImage),
          backgroundImage: AssetImage("images/user_placeholder.png"),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.firstName} ${user.lastName}",
                style: Theme.of(context).textTheme.titleMedium!,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: true,
              ),
              ProfileRatingWidget(
                user: user,
                showReviewsCount: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
