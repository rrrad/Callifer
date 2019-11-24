//
//  GroupListViewController.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 17.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

class GroupeListViewController: UIViewController {
   
    var groupCollection: UICollectionView!
    
    let groupManager = GroupeManager()
    
    override func viewDidLoad() {
        super .viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        self.groupCollection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
       
        view.backgroundColor = .yellow
        groupCollection.backgroundColor = .yellow
        groupCollection.register(GroupeCollectionViewCell.self, forCellWithReuseIdentifier: "colcell")
        groupCollection.translatesAutoresizingMaskIntoConstraints = false
        groupCollection.delegate = self
        groupCollection.dataSource = self
        
        groupManager.dataSoursDidChange = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.groupCollection.reloadData()
            }
        }
        
        groupManager.errorMessage = { [weak self] (text) in
            DispatchQueue.main.async {
                self?.showAlert(text:text)
            }
        }
        
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20.0
        let itemSize = CGSize.init(width: view.bounds.width/3, height: view.bounds.height/5)
        layout.itemSize = itemSize
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets.init(top: 30, left: 30, bottom: 30, right: 30)
        view.addSubview(groupCollection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        groupManager.getBlockGroup()

    }
    
    override func viewDidLayoutSubviews() {
        var safeArea: CGFloat
        if #available(iOS 11, *){
            safeArea = view.safeAreaInsets.top
        } else {
            safeArea = topLayoutGuide.length
        }
        
        groupCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
        groupCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        groupCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        groupCollection.topAnchor.constraint(equalTo: view.topAnchor, constant: safeArea).isActive =  true
    }
    
    func setBadge(set: Bool) {
        if set {
            UIApplication.shared.applicationIconBadgeNumber = 1
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
    }
}

extension GroupeListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == groupManager.getCountGroup() {
            let gr = groupManager.addGroup()// здесь возвращается только что созданная группа
            let vc = ListContactsViewController.init(name: gr.name, idcm: gr.idcm)
            vc.changeNameGroup = { [weak self] (name) in self?.groupManager.updateName(name: name, for: indexPath.row)}
            self.navigationController?.pushViewController(vc, animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            let group = groupManager.getDataForCell(indexPath.row).0
            showMenuAction(for: group, with: indexPath.row)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
}

extension GroupeListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupManager.getCountGroup() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colcell", for: indexPath) as! GroupeCollectionViewCell
        if indexPath.row == groupManager.getCountGroup() {
            cell.setTitle(title: "+")
            cell.backgroundColor = .orange
        } else {
            let group = groupManager.getDataForCell(indexPath.row)
            cell.setTitle(title: group.0.name)
            
            if group.1 == true {
                cell.backgroundColor = .red
                setBadge(set: true)
            } else {
                cell.backgroundColor = .orange
                setBadge(set: false)
            }
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 3

        return cell
    }
    
    
}

extension GroupeListViewController {
    func showMenuAction(for group: Group, with index: Int) {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .alert)
        let edit = UIAlertAction.init(title: "edit", style: .default, handler: { [weak self](action) in
            DispatchQueue.main.async {
                let list = ListContactsViewController.init(name: group.name, idcm: group.idcm)
                list.changeNameGroup = {[weak self](name) in self?.groupManager.updateName(name: name, for: index)}
                self?.navigationController?.pushViewController(list, animated: true)
            }
        })
        let on = UIAlertAction.init(title: "ON", style: .default, handler: { [weak self](action) in
            self?.groupManager.onBlock(for: group)
        })
        
        let off = UIAlertAction.init(title: "OFF", style: .default, handler: { [weak self](action) in
            self?.groupManager.offBlock()
        })
        
        let delete = UIAlertAction.init(title: "delete group", style: .default, handler: {[weak self] (action) in
           self?.groupManager.removGroup(index)
        })
        
        let cancel = UIAlertAction.init(title: "CANCEL", style: .cancel, handler: { (action) in
            
        })
        
        
        alert.addAction(on)
        alert.addAction(off)
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        alert.preferredAction = on
        self.present(alert, animated: true, completion: nil)
    }
}

extension GroupeListViewController {
    func showAlert(text: String) {
        let alert = UIAlertController.init(title: "", message: text, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
