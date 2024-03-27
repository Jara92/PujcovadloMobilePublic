import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/authentication/responses/user_response.dart';
import 'package:pujcovadlo_client/features/profiles/views/profile_detail_view.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/profile_image.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/profile_rating_widget.dart';

class ProfileWidget extends StatelessWidget {
  final UserResponse user;

  const ProfileWidget({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              ProfileImage(
                user: user,
                radius: 20,
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
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
              margin: const EdgeInsets.only(right: 2),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileDetailView(
                      user: user,
                    ),
                  ),
                ),
                icon: const Icon(Icons.supervised_user_circle),
                label: Text(context.loc.show_user_profile_button),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 2),
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message),
                label: Text(context.loc.contact_owner_short_button),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
