//
//  ListContactsViewController.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 15.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

class ListContactsViewController: UIViewController {
    private let list = UITableView.init(frame: .zero)
    
    private var contactManager: ContactManager!
    var changeNameGroup: ((String) -> Void)?
    
    init(name: String, idcm: String) {
        super.init(nibName: nil, bundle: nil)
        contactManager = ContactManager(idcm: idcm)
        self.title = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactManager.contactsDidChange = {[weak self] in
            guard let self = self else { return }
            self.list.reloadData()
        }
        
        contactManager.errorMessage = { [weak self] (text) in
            self?.showAlert(text:text)
        }
        
        contactManager.setContacts()
        
        view.backgroundColor = UIColor.darkGray
        
        let buttonDone = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(save))
        let buttonEditName = UIBarButtonItem.init(title: "edit name", style: .plain, target: self, action: #selector(editName))
        
        self.navigationItem.leftBarButtonItem = buttonEditName
        self.navigationItem.rightBarButtonItem = buttonDone
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = .darkGray
        
        list.register(ContactTableViewCell.self, forCellReuseIdentifier: "cellcontact")
        list.translatesAutoresizingMaskIntoConstraints = false
        list.allowsMultipleSelection = true
        list.backgroundColor = .darkGray
        list.delegate = self
        list.dataSource = self
        
        view.addSubview(list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }

    override func viewDidLayoutSubviews() {
        var safeArea: CGFloat
        if #available(iOS 11, *){
            safeArea = view.safeAreaInsets.top
        } else {
            safeArea = topLayoutGuide.length
        }
        
        list.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
        list.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        list.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        list.topAnchor.constraint(equalTo: view.topAnchor, constant: safeArea).isActive =  true
    }
    
    @objc
    func save() {
        contactManager.saveChois()
        self.navigationController?.popViewController(animated: true)
    }
    @objc
    func editName() {
        let alert = UIAlertController.init(title: "Edit name group", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { [weak self, weak alert](_) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.title = alert?.textFields?.first?.text
                if self.changeNameGroup != nil {
                    self.changeNameGroup!(self.title!)
                }
            }
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true) {  }
    }

}

extension ListContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactManager.addChoise(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        contactManager.removeContact(indexPath.row)
    }
    
}

extension ListContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactManager.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataForList = contactManager.getContact(for: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellcontact") as! ContactTableViewCell
       
        if dataForList.1 {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
        cell.setNumber(contact: dataForList.0)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}

extension ListContactsViewController {
    func showAlert(text: String) {
        let alert = UIAlertController.init(title: "", message: text, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
