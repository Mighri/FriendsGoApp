//
//  PopOverMenu.swift
//  FriendsGo
//
//  Created by Design on 17/07/2018.
//  Copyright © 2018 Radhia Mighri. All rights reserved.
//

import UIKit
import SDWebImage



class  PopOverMenu: UIViewController {
    
 
    let urlUpdateActivePosition = MyClass.Constants.urlUpdateActivePosition
 
    let userId = UserDefaults.standard.string(forKey: "Saveid")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
    }
    
      @IBAction func dismiss(_ sender: UIButton) {
        close()
    }
        
     @IBAction func positionOn(_ sender: UIButton) {
        
        
        let parametersNotif = ["IdUserPosition": userId,
                               "ActivatePToPosition":"On"] as [String : Any]
        
        Service.sharedInstance.postIt(parameters:parametersNotif as! [String : String], url:self.urlUpdateActivePosition)
        
        }
    @IBAction func positionOff(_ sender: UIButton) {
        
        let parametersNotif = ["IdUserPosition": userId,
                               "ActivatePToPosition":"Off"] as [String : Any]
        
        Service.sharedInstance.postIt(parameters:parametersNotif as! [String : String], url:self.urlUpdateActivePosition)
                
                 }
    
    
    @IBAction func exit(_ sender: UIButton) {
                    
        let mystoryboard:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        
        let secondViewController = mystoryboard.instantiateViewController(withIdentifier: "LoginController") as! LogViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
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
    
 




