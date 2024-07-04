import 'package:github_search_repository/src/model/search_result_item.dart';

/// Represents a search result from the Github API.
class SearchResult {
  /// Creates a new search result.
  SearchResult({required this.items});

  /// Create a [SearchResult] from JSON
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List)
        .map((item) => SearchResultItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return SearchResult(items: items);
  }

  /// The search result items.
  final List<SearchResultItem> items;
}
