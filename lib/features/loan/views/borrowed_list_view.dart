import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/loading_next_page_error.dart';
import 'package:pujcovadlo_client/core/widgets/errors/not_found_error.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/loan/bloc/borrowed_list/borrowed_list_bloc.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/views/borrowed_detail_view.dart';
import 'package:pujcovadlo_client/features/loan/widgets/borrowed_list_tile_widget.dart';

class BorrowedListView extends StatefulWidget {
  const BorrowedListView({super.key});

  @override
  State<BorrowedListView> createState() => _BorrowedListViewState();
}

class _BorrowedListViewState extends State<BorrowedListView> {
  late final BorrowedListBloc _bloc;
  late final TextEditingController searchController;
  late final PagingController<String, LoanResponse> _pagingController;

  @override
  void initState() {
    super.initState();

    // Create a new bloc
    _bloc = BorrowedListBloc()..add(const InitialEvent());

    // Init controllers
    searchController = TextEditingController();
    _pagingController = PagingController(firstPageKey: "");

    _pagingController.addPageRequestListener(
        (pageKey) => _bloc.add(LoaditemsEvent(pageKey)));
  }

  @override
  void dispose() {
    searchController.dispose();
    _pagingController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BorrowedListBloc>(
      create: (context) => _bloc,
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SafeArea(
              child: BlocConsumer<BorrowedListBloc, BorrowedListState>(
                listener: (context, state) {
                  // New items loaded?
                  if (state.status == ListStateEnum.loaded) {
                    // Append items to the list as the last page of the list
                    if (state.isLastPage) {
                      _pagingController.appendLastPage(state.items);
                    }
                    // Append items to the list as a new page
                    else {
                      _pagingController.appendPage(
                          state.items, state.nextPageLink);
                    }
                  }

                  // Error occurred?
                  if (state.status == ListStateEnum.error) {
                    _pagingController.error = state.error;
                  }

                  // Initial state? Should refresh the list
                  if (state.status == ListStateEnum.initial) {
                    _pagingController.refresh();
                  }
                },
                builder: (context, state) {
                  Widget mainContent = const SizedBox.shrink();

                  mainContent = _buildItemList(context, state);

                  return Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: SearchBar(
                            controller: searchController,
                            leading: const Icon(Icons.search),
                            trailing: <Widget>[
                              Tooltip(
                                message: context.loc.clear_search,
                                child: IconButton(
                                  isSelected: false,
                                  onPressed: () {
                                    // clear value
                                    searchController.clear();

                                    // trigger on changed
                                    BlocProvider.of<BorrowedListBloc>(context)
                                        .add(const SearchTextUpdated(
                                            searchText: ""));
                                  },
                                  icon: const Icon(Icons.clear),
                                ),
                              )
                            ],
                            padding: const MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 16.0)),
                            onChanged: (value) =>
                                BlocProvider.of<BorrowedListBloc>(context)
                                    .add(SearchTextUpdated(searchText: value)),
                            hintText: context.loc.searching_in_borrowed_items,
                          )),
                      mainContent,
                    ],
                  );
                },
              ),
            )),
        bottomNavigationBar: const MainBottomNavigationBar(),
      ),
    );
  }

  Widget _buildItemList(BuildContext context, BorrowedListState state) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<String, LoanResponse>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<LoanResponse>(
            firstPageErrorIndicatorBuilder: (_) => OperationError(
              onRetry: _pagingController.refresh,
            ),
            noItemsFoundIndicatorBuilder: (_) => NotFoundError(
              title: context.loc.no_items_found,
              message: context.loc.no_items_found_message,
            ),
            newPageErrorIndicatorBuilder: (_) => LoadingNextPageErrorWidget(
              onRetry: _pagingController.retryLastFailedRequest,
            ),
            itemBuilder: (context, loan, index) => GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BorrowedLoanDetailView(loan: loan))),
              child: BorrowedListTileWidget(loan: loan),
            ),
          ),
        ),
      ),
    );
  }
}
