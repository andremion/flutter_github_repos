import 'package:flutter_github_repos/data/remote/repos_remote.dart';

class PaginatedList<T> {
  final int total;
  final List<T> items;

  PaginatedList({this.total, this.items});

  bool hasNext() => total > items.length;

  static fromRemote(FindReposResponse response) => PaginatedList(
        total: response.total,
        items: response.items.map((repoRemote) => Repo.fromRemote(repoRemote)).toList(),
      );
}

class Repo {
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

class Owner {
  final String login;

  Owner({this.login});

  factory Owner.fromRemote(OwnerRemote ownerRemote) => Owner(
        login: ownerRemote.login,
      );
}
