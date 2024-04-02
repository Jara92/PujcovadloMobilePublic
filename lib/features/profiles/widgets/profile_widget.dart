import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/profiles/bloc/profile_widget/profile_widget_bloc.dart';
import 'package:pujcovadlo_client/features/profiles/responses/user_response.dart';
import 'package:pujcovadlo_client/features/profiles/views/profile_detail_view.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/profile_image.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/profile_rating_widget.dart';

class ProfileWidget extends StatelessWidget {
  final UserResponse user;
  final bool showButtons;

  const ProfileWidget({required this.user, this.showButtons = true, super.key});

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
        if (showButtons)
          BlocProvider(
            create: (context) => ProfileWidgetBloc(),
            child: BlocConsumer<ProfileWidgetBloc, ProfileWidgetState>(
              listener: (context, state) {
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content:
                            Text(context.loc.cant_open_external_application),
                      ),
                    );
                }
              },
              builder: (context, state) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                        if (user.phoneNumber != null)
                          Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: IconButton(
                              onPressed: () =>
                                  BlocProvider.of<ProfileWidgetBloc>(context)
                                      .add(WriteWhatsappEvent(user: user)),
                              icon: Image.asset(
                                "images/icons/whatsapp.png",
                                width: 30,
                              ),
                            ),
                          ),
                        if (user.phoneNumber != null)
                          Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: IconButton(
                              onPressed: () =>
                                  BlocProvider.of<ProfileWidgetBloc>(context)
                                      .add(WriteSmsEvent(user: user)),
                              icon: Icon(Icons.sms,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        if (user.email != null)
                          Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: IconButton(
                              onPressed: () =>
                                  BlocProvider.of<ProfileWidgetBloc>(context)
                                      .add(WriteEmailEvent(user: user)),
                              icon: Icon(Icons.email,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                      ]),
                );
              },
            ),
          ),
      ],
    );
  }
}
