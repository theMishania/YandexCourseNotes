import Foundation
import WebKit

final class AuthViewController: UIViewController {

    private let webView = WKWebView()
    private let clientId = "79b8d3185bfb7a9be1c1"
    private let clientSecret = "a7025c3a3685fc139cb83ec965c7afebd1176037"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        guard let request = codeGetRequest else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }

    // MARK: Private
    private func setupViews() {
        view.backgroundColor = .white
        self.title = "GitHub login"
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private var codeGetRequest: URLRequest? {
        //let yandexAutorize = "https://oauth.yandex.ru/authorize"
        let githubAccountAutorize = "https://github.com/login/oauth/authorize"
        guard var urlComponents = URLComponents(string: githubAccountAutorize) else { return nil }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "\(clientId)"),
            URLQueryItem(name: "scope", value: "gist")
        ]

        guard let url = urlComponents.url else { return nil }

        return URLRequest(url: url)
    }
    
    private func tokenGetRequst(withCode code: String) -> URLRequest?{
        let githubLink = "https://github.com/login/oauth/access_token"
        guard var urlComponents = URLComponents(string: githubLink) else {return nil}
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "\(clientId)"),
            URLQueryItem(name: "client_secret", value: "\(clientSecret)"),
            URLQueryItem(name: "code", value: code)
        ]
        guard let url = urlComponents.url else {return nil}
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
        
    }
    
}

extension AuthViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == scheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }

            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                print(code)
                
                guard let request = tokenGetRequst(withCode: code) else {print("No request"); return}
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let data = data else {return}
                    
                    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    guard let token = json["access_token"] as? String else {return}
                    print(json)
                    print(token)
                    UserDefaults.standard.set(token, forKey: "accessToken")
                }
                task.resume()
            }
            dismiss(animated: true, completion: nil)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "No internet connection", message: "fix your connection to load your notes", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

private let scheme = "notes" // схема для notes
