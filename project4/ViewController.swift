//
//  ViewController.swift
//  project4
//
//  Created by EnesÖzcan on 27.02.2024.
//

import UIKit
import WebKit

// ViewController sınıfını UIViewController ve WKNavigationDelegate protokollerinden türetiyoruz.
class ViewController: UIViewController, WKNavigationDelegate {
    // WKWebView ve UIProgressView nesnelerini tanımlıyoruz.
    var webView: WKWebView!
    var progressView: UIProgressView!
    var webSites = ["apple.com","hackingwitswift.com"]
    
    // ViewController'ın view'ını oluşturan ve yükleyen yöntem.
    override func loadView() {
        webView = WKWebView() // WKWebView nesnesi oluşturuluyor.
        webView.navigationDelegate = self // webView'in navigationDelegate özelliği bu sınıfı işaret ediyor.
        view = webView // ViewController'ın view özelliği, oluşturduğumuz webView'e ayarlanıyor.
    }
    
    // ViewController'ın görünümü yüklendikten sonra çağrılan yöntem.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar'a "Open" adında bir buton ekliyoruz.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // Toolbar için gerekli ayarlamalar yapılıyor.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView.goBack(), action: #selector(webView.goBack))
        let next = UIBarButtonItem(barButtonSystemItem: .edit, target: webView.goForward(), action: #selector(webView.goForward))
        toolbarItems = [progressButton, spacer, back, next, refresh] // Toolbar'a butonlar ekleniyor.
        navigationController?.isToolbarHidden = false // Navigation controller'ın toolbar'ı gösterildi.
        
        // webView'in estimatedProgress özelliğini izleyerek UIProgressView'ı güncelleyen bir observer ekleniyor.
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // Başlangıçta yüklenecek URL belirleniyor ve yükleniyor.
        let url = URL(string: "https://" + webSites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true // Geri ve ileri hareketleri izin veriliyor.
    }
    
    // "Open" butonuna tıklandığında çağrılan yöntem.
    @objc func openTapped() {
        let ac = UIAlertController(title: "open page..", message: nil, preferredStyle: .actionSheet)
        
        for website in webSites{
            
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    // UIAlertController'den seçilen sayfayı açmak için çağrılan yöntem.
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    // WebView'in navigasyonu tamamladığında çağrılan yöntem.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title // WebView'in başlığı, ViewController'ın başlığı olarak ayarlanıyor.
    }
    
    // WebView'in estimatedProgress özelliğini izleyen observer için çağrılan yöntem.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress) // ProgressView'ın değeri, WebView'in estimatedProgress değerine göre güncelleniyor.
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // İstenen URL'yi alıyoruz
        let url = navigationAction.request.url

        // URL'nin host kısmını kontrol ediyoruz
        if let host = url?.host {
            // İzin verilen web siteleri listesi üzerinde dönüyoruz
            for website in webSites {
                // Eğer URL'nin host kısmı, izin verilen web sitelerinden birini içeriyorsa, sayfanın yüklenmesine izin veriyoruz
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }else {
                    let alertController = UIAlertController(title: "engelledin", message: "engellendin dostum", preferredStyle: .alert)

                    let action = UIAlertAction(title: "tammmmm", style: .default) { (action:UIAlertAction) in
                        // Tamam butonuna basıldığında yapılacak işlemler
                    }

                    alertController.addAction(action)

                    // Alerti göstermek için
                    self.present(alertController, animated: true, completion: nil)

                }
            }
        }

        // İzin verilmeyen web sitelerini engelliyoruz
        decisionHandler(.cancel)
    }

}
