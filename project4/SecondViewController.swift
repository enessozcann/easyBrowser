//
//  SecondViewController.swift
//  project4
//
//  Created by EnesÖzcan on 11.03.2024.
//

import UIKit
import WebKit

class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate {

    @IBOutlet var tableView: UITableView!
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var webSites = ["apple.com","hackingwitswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Toolbar için gerekli ayarlamalar yapılıyor.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
       
        
        toolbarItems = [spacer, refresh] // Toolbar'a butonlar ekleniyor.
        navigationController?.isToolbarHidden = false // Navigation controller'ın toolbar'ı gösterildi.
        
        // Başlangıçta yüklenecek URL belirleniyor ve yükleniyor.
        let url = URL(string: "https://" + webSites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true // Geri ve ileri hareketleri izin veriliyor.
        
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = webSites[0]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("a")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title // WebView'in başlığı, ViewController'ın başlığı olarak ayarlanıyor.
    }
    
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
