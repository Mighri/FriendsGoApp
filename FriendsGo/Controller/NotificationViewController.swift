//
//  NotificationsViewController.swift
//  FriendsGo
//
//  Created by Radhia Mighri on 06/03/2018.
//  Copyright © 2018 Radhia Mighri. All rights reserved.
//
import UIKit
import SDWebImage

class NotificationViewController: UITableViewController {
    
    var NotificationsArray = [Notifications]()
    
    var friend : Friend!
    
    let urlGetNotifications  = MyClass.Constants.urlGetNotifications
        let urlGetNotificationSender  = MyClass.Constants.urlGetNotificationSender
   
    
    let userId = UserDefaults.standard.string(forKey: "Saveid")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let p = ["idUserNotif" : userId]
        
        Service.sharedInstance.loadNotifications(parameters: p, url: urlGetNotifications) { (state, Objets) in
            if state {
                self.NotificationsArray = Objets!
                
                self.tableView.reloadData()
                
                print("Notifications reçues")
            } else {
                print("nooo Notifications")
            }
            
        }
        
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.title = "Notifications"
    }
    
    // Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if NotificationsArray != nil, NotificationsArray.count > 0
        {
            return NotificationsArray.count
        }
        return 0
        //return FriendArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.participationInfo.text = NotificationsArray[indexPath.row].Body
        
        cell.selectionColor = UIColor(hex:"F7E4EB")
    
        
        print(NotificationsArray[indexPath.row].InvitEventID!)
        
        let parameters = ["idInvEventFG" : NotificationsArray[indexPath.row].InvitEventID!]
        
        Service.sharedInstance.loadInfoAny(parameters: parameters, url: urlGetNotificationSender) { (state, Objets) in
            if state {
                self.friend = Objets![0]
  
                print(self.friend.photoURL!)
                cell.imageAmis.sd_setImage(with: URL(string: self.friend.photoURL!), placeholderImage: UIImage(named: "profile"))
                print("*****************Objets*****************")
            } else {
                print("nooo")
            }
        }
        
        
        
        
        /*
        let now = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        //formatter.dateFormat = "dd-MM HH:mm"
        formatter.timeStyle = .short
       formatter.dateStyle = .medium
        
        let dateString = formatter.string(from: now)
        
        
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        print(dateString)
        */
        
        
      
        
        cell.dateHeure.text = NotificationsArray[indexPath.row].DateNotif
        
     
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}


extension UITableViewCell {
    var selectionColor: UIColor {
        set {
            let view = UIView()
            view.backgroundColor = newValue
            self.selectedBackgroundView = view
        }
        get {
            return self.selectedBackgroundView?.backgroundColor ?? UIColor.clear
        }
    }
}

