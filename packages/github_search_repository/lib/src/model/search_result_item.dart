import 'package:github_search_repository/src/model/github_user.dart';

/// Represents a search result item from the Github API.
class SearchResultItem {
  /// Creates a new search result item.
  SearchResultItem({
    required this.fullName,
    required this.htmlUrl,
    required this.owner,
  });

  /// Create a [SearchResultItem] from JSON
  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem(
      fullName: json['full_name'] as String,
      htmlUrl: json['html_url'] as String,
      owner: GithubUser.fromJson(json['owner'] as Map<String, dynamic>),
    );
  }
  /// The full name of the repository.
  final String fullName;
  /// The HTML URL of the repository.
  final String htmlUrl;
  /// The repository's owner.
  final GithubUser owner;
}
