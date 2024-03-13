import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/common/bloc/application_bloc.dart';
import 'package:pujcovadlo_client/constants/routes.dart';
import 'package:pujcovadlo_client/item/services/item_service.dart';
import 'package:pujcovadlo_client/item/views/item_list_view.dart';
import 'authentication/views/login_view.dart';
import 'dart:developer' as devtools show log;
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pujcovadlo_client/common/extensions/buildcontext/loc.dart';

import 'common/widgets/main_bottom_navigation_bar.dart';

void main() {
  registerDependencies();

  runApp(MaterialApp(
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    title: "Půjčovadlo",
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.red,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.red,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
      ),
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.red,
      ),
      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
    home: BlocProvider<ApplicationBloc>(
      create: (context) => ApplicationBloc(),
      child: const HomePage(),
    ),
   /* home: BlocConsumer<ApplicationEvent, ApplicationState>(
      listener: (context, state) {},
      builder: (context, state) {
        if(state is SearchApplicationEvent){
          return const LoginView();
        }
      },
    )*/
    routes: {
      loginRoute: (context) => const LoginView(),
      itemsListRoute: (context) => ItemListView(),
    },
  ));
}

void registerDependencies(){
  GetIt locator = GetIt.instance;
  locator.registerSingleton<ItemService>(ItemService());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ApplicationBloc>();
    return BlocConsumer<ApplicationBloc, ApplicationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: bottomNavScreen.elementAt(state.index),
        );
      },
    );
  }
}

List<Widget> bottomNavScreen = <Widget>[
  Text('Inquiries'),
  Scaffold(
    body: Center(
      child: Text('Orders'),
    ),
    bottomNavigationBar: MainBottomNavigationBar(),
  ),
  ItemListView(),
  Text('Messages'),
  Text('Profile'),
];