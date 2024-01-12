//
//  myViewController.swift
//  CalcudokuCollection
//
//  Created by 567 on 2023/11/13.
//

import UIKit
import WebKit

class MyViewController: UIViewController {

    let webView = WKWebView()
    var url: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.view = webView
//        loadurl()
    }
    
    func loadurl() {
        let targetUrl = URL(string: url)
        if let dst = targetUrl {
            print(dst)
            let request = URLRequest(url: dst)
            webView.load(request)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 释放资源
        while webView.canGoBack {
            webView.goBack()
        }
        webView.stopLoading()
        print("stop")
    }

}
