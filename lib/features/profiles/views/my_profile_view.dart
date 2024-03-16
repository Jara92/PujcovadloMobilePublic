import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/simple_profile_widget.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('My profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SimpleProfileWidget(user: user),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(context.loc.my_profile,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {}, // TODO
                      icon: const Icon(Icons.list_alt),
                      label: Text(context.loc.show_my_profile_button),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top:20),
                child: Text(context.loc.i_borrow_items,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {}, // TODO
                      icon: const Icon(Icons.list),
                      label: Text(context.loc.borrowed_items_button),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {}, // TODO
                      icon: const Icon(Icons.favorite),
                      label: Text(context.loc.favorite_items_button),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top:20),
                child: Text(context.loc.i_lend_items,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {}, // TODO
                      icon: const Icon(Icons.add),
                      label: Text(context.loc.add_new_item_button),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {}, // TODO
                      icon: const Icon(Icons.inventory),
                      label: Text(context.loc.manage_my_items_button),
                    ),
                  ),
                ],
              ),            Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {}, // TODO
                      icon: const Icon(Icons.monetization_on),
                      label: Text(context.loc.inquiries_and_reservations_button),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
