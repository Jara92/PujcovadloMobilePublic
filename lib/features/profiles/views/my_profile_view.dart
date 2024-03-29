import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/bloc/application_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:pujcovadlo_client/features/item/views/item_create_view.dart';
import 'package:pujcovadlo_client/features/item/views/my_item_list.dart';
import 'package:pujcovadlo_client/features/profiles/views/profile_detail_view.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/profile_widget.dart';

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
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  // Display user profile if authenticated
                  if (state is Authenticated) {
                    return ProfileWidget(
                      user: (state).currentUser,
                      showButtons: false,
                    );
                  }

                  // Otherwise nothing (should not happen)
                  return const SizedBox.shrink();
                },
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 20),
                child: Text(context.loc.i_borrow_items,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context
                          .read<ApplicationBloc>()
                          .add(const ShowBorrowedItemsEvent()),
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
                margin: const EdgeInsets.only(bottom: 10, top: 20),
                child: Text(context.loc.i_lend_items,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ItemCreateView()));
                      },
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyItemList(),
                            ));
                      }, // TODO
                      icon: const Icon(Icons.inventory),
                      label: Text(context.loc.manage_my_items_button),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context
                          .read<ApplicationBloc>()
                          .add(const ShowLentItemsEvent()),
                      icon: const Icon(Icons.monetization_on),
                      label:
                          Text(context.loc.inquiries_and_reservations_button),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  // Display user profile if authenticated
                  if (state is Authenticated) {
                    return Row(children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileDetailView(
                                // pass only id so we get the latest data
                                userId: state.currentUser.id,
                              ),
                            ),
                          ), // TODO
                          icon: const Icon(Icons.supervised_user_circle),
                          label: Text(context.loc.show_my_profile_button),
                        ),
                      ),
                    ]);
                  }

                  // Otherwise nothing (should not happen)
                  return const SizedBox.shrink();
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context
                          .read<AuthenticationBloc>()
                          .add(const AuthenticationLogoutRequested()),
                      icon: const Icon(Icons.logout),
                      label: Text(context.loc.logout_button),
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
