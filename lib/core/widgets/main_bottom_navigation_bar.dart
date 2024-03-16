import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';

import '../bloc/application_bloc.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, state){
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: state.index,
          onTap: (index) {
            BlocProvider.of<ApplicationBloc>(context)
                .add(TabChangedApplicationEvent(index));
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.attach_money_outlined),
              label: context.loc.menu_inquiries,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.wallet),
              label: context.loc.menu_orders,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: context.loc.menu_searching,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.message),
              label: context.loc.menu_messages,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: context.loc.menu_profile,
            ),
          ],
        );
      },
    );
  }
}
