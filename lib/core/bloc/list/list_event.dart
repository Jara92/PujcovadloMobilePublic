part of 'list_bloc.dart';

@immutable
abstract class ListEvent<T> {
  const ListEvent();
}

class InitialEvent<T> extends ListEvent<T> {
  const InitialEvent();
}

class LoaditemsEvent<T> extends ListEvent<T> {
  final String nextPageLink;

  const LoaditemsEvent(this.nextPageLink) : super();
}
