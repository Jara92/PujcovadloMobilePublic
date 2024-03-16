import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pujcovadlo_client/common/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/common/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/common/widgets/not_found_widget.dart';
import 'package:pujcovadlo_client/common/widgets/operation_error_widget.dart';
import 'package:pujcovadlo_client/item/bloc/item_detail/item_detail_bloc.dart';
import 'package:pujcovadlo_client/item/widgets/item_detail_widget.dart';

import '../../common/custom_colors.dart';

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
          padding: const EdgeInsets.all(10),
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
