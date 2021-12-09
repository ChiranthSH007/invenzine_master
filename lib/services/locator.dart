import 'package:get_it/get_it.dart';
import 'package:invenzine/services/dynamiclinks.dart';
import 'package:invenzine/services/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DynamicLinkService());
}
