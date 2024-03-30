import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:pujcovadlo_client/core/bloc/application_bloc.dart';
import 'package:pujcovadlo_client/core/constants/routes.dart';
import 'package:pujcovadlo_client/core/custom_colors.dart';
import 'package:pujcovadlo_client/core/widgets/loading_indicator.dart';
import 'package:pujcovadlo_client/features/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:pujcovadlo_client/features/authentication/services/authentication_service.dart';
import 'package:pujcovadlo_client/features/authentication/views/login_view.dart';
import 'package:pujcovadlo_client/features/item/views/item_list_view.dart';
import 'package:pujcovadlo_client/features/loan/views/borrowed_list_view.dart';
import 'package:pujcovadlo_client/features/loan/views/lent_list_view.dart';
import 'package:pujcovadlo_client/features/profiles/views/my_profile_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(),
      child: KeyboardDismisser(
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          title: "Půjčovadlo",
          theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              //backgroundColor: Colors.red,
              titleTextStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            navigationBarTheme: NavigationBarThemeData(
                indicatorColor: CustomColors.lightPrimary,
                iconTheme: MaterialStateProperty.resolveWith((states) {
                  return const IconThemeData(
                    //color: Colors.black87,
                    color: CustomColors.primary,
                    size: 24,
                  );
                }),
                labelTextStyle: MaterialStateProperty.resolveWith(
                  (states) {
                    return const TextStyle(
                      color: Colors.black87,
                      //fontWeight: FontWeight.bold,
                      fontSize: 12,
                    );
                  },
                )),
            colorScheme: ColorScheme.fromSeed(
              seedColor: CustomColors.primary,
              secondary: Colors.black,
            ),
            // Define the default `TextTheme`. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: const TextTheme(
              titleSmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          home: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            // Listen only for changes in the status
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              // Make sure we are navigating to root page after authentication
              if (state.status == AuthenticationStateEnum.authenticated) {
                Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));
              }
            },
            builder: (context, state) {
              // Display login page if the user is not authenticated
              if (state.status == AuthenticationStateEnum.unauthenticated) {
                return const LoginView();
              }

              // Display home page if the user is authenticated
              if (state.status == AuthenticationStateEnum.authenticated) {
                return BlocProvider(
                    create: (context) => ApplicationBloc(),
                    child: const HomePage());
              }

              // Display loading indicator while the authentication status is being checked
              return const Scaffold(
                body: LoadingIndicator(),
              );
            },
          ),
          routes: {
            itemsListRoute: (context) => ItemListView(),
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplicationBloc, ApplicationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return IndexedStack(index: state.index, children: bottomNavScreen);
      },
    );
  }

  List<Widget> get bottomNavScreen => <Widget>[
        const LentListView(),
        const BorrowedListView(),
        const ItemListView(),
        const Text('Messages'),
        const MyProfileView(),
      ];
}
