import 'dart:convert';

import 'package:http/http.dart' as http;

class ReposRemoteDataSource {
  Future<FindReposResponse> findRepos({page = 1, perPage = 10}) async {
    final response = await http.get(
      'https://api.github.com/search/repositories?q=flutter&page=$page&per_page=$perPage',
      headers: {"": ""},
    );

    if (response.statusCode == 200) {
      return FindReposResponse.fromJson(json.decode(response.body));
    } else {
      final message = _getErrorMessage(json.decode(response.body));
      throw Exception('Failed to find repos: $message');
    }
  }

  static String _getErrorMessage(Map<String, dynamic> json) => json['message'];
}

class FindReposResponse {
  final int total;
  final List<RepoRemote> items;

  FindReposResponse({this.total, this.items});

  factory FindReposResponse.fromJson(Map<String, dynamic> json) {
    final total = json['total_count'] as int;
    final items = json['items'] as List<dynamic>;
    List<RepoRemote> repos = items.map((item) => RepoRemote.fromJson(item)).toList();
    return FindReposResponse(
      total: total,
      items: repos,
    );
  }
}

class RepoRemote {
  final String name;
  final String description;
  final OwnerRemote owner;

  RepoRemote({this.name, this.description, this.owner});

  factory RepoRemote.fromJson(Map<String, dynamic> json) => RepoRemote(
        name: json['name'],
        description: json['description'],
        owner: OwnerRemote.fromJson(json['owner']),
      );
}

class OwnerRemote {
  final String login;

  OwnerRemote({this.login});

  factory OwnerRemote.fromJson(Map<String, dynamic> json) => OwnerRemote(
        login: json['login'],
      );
}
