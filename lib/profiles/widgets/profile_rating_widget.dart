import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/authentication/responses/user_response.dart';
import 'package:pujcovadlo_client/common/custom_colors.dart';
import 'package:pujcovadlo_client/common/extensions/buildcontext/loc.dart';

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

    return const Row();
  }
}
