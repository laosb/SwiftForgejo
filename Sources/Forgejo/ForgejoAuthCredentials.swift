public enum ForgejoAuthCredentials: Sendable {
  case login(username: String, password: String, totp: String? = nil)
  case token(token: String)
}
