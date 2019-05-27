import 'dart:async';

import 'package:flutter_github_repos/data/model/repos.dart';
import 'package:flutter_github_repos/data/repository/repos_repository.dart';
import 'package:flutter_github_repos/presentation/base_view_model.dart';
import 'package:meta/meta.dart';

class HomeViewModel extends BaseViewModel<HomeViewState> {
  final ReposRepository _repository;

  HomeViewModel(this._repository);

  init() {
    setState(HomeViewState(isLoading: true));
    _loadInitialPage();
  }

  loadMore() {
    if (state.isPaginating) return;
    // Do not notify here. Just need to update the state in order to not request loading while it's current loading.
    setState(state.copy(isPaginating: true), notify: false);
    _loadNextPage();
  }

  // Refresh needs to be a [Future] to show a better UX using a refresh indicator
  Future<void> refresh() async => _loadInitialPage();

  _loadInitialPage() => _repository.findRepos().then(
        (paginatedList) => setState(state.copy(
              isLoading: false,
              repoList: paginatedList.items,
              hasNext: paginatedList.hasNext(),
            )),
        onError: (error) => setState(state.copy(isLoading: false, error: error)),
      );

  _loadNextPage() => _repository.findRepos(fetchedItemCount: state.repoList.length ?? 0).then(
        (paginatedList) => setState(state.copy(
              isPaginating: false,
              repoList: List.from(state.repoList)..addAll(paginatedList.items),
              hasNext: paginatedList.hasNext(),
            )),
        onError: (error) => setState(state.copy(isPaginating: false, error: error)),
      );
}

@immutable
class HomeViewState {
  final bool isLoading;
  final List<Repo> repoList;
  final bool hasNext;
  final bool isPaginating;
  final Exception error;

  HomeViewState({
    this.isLoading = false,
    this.repoList = const [],
    this.hasNext = false,
    this.isPaginating = false,
    this.error,
  });

  // So many boilerplate to copy :/
  HomeViewState copy({
    bool isLoading,
    List<Repo> repoList,
    bool hasNext,
    bool isPaginating,
    Exception error,
  }) {
    isLoading ??= this.isLoading;
    repoList ??= this.repoList;
    hasNext ??= this.hasNext;
    isPaginating ??= this.isPaginating;
    error ??= this.error;
    return HomeViewState(
      isLoading: isLoading,
      repoList: repoList,
      hasNext: hasNext,
      isPaginating: isPaginating,
      error: error,
    );
  }
}
