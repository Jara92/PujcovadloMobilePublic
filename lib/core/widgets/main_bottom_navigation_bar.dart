import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/constants/routes.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';

import '../bloc/application_bloc.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, state) {
        return NavigationBar(
            selectedIndex: state.index,
            onDestinationSelected: (int index) {
              // Go back to root
              Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));

              // Trigger event to change selected tab
              BlocProvider.of<ApplicationBloc>(context)
                  .add(TabChangedApplicationEvent(index));
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.attach_money_outlined),
                label: context.loc.menu_inquiries,
              ),
              NavigationDestination(
                icon: const Icon(Icons.wallet),
                label: context.loc.menu_orders,
              ),
              NavigationDestination(
                icon: const Icon(Icons.search),
                label: context.loc.menu_searching,
              ),
              NavigationDestination(
                icon: const Icon(Icons.message),
                label: context.loc.menu_messages,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person),
                label: context.loc.menu_profile,
              ),
            ]);
      },
    );
  }
}
