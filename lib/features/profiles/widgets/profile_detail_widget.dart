import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/authentication/responses/user_response.dart';
import 'package:pujcovadlo_client/features/profiles/responses/profile_response.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/profile_image.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/profile_rating_widget.dart';

class ProfileDetailWidget extends StatefulWidget {
  final UserResponse user;
  final ProfileResponse profile;

  const ProfileDetailWidget(
      {required this.user, required this.profile, super.key});

  @override
  State<ProfileDetailWidget> createState() => _ProfileDetailWidgetState();
}

class _ProfileDetailWidgetState extends State<ProfileDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileImage(user: widget.user, radius: 50),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.user.firstName} ${widget.user.lastName}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                softWrap: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileRatingWidget(
                user: widget.user,
                showReviewsCount: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (widget.profile.aggregations != null)
            Row(
              children: [
                Flexible(
                    child: Column(
                  children: [
                    Text(
                        widget.profile.aggregations!.countOfPublicItems
                            .toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(context.loc.profile_public_items_count_title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                )),
                Flexible(
                    child: Column(
                  children: [
                    Text(
                        widget.profile.aggregations!.countOfBorrowedItems
                            .toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(context.loc.profile_borrowed_items_count_title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                )),
                Flexible(
                    child: Column(
                  children: [
                    Text(
                        widget.profile.aggregations!.countOfLentItems
                            .toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(context.loc.profile_lended_items_count_title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                )),
              ],
            ),
        ],
      ),
    );
  }
}
