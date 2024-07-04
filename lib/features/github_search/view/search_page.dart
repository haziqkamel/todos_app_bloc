import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/features/github_search/bloc/github_search_bloc.dart';
import 'package:todos_app/features/github_search/bloc/github_search_event.dart';
import 'package:todos_app/features/github_search/bloc/github_search_state.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Github'),
      ),
      body: Column(
        children: [
          _SearchBar(),
          _SearchBody(),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => __SearchBarState();
}

class __SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();
  late GithubSearchBloc _githubSearchBloc;

  @override
  void initState() {
    _githubSearchBloc = context.read<GithubSearchBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (value) {
        _githubSearchBloc.add(TextChanged(value));
      },
      decoration: InputDecoration(
        hintText: 'Search Github...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: _onClearTapped,
          child: const Icon(Icons.clear),
        ),
        border: InputBorder.none,
      ),
    );
  }

  void _onClearTapped() {
    _textController.clear();
    _githubSearchBloc.add(const TextChanged(''));
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GithubSearchBloc, GithubSearchState>(
      builder: (context, state) {
        return switch (state) {
          SearchStateEmpty() => const Text('Please enter a term to begin'),
          SearchStateLoading() => const Expanded(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          SearchStateError() => Text(state.error),
          SearchStateSuccess() => Expanded(
              child: ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Image.network(item.owner.avatarUrl),
                    ),
                    title: Text(item.fullName),
                    onTap: () => launchUrl(Uri.parse(item.htmlUrl)),
                  );
                },
              ),
            ),
        };
      },
    );
  }
}
