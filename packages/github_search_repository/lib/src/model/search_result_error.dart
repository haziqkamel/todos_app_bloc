/// Error model for search result
class SearchResultError implements Exception {
  /// Creates a new search result error.
  SearchResultError({required this.message});

  /// Create a [SearchResultError] from JSON
  factory SearchResultError.fromJson(Map<String, dynamic> json) {
    return SearchResultError(
      message: json['message'] as String,
    );
  }

  /// The error message.
  final String message;
}
