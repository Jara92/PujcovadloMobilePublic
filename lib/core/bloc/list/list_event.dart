part of 'list_bloc.dart';

@immutable
abstract class ListEvent<T> {
  const ListEvent();
}

class InitialEvent<T> extends ListEvent<T> {
  const InitialEvent();
}

class LoadItemsEvent<T> extends ListEvent<T> {
  const LoadItemsEvent();
}

class LoadMoreEvent<T> extends ListEvent<T> {
  const LoadMoreEvent();
}
