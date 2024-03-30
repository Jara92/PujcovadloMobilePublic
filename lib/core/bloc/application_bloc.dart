import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'application_event.dart';
part 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc() : super(const ApplicationStateInitial()) {
    on<TabChangedApplicationEvent>((event, emit) {
      emit(ApplicationState(index: event.index));
    });

    on<ShowBorrowedItemsEvent>((event, emit) {
      emit(const ApplicationState(index: 1));
    });

    on<ShowLentItemsEvent>((event, emit) {
      emit(const ApplicationState(index: 0));
    });

    on<ReinitializeEvent>((event, emit) {
      emit(const ApplicationStateInitial());
    });
  }
}
