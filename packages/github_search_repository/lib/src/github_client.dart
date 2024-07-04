import 'dart:convert';

import 'package:github_search_repository/src/model/search_result.dart';
import 'package:github_search_repository/src/model/search_result_error.dart';
import 'package:http/http.dart' as http;

/// Represents a search result from the Github API.
class GithubClient {
  /// Creates a new Github client.
  GithubClient({
    http.Client? httpClient,
    this.baseUrl = 'https://api.github.com/search/repositories?q=',
  }) : httpClient = httpClient ?? http.Client();

  /// The base URL for the Github API.
  final String baseUrl;
  /// The HTTP client used to make requests.
  final http.Client httpClient;

  /// Searches for repositories with the given [query].
  Future<SearchResult> search(String query) async {
    final response = await httpClient.get(Uri.parse('$baseUrl$query'));
    final results = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return SearchResult.fromJson(results);
    } else {
      throw SearchResultError.fromJson(results);
    }
  }
}
