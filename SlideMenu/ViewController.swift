//
//  ViewController.swift
//  SlideMenu
//
//  Created by Godfather on 3/10/17.
//  Copyright © 2017 Godfather. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableviewMenu: UITableView!
    var listScreen = ["Thông tin", "Sản phẩm", "Khách hàng"]
    var backgroundView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.switchToTheNextScreen), name: NSNotification.Name.init(rawValue: "next"), object: nil)
    }
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        leftConstraint.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (check) in
            self.backgroundView = UIView(frame: CGRect(x: self.tableviewMenu.frame.width, y: 64, width: self.view.frame.width, height: self.view.frame.height))
            self.backgroundView.backgroundColor = .clear
            self.view.addSubview(self.backgroundView)
            
            let tapGestue = UITapGestureRecognizer(target: self, action: #selector(self.closeMenu))
            self.backgroundView.addGestureRecognizer(tapGestue)
        })
    }
    
    func closeMenu() {
        leftConstraint.constant = -150
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (check) in
            self.backgroundView.removeFromSuperview()
        }
    }
    
    func switchToTheNextScreen(noti: Notification) {
        guard let userInfo = noti.userInfo else {return}
        guard let storyboardString = userInfo["value"] as? String else {return}
        var identifier: String = ""
        // Bỏ khoảng trắng -> Bỏ dấu tiếng việt -> chuyển chữ thường
        identifier = storyboardString.replacingOccurrences(of: " ", with: "").folding(options: .diacriticInsensitive, locale: .current).lowercased()
        
        // Kiểm tra các chữ cái đặc biệt nếu có
        if identifier.contains("đ") {
            identifier = identifier.replacingOccurrences(of: "đ", with: "d")
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(vc!, animated: true)
        closeMenu()
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listScreen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableviewMenu.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = listScreen[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "next"), object: nil, userInfo: ["value": listScreen[indexPath.row]])
    }
    
}






