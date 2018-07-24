//
//  ParticipationPopUp.swift
//  FriendsGo
//
//  Created by Radhia Mighri on 18/04/2018.
//  Copyright © 2018 Radhia Mighri. All rights reserved.
//

import Foundation
import UIKit

class ParticipationPopUp: UIViewController, UINavigationControllerDelegate {
    
     let userId = UserDefaults.standard.string(forKey: "Saveid")!
    var event: Event!
    var friend: Friend!
    var friendd: Friend!
    var invitEvent: InvitationEventFG!
 
    
    let urlUpdateInvEvent = MyClass.Constants.urlUpdateInvEvent
    let urlDeleteInvEvent = MyClass.Constants.urlDeleteInvEvent
    let urlPushNotifications = MyClass.Constants.urlPushNotifications
    let urlGetUsername = MyClass.Constants.urlGetUsername
      let urlAddNotification = MyClass.Constants.urlAddNotification
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        

        let p = ["IdU" : userId]
        
        Service.sharedInstance.loadInfoAny(parameters: p, url: urlGetUsername) { (state, Objets) in
            if state {
                self.friend = Objets![0]
                print("Objets")
            } else {
                print("nooo")
            }
        }
  
        let pppppppp = ["IdU" : event.IdU!]
        
        Service.sharedInstance.loadInfoAny(parameters: pppppppp, url: urlGetUsername) { (state, Objets) in
            if state {
                self.friendd = Objets![0]
                print("Objets")
            } else {
                print("nooo")
            }
        }
        
        
        
        
        
        
    }
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        
        if (selfDivide(number: minute!) == 0)
        {
             let today_string = String(day!) + " " + date.monthAsString() + " " + String(hour!)  + ":" + String(minute!)
              return today_string
        }
        else
        {
            let today_string = String(day!) + " " + date.monthAsString() + " " + String(hour!)  + ":0" + String(minute!)
            return today_string
        }
  
    }
    
    
    func selfDivide(number: Int) -> Int {
        var num = abs(number)
        var count = 0
        while num > 0 {
            let digit = num % 10
            if digit != 0 && number % digit == 0 {
                count += 1
            }
            num = num / 10
        }
        return count
    }
    
    

    @IBAction func participeEventButton(_ sender: AnyObject) {
        
        let paras = ["IdInviteur": event.IdU ,
                     "IdInvite": userId,
                     "Etat" : "Participe",
                     "IdEvent": event.idE
            ] as [String : Any]
        
        
        Service.sharedInstance.postIt(parameters:paras as! [String : String], url:self.urlUpdateInvEvent)
        
        // - Send the notification to the event owner
        
        let name = self.friend.Nom + " "+self.friend.prenom
        print(name)
        
        let tokenDestination = self.friendd.telephone
        print(tokenDestination)
        
        let parametersNotif = ["title": "FriendsGo" ,
                               "body": name+" participe à "+event.titre,
                               "tokenn": tokenDestination] as [String : Any]
        
        Service.sharedInstance.postIt(parameters:parametersNotif as! [String : String], url:self.urlPushNotifications)
        
        print(event.IdU)
        
        // - Save the notification
        
        
        
        
        
        print(getTodayString())
        
        let parametersNotifications = ["InvitEventID": invitEvent.IDIE,
                               "TypeN": "0",
                               "Body": name+" participe à votre événement "+event.titre,
                               "DateNotif": getTodayString(),
                               "IDUN": event.IdU] as [String : Any]
        
        Service.sharedInstance.postIt(parameters:parametersNotifications as! [String : String], url:self.urlAddNotification)
        
        
        
        
        //close()
        let mystoryboard:UIStoryboard = UIStoryboard(name:"Menu", bundle: nil)
        
        let ViewController = mystoryboard.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController

        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    
    @IBAction func neParticipePasEventButton(_ sender: AnyObject) {
        
        let paras = ["IdInviteur": event.IdU ,
                     "IdInvite": userId,
                     "Etat" : "Ne participe pas",
                     "IdEvent": event.idE
            ] as [String : Any]
        
        
        Service.sharedInstance.postIt(parameters:paras as! [String : String], url:self.urlUpdateInvEvent)

                // - Send the notification to the event owner
        
        let name = self.friend.Nom + " "+self.friend.prenom
        print(name)
        
        let tokenDestination = self.friendd.telephone
        print(tokenDestination)
        
        let parametersNotif = ["title": "FriendsGo" ,
                     "body": name+" ne participe pas à "+event.titre,
                     "tokenn": tokenDestination] as [String : Any]

        Service.sharedInstance.postIt(parameters:parametersNotif as! [String : String], url:self.urlPushNotifications)
        
        
        // - Save the notification
        
        let parametersNotifications = ["InvitEventID": invitEvent.IDIE,
                                       "TypeN": "0",
                                       "Body": name+" ne participe pas à votre événement "+event.titre,
                                       "DateNotif": getTodayString(),
                                        "IDUN": event.IdU] as [String : Any]
        
        Service.sharedInstance.postIt(parameters:parametersNotifications as! [String : String], url:self.urlAddNotification)
        
        
  //close()
        
        let mystoryboard:UIStoryboard = UIStoryboard(name:"Menu", bundle: nil)
        
        let ViewController = mystoryboard.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    @IBAction func interesseEventButton(_ sender: AnyObject) {
        
        let paras = ["IdInviteur": event.IdU ,
                     "IdInvite": userId,
                     "Etat" : "Intéressé",
                     "IdEvent": event.idE
            ] as [String : Any]
        
        
        Service.sharedInstance.postIt(parameters:paras as! [String : String], url:self.urlUpdateInvEvent)
        
                // - Send the notification to the event owner
        
        let name = self.friend.Nom + " "+self.friend.prenom
        print(name)
        
        let tokenDestination = self.friendd.telephone
        print(tokenDestination)
        
        let parametersNotif = ["title": "FriendsGo" ,
                               "body": name+" est intéressé "+event.titre,
                               "tokenn": tokenDestination] as [String : Any]
        
        Service.sharedInstance.postIt(parameters:parametersNotif as! [String : String], url:self.urlPushNotifications)
        
        
        // - Save the notification
        
        let parametersNotifications = ["InvitEventID": invitEvent.IDIE,
                                       "TypeN": "0",
                                       "Body": name+" est intéressé à votre événement "+event.titre,
                                       "DateNotif": getTodayString(),
                                        "IDUN": event.IdU] as [String : Any]
        
        Service.sharedInstance.postIt(parameters:parametersNotifications as! [String : String], url:self.urlAddNotification)
        
        
        
      // close()
        
        let mystoryboard:UIStoryboard = UIStoryboard(name:"Menu", bundle: nil)
        
        let ViewController = mystoryboard.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        
        self.navigationController?.pushViewController(ViewController, animated: true)
}

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func supprimerEventButton(_ sender: AnyObject) {
        
        let paras = ["IdInviteur": event.IdU ,
                     "IdInvite": userId,
                     "Etat" : "intéressé",
                     "IdEvent": event.idE
            ] as [String : Any]
        
        Service.sharedInstance.postItAny(parameters:paras, url:self.urlDeleteInvEvent)
        //close()
        
        let mystoryboard:UIStoryboard = UIStoryboard(name:"Menu", bundle: nil)
        
        let ViewController = mystoryboard.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        
        //ViewController.event = event
        
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //view.endEditing(true)
        self.removeAnimate()
        //self.view.removeFromSuperview()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    func show(vc:UIViewController) {
        vc.addChildViewController(self)
        vc.view.addSubview(self.view)
    }
    
    func close() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
}


extension Date {
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
}
