import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/core/bloc/application_bloc.dart';
import 'package:pujcovadlo_client/core/constants/routes.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';
import 'package:pujcovadlo_client/features/item/views/item_list_view.dart';
import 'package:pujcovadlo_client/features/profiles/views/my_profile_view.dart';

void main() {
  registerDependencies();
  debugPaintSizeEnabled = false;

  runApp(BlocProvider(
      create: (context) => ApplicationBloc(),
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        title: "Půjčovadlo",
        theme: ThemeData(
          useMaterial3: true,
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
            unselectedItemColor: Colors.black,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            secondary: Colors.black,
          ),
          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            titleSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            /* displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.normal,
        ),*/
          ),
        ),
        home: const HomePage(),
        routes: {
          //loginRoute: (context) => const LoginView(),
          itemsListRoute: (context) => ItemListView(),
        },
      )));
}

void registerDependencies() {
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
          // Remember status of each tab using Indexed stack
          body: IndexedStack(index: state.index, children: bottomNavScreen),
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
  MyProfileView(),
];
