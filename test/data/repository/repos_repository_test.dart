import 'package:flutter_github_repos/data/remote/repos_remote.dart';
import 'package:flutter_github_repos/data/repository/repos_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class _MockDataSource extends Mock implements ReposRemoteDataSource {}

void main() {
  final ReposRemoteDataSource _dataSource = _MockDataSource();
  final ReposRepository _repository = ReposRepository(_dataSource);

  group("ReposRepositoryTest", () {
    test("when find first page of repos succesfully, should get first page list", () {
      when(_dataSource.findRepos(perPage: 10)).thenAnswer((_) => Future.value(_Preconditions.aFirstPageReposResponse));

      final whenFindRepos = _repository.findRepos();

      expect(whenFindRepos, completion(_Expectations.aFirstPageList));
    });

    test("when find second page of repos succesfully, should get second page list", () {
      when(_dataSource.findRepos(page: 2, perPage: 10))
          .thenAnswer((_) => Future.value(_Preconditions.aSecondPageReposResponse));

      final whenFindRepos = _repository.findRepos(fetchedItemCount: 10);

      expect(whenFindRepos, completion(_Expectations.aSecondPageList));
    });

    test("when error while finding repos, should get that error", () {
      final anError = Exception("Failed to find repos");
      when(_dataSource.findRepos(page: 1, perPage: 10)).thenAnswer((_) => Future.error(anError));

      final whenFindRepos = _repository.findRepos();

      expect(whenFindRepos, throwsA(anError));
    });
  });
}

class _Preconditions {
  static final aFirstPageReposResponse = FindReposResponse(
    total: 100,
    items: _generateRepos(page: 1),
  );
  static final aSecondPageReposResponse = FindReposResponse(
    total: 100,
    items: _generateRepos(page: 2),
  );

  static _generateRepos({int page}) => List.generate(10, (i) {
        final id = i * page + 1;
        return RepoRemote(
          name: "name$id",
          description: "description$id",
          owner: OwnerRemote(login: "login$id"),
        );
      });
}

class _Expectations {
  static final aFirstPageList = PaginatedList<Repo>(
    total: 100,
    items: _generateRepos(page: 1),
  );
  static final aSecondPageList = PaginatedList<Repo>(
    total: 100,
    items: _generateRepos(page: 2),
  );

  static _generateRepos({int page}) => List.generate(10, (i) {
        final id = i * page + 1;
        return Repo(
          name: "name$id",
          description: "description$id",
          owner: Owner(login: "login$id"),
        );
      });
}
