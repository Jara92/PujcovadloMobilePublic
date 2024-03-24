part of 'list_bloc.dart';

@immutable
abstract class ListEvent<T> {
  const ListEvent();
}

class InitialEvent<T> extends ListEvent<T> {
  const InitialEvent();
}

class ReloadItemsEvent<T> extends ListEvent<T> {
  const ReloadItemsEvent();
}

class LoadMoreEvent<T> extends ListEvent<T> {
  const LoadMoreEvent();
}
