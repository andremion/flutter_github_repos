import 'package:flutter_github_repos/data/model/repos.dart';
import 'package:flutter_github_repos/data/remote/repos_remote.dart';

class ReposRepository {
  static const int PER_PAGE = 10;

  final ReposRemoteDataSource _remoteDataSource;

  ReposRepository(this._remoteDataSource);

  Future<PaginatedList<Repo>> findRepos({int fetchedItemCount = 0}) => _remoteDataSource
      .findRepos(page: fetchedItemCount ~/ PER_PAGE + 1, perPage: PER_PAGE)
      .then((response) => PaginatedList.fromRemote(response));
}
