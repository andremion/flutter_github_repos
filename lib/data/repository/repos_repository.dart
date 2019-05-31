import 'package:equatable/equatable.dart';
import 'package:flutter_github_repos/data/remote/repos_remote.dart';

class ReposRepository {
  static const int PER_PAGE = 10;

  final ReposRemoteDataSource _remoteDataSource;

  ReposRepository(this._remoteDataSource);

  Future<PaginatedList<Repo>> findRepos({int fetchedItemCount = 0}) => _remoteDataSource
      .findRepos(page: fetchedItemCount ~/ PER_PAGE + 1, perPage: PER_PAGE)
      .then((response) => PaginatedList.fromRemote(response));
}

class PaginatedList<T> extends Equatable {
  final int total;
  final List<T> items;

  PaginatedList({this.total, this.items});

  bool hasNext() => total > items.length;

  static fromRemote(FindReposResponse response) => PaginatedList(
        total: response.total,
        items: response.items.map((repoRemote) => Repo.fromRemote(repoRemote)).toList(),
      );
}

class Repo extends Equatable {
  final String name;
  final String description;
  final Owner owner;

  Repo({this.name, this.description, this.owner});

  factory Repo.fromRemote(RepoRemote repoRemote) => Repo(
        name: repoRemote.name,
        description: repoRemote.description,
        owner: Owner.fromRemote(repoRemote.owner),
      );
}

class Owner extends Equatable {
  final String login;

  Owner({this.login});

  factory Owner.fromRemote(OwnerRemote ownerRemote) => Owner(
        login: ownerRemote.login,
      );
}
