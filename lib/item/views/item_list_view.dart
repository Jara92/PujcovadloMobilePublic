import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/common/bloc/application_bloc.dart';
import 'package:pujcovadlo_client/common/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/common/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/item/services/item_service.dart';
import 'package:get_it/get_it.dart';

class ItemListView extends StatelessWidget {
  final ItemService itemService = GetIt.instance.get<ItemService>();

  ItemListView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ApplicationBloc>().add(const TabChangedApplicationEvent(2));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: Column(
            children: [
              TextField(

                decoration: InputDecoration(
                  //border: OutlineInputBorder(),

                  hintText: context.loc.what_are_you_looking_for,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
