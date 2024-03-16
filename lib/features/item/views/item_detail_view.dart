import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/widgets/not_found_widget.dart';
import 'package:pujcovadlo_client/core/widgets/operation_error_widget.dart';
import 'package:pujcovadlo_client/features/item/bloc/item_detail/item_detail_bloc.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_detail_widget.dart';

class ItemDetailView extends StatefulWidget {
  final int itemId;

  const ItemDetailView({super.key, required this.itemId});

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: BlocProvider(
            create: (context) {
              var bloc = ItemDetailBloc();
              bloc.add(LoadItemDetail(itemId: widget.itemId));
              return bloc;
            },
            child: BlocBuilder<ItemDetailBloc, ItemDetailState>(
              builder: (context, state) {
                // Display item not found message
                if (state is ItemDetailNotFound) {
                  return const NotFoundWidget();
                }
        
                // Display item detail
                if (state is ItemDetailLoaded) {
                  return ItemDetailWidget(item: state.item);
                }
        
                // Display error message
                if (state is ItemDetailFailed) {
                  return const OperationErrorWidget();
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
