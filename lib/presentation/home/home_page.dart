import 'package:flutter/material.dart';
import 'package:flutter_github_repos/data/model/repos.dart';
import 'package:flutter_github_repos/service_locator.dart';
import 'package:provider/provider.dart';

import 'home_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _viewModel = serviceLocator.get<HomeViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  void _showSnackbar(error) {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("$error"),
        duration: Duration(seconds: 10),
        action: SnackBarAction(
          label: "OK", // TODO: Internationalization here
          onPressed: () => _scaffoldKey.currentState.hideCurrentSnackBar(),
        ),
      ));
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('GitHub Repos'),
      ),
      body: ChangeNotifierProvider<HomeViewModel>(
        builder: (context) => _viewModel,
        child: Consumer<HomeViewModel>(
          builder: (context, model, child) {
            if (model.state.error != null) {
              _showSnackbar(model.state.error);
            }
            if (model.state.isLoading) {
              return _renderLoading();
            }
            return _renderContent(model.state);
          },
        ),
      ));

  Future<void> _onRefresh() async => _viewModel.refresh();

  Widget _renderLoading() => Center(
        child: CircularProgressIndicator(),
      );

  Widget _renderContent(HomeViewState state) => RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          separatorBuilder: (context, index) => Divider(),
          itemCount: state.repoList.length + (state.hasNext ? 1 : 0),
          itemBuilder: (context, i) {
            if (i == state.repoList.length && state.hasNext) {
              _viewModel.loadMore();
              return _renderLoadingItem();
            } else {
              return _renderRepoItem(state.repoList[i]);
            }
          },
        ),
      );

  Widget _renderLoadingItem() => Center(
        child: CircularProgressIndicator(),
      );

  Widget _renderRepoItem(Repo repo) => ListTile(
        title: Text(repo.name),
        subtitle: Text(repo.description ?? ""),
        trailing: Text(repo.owner.login),
      );
}
