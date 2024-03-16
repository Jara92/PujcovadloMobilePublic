import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'application_event.dart';
part 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc() : super(const ApplicationStateInitial()) {
    on<TabChangedApplicationEvent>((event, emit) {
      emit(ApplicationStateInitial(index: event.index));
    });
  }
}
