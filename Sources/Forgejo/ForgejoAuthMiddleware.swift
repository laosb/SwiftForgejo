@_exported import ForgejoAPI
import Foundation
import HTTPTypes
import OpenAPIRuntime

public typealias ForgejoClient = Client

/// Middleware for handling Forgejo authentication.
public struct ForgejoAuthMiddleware: ClientMiddleware {
  /// The authentication credentials.
  public var credentials: ForgejoAuthCredentials?

  /// Initializes the middleware with optional credentials.
  public init(credentials: ForgejoAuthCredentials? = nil) {
    self.credentials = credentials
  }

  public func intercept(
    _ request: HTTPRequest,
    body: HTTPBody?,
    baseURL: URL,
    operationID: String,
    next:
      @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (
        HTTPResponse, HTTPBody?
      )
  ) async throws -> (HTTPResponse, HTTPBody?) {
    var request = request

    request.headerFields[.userAgent] = "SwiftForgejo"

    if let credentials {
      switch credentials {
      case .login(let username, let password, let totp):
        let originalString = "\(username):\(password)"
        let base64EncodedString = Data(originalString.utf8).base64EncodedString()
        request.headerFields[.authorization] = "Basic \(base64EncodedString)"
        if let totp {
          request.headerFields[.xForgejoOTP] = totp
        }
      case .token(let token):
        request.headerFields[.authorization] = "Bearer \(token)"
      }
    }

    return try await next(request, body, baseURL)
  }
}

extension HTTPField.Name {
  /// The X-Forgejo-OTP header field name.
  public static let xForgejoOTP = HTTPField.Name("X-Forgejo-OTP")!
}
