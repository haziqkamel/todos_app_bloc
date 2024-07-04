/// {@template github_user}
/// GitHub user
/// {@endtemplate}
class GithubUser {
  /// {@macro github_user}
  GithubUser({
    required this.login,
    required this.avatarUrl,
  });

  /// Create a [GithubUser] from JSON
  factory GithubUser.fromJson(Map<String, dynamic> json) {
    return GithubUser(
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
    );
  }

  /// The user's login
  final String login;
  /// The user's avatar URL
  final String avatarUrl;
}
