//
//  AuthViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 18/07/22.
//

import UIKit
import WebKit

final class AuthViewController: UIViewController {

    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    public var isSignedIn: ((Bool) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        webView.navigationDelegate = self
        guard let url = AuthManager.shared.signInURL else { return }
        webView.load(URLRequest(url: url))
    }

    private func setView() {
        addSubviews()
        setConstraints()
    }

    private func addSubviews() {
        view.addSubview(webView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        // Get code that Spotify gives us for accessToken
        let components = URLComponents(string: url.absoluteString)
        let code = components?.queryItems?.first(where: { item in
            item.name == "code"
        })
        guard let spotifyCode = code?.value else { return }
        webView.isHidden = true
        AuthManager.shared.getCodeForToken(code: spotifyCode) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.isSignedIn?(success)
            }
        }
    }
}
