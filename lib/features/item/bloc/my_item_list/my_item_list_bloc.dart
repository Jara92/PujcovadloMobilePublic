import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';

part 'my_item_list_event.dart';
part 'my_item_list_state.dart';

class MyItemListBloc extends Bloc<ItemListEvent, MyItemListState> {
  final ItemService itemService = GetIt.instance.get<ItemService>();

  MyItemListBloc() : super(const InitialState(isLoading: true, items: [])) {
    on<InitialEvent>((event, emit) async {
      // Init state using empty filter
      add(const SearchTextUpdated(searchText: ''));
    });

    on<SearchTextUpdated>((event, emit) async {
      //print('SearchTextUpdated');

      emit(const LoadingState());

      // todo: search
      var items = await itemService.getMyItems();

      //this.items.addAll(items);

      emit(LoadedState(items: items, isLoading: false));
    });
  }
}
