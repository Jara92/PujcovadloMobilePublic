import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/app.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/core/services/image_service.dart';
import 'package:pujcovadlo_client/core/services/secured_storage.dart';
import 'package:pujcovadlo_client/features/authentication/services/authentication_service.dart';
import 'package:pujcovadlo_client/features/item/services/item_category_service.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';
import 'package:pujcovadlo_client/features/item/services/item_tag_service.dart';
import 'package:pujcovadlo_client/features/loan/services/loan_service.dart';
import 'package:pujcovadlo_client/features/profiles/services/profile_service.dart';
import 'package:pujcovadlo_client/features/review/services/review_service.dart';

Future<void> main() async {
  await loadConfiguration();
  registerDependencies();
  debugPaintSizeEnabled = false;

  // Fix the orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

// load the .env file contents into dotenv.
Future loadConfiguration() {
  return dotenv.load(fileName: ".env");
}

void registerDependencies() {
  GetIt locator = GetIt.instance;
  locator.registerSingleton<Config>(Config());
  locator.registerSingleton<SecuredStorage>(SecuredStorage());
  locator.registerSingleton<HttpService>(HttpService());
  locator.registerSingleton<AuthenticationService>(AuthenticationService());

  locator.registerSingleton<ImageService>(ImageService());
  locator.registerSingleton<ItemService>(ItemService());
  locator.registerSingleton<ItemCategoryService>(ItemCategoryService());
  locator.registerSingleton<ItemTagService>(ItemTagService());
  locator.registerSingleton<LoanService>(LoanService());
  locator.registerSingleton<ReviewService>(ReviewService());
  locator.registerSingleton<ProfileService>(ProfileService());
}
