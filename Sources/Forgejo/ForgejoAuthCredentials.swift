/// Credentials for authenticating with a Forgejo server.
public enum ForgejoAuthCredentials: Sendable {
  /// Login with username and password, optionally with TOTP for 2FA.
  case login(username: String, password: String, totp: String? = nil)
  /// Token-based authentication.
  ///
  /// Use a personal access token or OAuth token.
  case token(token: String)
}
