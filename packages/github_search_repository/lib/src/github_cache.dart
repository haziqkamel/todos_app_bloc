import 'package:github_search_repository/src/model/search_result.dart';

/// A cache for Github search results.
class GithubCache {
  final _cache = <String, SearchResult>{};

  /// Gets the search result for the given [query].
  SearchResult? get(String query) => _cache[query];

  /// Sets the search result for the given [query].
  void set(String query, SearchResult result) => _cache[query] = result;

  /// Returns `true` if the cache contains the given [query].
  bool contains(String query) => _cache.containsKey(query);

  /// Removes the search result for the given [query].
  void remove(String query) => _cache.remove(query);
}