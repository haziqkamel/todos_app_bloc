import 'package:github_search_repository/src/github_cache.dart';
import 'package:github_search_repository/src/github_client.dart';
import 'package:github_search_repository/src/model/model.dart';

/// {@template github_search_repository}
/// GitHub search repository
/// {@endtemplate}
class GithubSearchRepository {
  /// {@macro github_search_repository}
  GithubSearchRepository({
    GithubCache? cache,
    GithubClient? client,
  })  : _cache = cache ?? GithubCache(),
        _client = client ?? GithubClient();

  final GithubCache _cache;
  final GithubClient _client;

  /// Search repositories by [query].
  Future<SearchResult> search(String query) async {
    if (_cache.contains(query)) {
      return _cache.get(query)!;
    } else {
      final result = await _client.search(query);
      _cache.set(query, result);
      return result;
    }
  }
}
