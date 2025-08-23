@_exported import ForgejoAPI
import Foundation
import HTTPTypes
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime

public typealias ForgejoClient = Client

extension ForgejoClient {
  public init(url: URL, credentials: ForgejoAuthCredentials? = nil) {
    let transport = AsyncHTTPClientTransport()
    let authMiddleware = ForgejoAuthMiddleware(credentials: credentials)

    self.init(serverURL: url, transport: transport, middlewares: [authMiddleware])
  }
}

struct ForgejoAuthMiddleware: ClientMiddleware {
  var credentials: ForgejoAuthCredentials?

  init(credentials: ForgejoAuthCredentials? = nil) {
    self.credentials = credentials
  }

  func intercept(
    _ request: HTTPRequest,
    body: HTTPBody?,
    baseURL: URL,
    operationID: String,
    next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (
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
  public static let xForgejoOTP = HTTPField.Name("X-Forgejo-OTP")!
}
