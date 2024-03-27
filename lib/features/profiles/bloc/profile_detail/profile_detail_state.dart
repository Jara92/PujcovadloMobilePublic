part of 'profile_detail_bloc.dart';

@immutable
abstract class ProfileDetailState {
  final bool isLoading;

  const ProfileDetailState({required this.isLoading});
}

class ProfileDetailInitial extends ProfileDetailState {
  const ProfileDetailInitial({super.isLoading = false});
}

class ProfileDetailLoading extends ProfileDetailState {
  const ProfileDetailLoading({super.isLoading = true});
}

class ProfileDetailLoaded extends ProfileDetailState {
  final UserResponse user;

  const ProfileDetailLoaded({required this.user, super.isLoading = false});
}

class ProfileDetailNotFound extends ProfileDetailState {
  const ProfileDetailNotFound({super.isLoading = false});
}

class ProfileDetailFailed extends ProfileDetailState {
  final Exception error;

  const ProfileDetailFailed({required this.error, super.isLoading = false});
}
