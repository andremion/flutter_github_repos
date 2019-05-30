import 'package:flutter_github_repos/data/remote/repos_remote.dart';
import 'package:flutter_github_repos/data/repository/repos_repository.dart';
import 'package:flutter_github_repos/presentation/home/home_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt();

setup() {
  serviceLocator.registerSingleton(ReposRemoteDataSource());
  serviceLocator.registerSingleton(ReposRepository(serviceLocator()));
  serviceLocator.registerLazySingleton<HomeViewModel>(() => HomeViewModel(serviceLocator()));
}
