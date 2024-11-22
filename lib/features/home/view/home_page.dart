import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_search_repository/github_search_repository.dart';
import 'package:todos_app/features/edit_todo/view/view.dart';
import 'package:todos_app/features/github_search/bloc/github_search_bloc.dart';
import 'package:todos_app/features/github_search/view/view.dart';
import 'package:todos_app/features/home/cubit/home_cubit.dart';
import 'package:todos_app/features/stats/view/view.dart';
import 'package:todos_app/features/todos_overview/view/view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(
            context.read<AuthenticationRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => GithubSearchBloc(
            githubSearchRepository: context.read<GithubSearchRepository>(),
          ),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: const [
          TodosOverviewPage(),
          StatsPage(),
          SearchPage(),
        ],
      ),
      floatingActionButton: selectedTab.name == 'todos'
          ? FloatingActionButton(
              shape: const CircleBorder(),
              key: const Key('homeView_addTodo_floatingActionButton'),
              onPressed: () => Navigator.of(context).push(EditTodoPage.route()),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.todos,
              icon: const Icon(Icons.list_rounded),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.stats,
              icon: const Icon(Icons.show_chart_rounded),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.search,
              icon: const Icon(Icons.search_rounded),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.logout,
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      color:
          groupValue != value ? null : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}
