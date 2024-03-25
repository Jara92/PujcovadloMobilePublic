import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/not_found_error.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/features/item/bloc/item_detail/item_detail_bloc.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_detail_widget.dart';

class ItemDetailView extends StatelessWidget {
  final ItemResponse? item;
  final int? itemId;

  const ItemDetailView({super.key, this.itemId, this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: BlocProvider(
            create: (context) => ItemDetailBloc()
              ..add(LoadItemDetail(itemId: itemId, item: item)),
            child: BlocBuilder<ItemDetailBloc, ItemDetailState>(
              builder: (context, state) {
                // Display item not found message
                if (state is ItemDetailNotFound) {
                  return const NotFoundError();
                }

                // Display item detail
                if (state is ItemDetailLoaded) {
                  return ItemDetailWidget(item: state.item);
                }

                // Display error message
                if (state is ItemDetailFailed) {
                  return const OperationError();
                }

                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return const Column();
              },
            ),
          ),
        ),
      ),
    );
  }
}
