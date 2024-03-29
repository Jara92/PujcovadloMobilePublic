import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/not_found_error.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/features/authentication/responses/user_response.dart';
import 'package:pujcovadlo_client/features/profiles/bloc/profile_detail/profile_detail_bloc.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/profile_detail_widget.dart';

class ProfileDetailView extends StatelessWidget {
  final UserResponse? user;
  final String? userId;

  const ProfileDetailView({super.key, this.userId, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: BlocProvider(
            create: (context) => ProfileDetailBloc(userId: userId, user: user)
              ..add(LoadProfileDetail()),
            child: BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
              builder: (context, state) {
                // Display item not found message
                if (state is ProfileDetailNotFound) {
                  return const NotFoundError();
                }

                // Display item detail
                if (state is ProfileDetailLoaded) {
                  return ProfileDetailWidget(
                    user: state.user,
                    profile: state.user.profile!,
                  );
                }

                // Display error message
                if (state is ProfileDetailFailed) {
                  return const OperationError();
                }

                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return const Column();
              },
            ),
          ),
        ),
      ),
    );
  }
}
