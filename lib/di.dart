import 'package:injector/injector.dart';
import 'package:news_app/provider/home_provider.dart';
import 'package:news_app/repositories/authentication_repository.dart';
import 'package:news_app/repositories/home_repository.dart';

import 'api/api_service.dart';


void setupDependencyInjections() async {
  Injector injector = Injector.appInstance;
  injector.registerSingleton<ApiService>(() => ApiService());
  _homeRepositoryDI(injector);
  _authRepositoryDI(injector);
  _homeProviderDI(injector);
}

void _homeRepositoryDI(Injector injector) {
  injector.registerDependency<HomeRepository>(() {
    return HomeRepository();
  });
}
void _authRepositoryDI(Injector injector) {
  injector.registerDependency<AuthenticationRepository>(() {
    return AuthenticationRepository();
  });
}
void _homeProviderDI(Injector injector) {
  injector.registerDependency<HomeProvider>(() {
    ApiService api = injector.get<ApiService>();
    return HomeProvider(api: api);
  });
}

