import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_search_repository/github_search_repository.dart';
import 'package:todos_app/app/bloc/app_bloc.dart';
import 'package:todos_app/app/routes/routes.dart';
import 'package:todos_app/l10n/l10n.dart';
import 'package:todos_app/theme/theme.dart';
import 'package:todos_repository/todos_repository.dart';

class App extends StatelessWidget {
  const App({
    required this.todosRepository,
    required this.authenticationRepository,
    required this.githubSearchRepository,
    super.key,
  });

  final TodosRepository todosRepository;
  final AuthenticationRepository authenticationRepository;
  final GithubSearchRepository githubSearchRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => todosRepository),
        RepositoryProvider(create: (context) => authenticationRepository),
        RepositoryProvider(create: (context) => githubSearchRepository),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: TodosAppTheme.light,
      darkTheme: TodosAppTheme.dark,
      themeMode: context.select((AppBloc bloc) => bloc.state.themeMode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
