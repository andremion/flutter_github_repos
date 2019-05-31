import 'dart:async';

import 'package:flutter_github_repos/data/repository/repos_repository.dart';
import 'package:flutter_github_repos/presentation/base_view_model.dart';
import 'package:meta/meta.dart';

class HomeViewModel extends BaseViewModel<HomeViewState> {
  final ReposRepository _repository;

  HomeViewModel(this._repository);

  init() {
    setState(HomeViewState(isInitialLoading: true));
    _loadInitialPage();
  }

  loadMore() {
    if (state.isLoadingMore) return;
    // Do not notify here. Just need to update the state in order to not request loading while it's current loading.
    setState(state.copy(isLoadingMore: true), notify: false);
    _loadNextPage();
  }

  // Refresh needs to be a [Future] to show a better UX using a refresh indicator
  Future<void> refresh() async => _loadInitialPage();

  clearError() => setState(state.copy(error: null), notify: false);

  _loadInitialPage() => _repository.findRepos().then(
        (paginatedList) => setState(state.copy(
              isInitialLoading: false,
              repoList: paginatedList.items,
              hasNext: paginatedList.hasNext(),
              error: null,
            )),
        onError: (error) => setState(state.copy(isInitialLoading: false, error: error)),
      );

  _loadNextPage() => _repository.findRepos(fetchedItemCount: state.repoList.length ?? 0).then(
        (paginatedList) => setState(state.copy(
              isLoadingMore: false,
              repoList: List.from(state.repoList)..addAll(paginatedList.items),
              hasNext: paginatedList.hasNext(),
              error: null,
            )),
        onError: (error) => setState(state.copy(isLoadingMore: false, error: error)),
      );
}

@immutable
class HomeViewState {
  final bool isInitialLoading;
  final List<Repo> repoList;
  final bool hasNext;
  final bool isLoadingMore;
  final Exception error;

  HomeViewState({
    this.isInitialLoading = false,
    this.repoList = const [],
    this.hasNext = false,
    this.isLoadingMore = false,
    this.error,
  });

  // So many boilerplate to copy :/
  HomeViewState copy({
    bool isInitialLoading,
    List<Repo> repoList,
    bool hasNext,
    bool isLoadingMore,
    Exception error,
  }) {
    isInitialLoading ??= this.isInitialLoading;
    repoList ??= this.repoList;
    hasNext ??= this.hasNext;
    isLoadingMore ??= this.isLoadingMore;
    error ??= this.error;
    return HomeViewState(
      isInitialLoading: isInitialLoading,
      repoList: repoList,
      hasNext: hasNext,
      isLoadingMore: isLoadingMore,
      error: error,
    );
  }
}
