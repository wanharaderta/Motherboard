//
//  AuthProviderManager.swift
//  Motherboard
//
//  Created by Wanhar on 11/12/25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

// MARK: - Safe presenter
func topMostViewController(base: UIViewController? = nil) -> UIViewController? {
  let root = base ?? UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }?.rootViewController

  if let nav = root as? UINavigationController { return topMostViewController(base: nav.visibleViewController) }
  if let tab = root as? UITabBarController { return topMostViewController(base: tab.selectedViewController) }
  if let presented = root?.presentedViewController { return topMostViewController(base: presented) }
  return root
}

// MARK: - Google Sign-In (async API, main-thread safe)
enum GoogleAuth {
  enum GError: LocalizedError { case missingClientID, noPresenter
    var errorDescription: String? {
      switch self {
      case .missingClientID: return "Missing Client ID. Is GoogleService-Info.plist in the app target?"
      case .noPresenter:     return "Couldn’t find a presenter view controller."
      }
    }
  }

  /// Presents Google auth and signs into Firebase. Entire flow runs on the main actor.
  @MainActor
  static func signIn(from presenter: UIViewController? = nil) async throws -> User {
    if FirebaseApp.app() == nil { FirebaseApp.configure() }
    guard let clientID = FirebaseApp.app()?.options.clientID else { throw GError.missingClientID }

    GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

    let vc = presenter ?? topMostViewController()
    guard let vc else { throw GError.noPresenter }

    // Use the async/await API directly (no continuations).
    let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc)
    let user = signInResult.user

    guard let idToken = user.idToken?.tokenString else {
      throw NSError(domain: "GoogleAuth", code: -3,
                    userInfo: [NSLocalizedDescriptionKey: "Missing idToken"])
    }

    let credential = GoogleAuthProvider.credential(
      withIDToken: idToken,
      accessToken: user.accessToken.tokenString
    )
    let firebaseResult = try await Auth.auth().signIn(with: credential)
    return firebaseResult.user
  }
}
