//
//  ViewController.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 06.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    let listCall = UITableView.init(frame: .zero)
    
    var callManager: CallManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        callManager = AppDelegate.shared.callManager
        callManager.callChangeHandler = {[weak self] in
            guard let self = self else {return}
            self.listCall.reloadData()
        }
        
        view.backgroundColor = UIColor.white
        
        let buttonPus = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = buttonPus
        self.navigationItem.title = "List Calls"
        self.navigationController?.hidesBarsOnTap = false
        
        listCall.register(CallTableViewCell.self, forCellReuseIdentifier: "cell")
        listCall.translatesAutoresizingMaskIntoConstraints = false
        listCall.delegate = self
        listCall.dataSource = self
        
        view.addSubview(listCall)
    }

    override func viewDidLayoutSubviews() {
        var safeArea: CGFloat
        if #available(iOS 11, *){
            safeArea = view.safeAreaInsets.top
        } else {
            safeArea = topLayoutGuide.length
        }
        
        listCall.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
        listCall.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        listCall.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        listCall.topAnchor.constraint(equalTo: view.topAnchor, constant: safeArea).isActive =  true
    }
    
    @objc
    func add() {
        let handle = "1234"
        let videoEnable = false
        let incoming = true
        
        if incoming {
            let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                AppDelegate.shared.displayIncommingCall(UUID: UUID(),
                                                        handele: handle,
                                                        hasVideo: videoEnable
                ) { _ in
                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                }
            }
        } else {
            //print("outcall")
        }
        
    }

}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "End"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let call = callManager.calls[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callManager.calls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let call = callManager.calls[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CallTableViewCell
        cell.setState(state: call.state)
        cell.setNumber(number: call.handle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let call = callManager.calls[indexPath.row]
        callManager.end(call: call)
    }
}
