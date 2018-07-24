//
//  ParametersViewController.swift
//  FriendsGo
//
//  Created by Radhia Mighri on 18/04/2018.
//  Copyright © 2018 Radhia Mighri. All rights reserved.
//

import UIKit
import SDWebImage


class  ParametersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var friend : Friend!
    var FriendArray = [Friend]()
    var currentFriendArray = [Friend]() //update table
    let urlgetAmis = MyClass.Constants.urlgetAmis
    var searching: Bool! = false
    let userId = UserDefaults.standard.string(forKey: "Saveid")!
    let urlActivatePositionTo = MyClass.Constants.urlActivatePositionTo
    let urlGetActivePosition = MyClass.Constants.urlGetActivePosition
     let urlUpdateActivePosition = MyClass.Constants.urlUpdateActivePosition
    
    var PositionState : ActivatePositionTo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFriends()
        //setUpSearchBar()
        //alterLayout()
        //searchBar.showsCancelButton = false
        
          self.navigationController?.navigationBar.isTranslucent = false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
        searchBar.endEditing(true)
        //searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
        //searchBar.showsCancelButton = true
    }
    /*
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
     searching = false
     searchBar.endEditing(true)
     searchBar.showsCancelButton = false
     }
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.endEditing(true)
        //searchBar.showsCancelButton = false
    }
    
    private func setUpFriends() {
        
        let p = ["IdU" : userId]
        
        Service.sharedInstance.loadInfoAny(parameters: p, url: urlgetAmis) { (state, Objets) in
            if state {
                self.FriendArray = Objets!
                self.currentFriendArray = self.FriendArray
                self.table.reloadData()
                
                print("Objets")
            } else {
                print("nooo")
            }
            
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.title = "Paramètres"
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func alterLayout() {
        table.tableHeaderView = UIView()
        // search bar in section header
        table.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
        searchBar.placeholder = "Rechercher"
    }
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentFriendArray != nil, currentFriendArray.count > 0
        {
            return currentFriendArray.count
        }
        return currentFriendArray.count
        
        //return currentFriendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "ParametersCell") as! ParametersCell
        
        cell.Nom.text = currentFriendArray[indexPath.row].Nom+" "+currentFriendArray[indexPath.row].prenom
        
        //cell.Prenom.text = currentFriendArray[indexPath.row].prenom
        
        cell.imageUrl.sd_setImage(with: URL(string: self.currentFriendArray[indexPath.row].photoURL), placeholderImage: UIImage(named: "profile"))
        
        print(self.currentFriendArray[indexPath.row].id!)
        print(userId)
        
        
        let params = ["IdUserPosition" : userId,
                 "IdFriendPosition": self.currentFriendArray[indexPath.row].id!]
        
        Service.sharedInstance.loadActivatePosition(parameters: params, url: urlGetActivePosition) { (state, Objets) in
            if state {
               self.PositionState = Objets![0]
                
                if  (self.PositionState.ActivatePTo == "On")
                {
                    cell.Switch.isOn = true
                }
                else
                {
                    cell.Switch.isOn = false
                }
                print("ObjetsObjetsObjetsObjetsObjetsObjetsObjetsObjets")
            } else {
                print("nooo")
            }
        }
        
  
        cell.Switch.tag = indexPath.row
        
        cell.Switch.addTarget(self, action: #selector(actionTriggered), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
     @objc func actionTriggered(sender: AnyObject) {
        
        let SwitchTag = sender.tag!
        
        // Get value of "on" to determine current state of UISwitch.
        let onState = sender.isOn
        
        // Write label text depending on UISwitch.
        
        
        
        
        
        
        
        
        
        
        
        
        let params = ["IdUserPosition" : userId,
                      "IdFriendPosition": self.currentFriendArray[SwitchTag].id!]
        
        Service.sharedInstance.loadActivatePosition(parameters: params, url: urlGetActivePosition) { (state, Objets) in
            if state {
                self.PositionState = Objets![0]

                
                
                
                if onState! {
                    
                    print("yessssss")
                    
                    let parametersNotif = ["IdUserPositionn": self.userId,
                                           "ActivatePToPositionn":"On"] as [String : Any]
                    
                    Service.sharedInstance.postIt(parameters:parametersNotif as! [String : String], url:self.urlUpdateActivePosition)
                    
                }
                    
                else {
                    
                    
                
                    let parametersNotif = ["IdUserPositionn": self.userId,
                                           "ActivatePToPositionn":"Off"] as [String : Any]
                    
                    Service.sharedInstance.postIt(parameters:parametersNotif as! [String : String], url:self.urlUpdateActivePosition)
                }
    
            } else {
                
                
                if onState! {
                    
                    print("yessssss")
                    
                    let parametersNotif = ["IdUserP": self.userId,
                                           "ActivatePTo":"On",
                                           "IdFriend": self.currentFriendArray[SwitchTag].id] as [String : Any]
                    
                    Service.sharedInstance.postIt(parameters:parametersNotif as! [String : String], url:self.urlActivatePositionTo)
                    
                }
                    
                else {
                    
                    
                 
                    let parametersNotif = ["IdUserP": self.userId,
                                           "ActivatePTo":"Off",
                                           "IdFriend": self.currentFriendArray[SwitchTag].id] as [String : Any]
                    
                    Service.sharedInstance.postIt(parameters:parametersNotif as! [String : String], url:self.urlActivatePositionTo)
                }
                
                
                print("nooo")
            }
        }
        
        
        
        
        
        
        
        
        
        
       
    }
    
    // This two functions can be used if you want to show the search bar in the section header
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        return searchBar
    //    }
    
    //    // search bar in section header
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentFriendArray = FriendArray.filter({ friend -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { searching = true }
                return (friend.Nom+" "+friend.prenom).lowercased().contains(searchText.lowercased())
            default:
                return searching == false
            }
        })
        table.reloadData()
    }
    
    
    
}




