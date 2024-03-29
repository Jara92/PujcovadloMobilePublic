import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/custom_colors.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/profiles/responses/user_response.dart';

class ProfileRatingWidget extends StatelessWidget {
  final UserResponse user;
  final bool showReviewsCount;

  const ProfileRatingWidget(
      {required this.user, this.showReviewsCount = false, super.key});

  @override
  Widget build(BuildContext context) {
    if (user.profile?.aggregations?.averageRating != null) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.star,
              color: CustomColors.gold,
              size: 20,
            ),
            const SizedBox(width: 3),
            Text(
              // Show average rating with reviews count if showReviewsCount is true
              showReviewsCount
                  ? context.loc.profile_average_rating_with_reviews_count(
                      user.profile!.aggregations!.averageRating!,
                      user.profile!.aggregations!.totalReviews,
                    )
                  : context.loc.decimal(
                      user.profile!.aggregations!.averageRating!,
                    ),
              style: Theme.of(context).textTheme.labelSmall!,
            ),
          ]);
    }
    // No rating yet
    else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.star_border,
              color: Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 3),
            if (showReviewsCount)
              Text(
                // Show average rating with reviews count if showReviewsCount is true
                context.loc.profile_no_rating_yet,

                style: Theme.of(context).textTheme.labelSmall!,
              ),
          ]);
    }
  }
}
