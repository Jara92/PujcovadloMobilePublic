import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/authentication/responses/user_response.dart';
import 'package:pujcovadlo_client/features/profiles/services/profile_service.dart';

part 'profile_detail_event.dart';
part 'profile_detail_state.dart';

class ProfileDetailBloc extends Bloc<ProfileDetailEvent, ProfileDetailState> {
  final ProfileService _profileService = GetIt.instance.get<ProfileService>();

  final int? userId;
  UserResponse? user;

  ProfileDetailBloc({this.userId, this.user})
      : assert(userId != null || user != null),
        super(const ProfileDetailInitial()) {
    on<LoadProfileDetail>(_onLoadProfileDetail);
  }

  Future<void> _onLoadProfileDetail(
      LoadProfileDetail event, Emitter<ProfileDetailState> emit) async {
    // Emit loading state
    emit(const ProfileDetailLoading());

    try {
      // Load profily by id if profile is not provided directly
      user ??= await _profileService.getUserById(userId!);

      // Check if profile was found
      if (user!.profile == null) {
        throw Exception('Profile not found');
      }

      // Emit loaded state
      emit(ProfileDetailLoaded(user: user!));
    }
    // Emit failed state if an exception was thrown
    on Exception catch (e) {
      emit(ProfileDetailFailed(error: e));
    }
  }
}
