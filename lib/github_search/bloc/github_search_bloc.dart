import 'package:bloc/bloc.dart';
import 'package:github_search_repository/github_search_repository.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:todos_app/github_search/bloc/github_search_event.dart';
import 'package:todos_app/github_search/bloc/github_search_state.dart';

/*
We create a custom EventTransformer to debounce the GithubSearchEvents. 
One of the reasons why we created a Bloc instead of a Cubit 
was to take advantage of stream transformers.
*/

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class GithubSearchBloc extends Bloc<GithubSearchEvent, GithubSearchState> {
  GithubSearchBloc({required this.githubSearchRepository})
      : super(SearchStateEmpty()) {
    on<TextChanged>(_onTextChanged, transformer: debounce(_duration));
  }

  final GithubSearchRepository githubSearchRepository;

  Future<void> _onTextChanged(
    TextChanged event,
    Emitter<GithubSearchState> emit,
  ) async {
    final searchTerm = event.text;

    if (searchTerm.isEmpty) return emit(SearchStateEmpty());

    emit(SearchStateLoading());
    try {
      final results = await githubSearchRepository.search(event.text);
      emit(SearchStateSuccess(results.items));
    } catch (e) {
      emit(
        e is SearchResultError
            ? SearchStateError(e.message)
            : SearchStateError(e.toString()),
      );
    }
  }
}
