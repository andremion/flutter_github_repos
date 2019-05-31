import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'repos_remote.g.dart';

class ReposRemoteDataSource {
  Future<FindReposResponse> findRepos({page = 1, @required perPage}) async {
    final response = await http.get(
      'https://api.github.com/search/repositories?q=flutter&page=$page&per_page=$perPage',
      headers: {"": ""},
    );

    var jsonMap = json.decode(response.body);
    if (response.statusCode == 200) {
      return FindReposResponse.fromJson(jsonMap);
    } else {
      final error = ErrorResponse.fromJson(jsonMap);
      throw Exception('Failed to find repos: $error.message');
    }
  }
}

@JsonSerializable()
class ErrorResponse {
  final String message;

  ErrorResponse(this.message);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);
}

@JsonSerializable()
class FindReposResponse {
  final int total;
  final List<RepoRemote> items;

  FindReposResponse({this.total, this.items});

  factory FindReposResponse.fromJson(Map<String, dynamic> json) => _$FindReposResponseFromJson(json);
}

@JsonSerializable()
class RepoRemote {
  final String name;
  final String description;
  final OwnerRemote owner;

  RepoRemote({this.name, this.description, this.owner});

  factory RepoRemote.fromJson(Map<String, dynamic> json) => _$RepoRemoteFromJson(json);
}

@JsonSerializable()
class OwnerRemote {
  final String login;

  OwnerRemote({this.login});

  factory OwnerRemote.fromJson(Map<String, dynamic> json) => _$OwnerRemoteFromJson(json);
}
