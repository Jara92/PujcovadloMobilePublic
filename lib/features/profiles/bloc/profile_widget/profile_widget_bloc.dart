import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/profiles/exceptions/cannot_open_email_client.dart';
import 'package:pujcovadlo_client/features/profiles/exceptions/cannot_open_sms_client.dart';
import 'package:pujcovadlo_client/features/profiles/exceptions/cannot_open_whats_app.dart';
import 'package:pujcovadlo_client/features/profiles/responses/user_response.dart';
import 'package:url_launcher/url_launcher.dart';

part 'profile_widget_event.dart';
part 'profile_widget_state.dart';

class ProfileWidgetBloc extends Bloc<ProfileWidgetEvent, ProfileWidgetState> {
  ProfileWidgetBloc() : super(const ProfileWidgetInitial()) {
    on<WriteSmsEvent>(_onWriteSmsEvent);
    on<WriteWhatsappEvent>(_onWriteWhatsappEvent);
    on<WriteEmailEvent>(_onWriteEmailEvent);
  }

  Future<void> _onWriteSmsEvent(
      WriteSmsEvent event, Emitter<ProfileWidgetState> emit) async {
    if (event.user.phoneNumber == null) {
      return;
    }

    final url = Uri.parse("sms:${event.user.phoneNumber}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      emit(ErrorState(
        error: CannotOpenSmsClientException(),
      ));
    }
  }

  Future<void> _onWriteWhatsappEvent(
      WriteWhatsappEvent event, Emitter<ProfileWidgetState> emit) async {
    if (event.user.phoneNumber == null) {
      return;
    }

    // Remove all whitespaces and + from the phone number
    var formatedNumber =
        event.user.phoneNumber!.replaceAll(" ", "").replaceAll("+", "");

    // Prepend the phone number with czech country code by default
    if (!formatedNumber.startsWith("420")) {
      formatedNumber = "420$formatedNumber";
    }

    final url =
        Uri.parse("https://api.whatsapp.com/send?phone=$formatedNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      emit(ErrorState(
        error: CannotOpenWhatsAppException(),
      ));
    }
  }

  Future<void> _onWriteEmailEvent(
      WriteEmailEvent event, Emitter<ProfileWidgetState> emit) async {
    if (event.user.email == null) {
      return;
    }

    final url = Uri.parse("mailto:${event.user.email}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      emit(ErrorState(
        error: CannotOpenEmailClientException(),
      ));
    }
  }
}
