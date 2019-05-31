// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repos_remote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) {
  return ErrorResponse(json['message'] as String);
}

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{'message': instance.message};

FindReposResponse _$FindReposResponseFromJson(Map<String, dynamic> json) {
  return FindReposResponse(
      total: json['total'] as int,
      items: (json['items'] as List)
          ?.map((e) =>
              e == null ? null : RepoRemote.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$FindReposResponseToJson(FindReposResponse instance) =>
    <String, dynamic>{'total': instance.total, 'items': instance.items};

RepoRemote _$RepoRemoteFromJson(Map<String, dynamic> json) {
  return RepoRemote(
      name: json['name'] as String,
      description: json['description'] as String,
      owner: json['owner'] == null
          ? null
          : OwnerRemote.fromJson(json['owner'] as Map<String, dynamic>));
}

Map<String, dynamic> _$RepoRemoteToJson(RepoRemote instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'owner': instance.owner
    };

OwnerRemote _$OwnerRemoteFromJson(Map<String, dynamic> json) {
  return OwnerRemote(login: json['login'] as String);
}

Map<String, dynamic> _$OwnerRemoteToJson(OwnerRemote instance) =>
    <String, dynamic>{'login': instance.login};
