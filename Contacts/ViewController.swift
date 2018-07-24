//
//  ViewController.swift
//  Google Contacts Viewer
//
//  Created by Kalyan Vishnubhatla on 12/13/16.
//
//

import UIKit
import Foundation
import GoogleSignIn
import CoreData
import SDWebImage
import CRToast

class ViewController: UITableViewController, GIDSignInUIDelegate, UINavigationControllerDelegate {
 let urlgetContacts = MyClass.Constants.urlgetContacts
    let userId = UserDefaults.standard.string(forKey: "Saveid")!
    let urlRegisterContact = MyClass.Constants.urlRegisterContact
    var friend : Friend!
    var correspondance : Correspondance!
    var FriendArray = [Friend]()
    var correspondances = [Correspondance]()
    let urlUserContact = MyClass.Constants.urlUserContact
    let urlImportContactsFBG = MyClass.Constants.urlImportContactsFBG
    let urlgetCorrespondance = MyClass.Constants.urlgetCorrespondance
    
    let animator = TransitionAnimator()
    static let cacheName: String? = "ViewControllerCacheName"
    private var _fetchedResultsController: NSFetchedResultsController<GoogleContact>?
    private var fetchedResultsController: NSFetchedResultsController<GoogleContact> {
        get {
            if (_fetchedResultsController == nil) {
                let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = delegate.persistentContainer.viewContext
                
                let query = NSFetchRequest<GoogleContact>(entityName: "GoogleContact")
                query.sortDescriptors = [
                    NSSortDescriptor(key: "name", ascending: true),
                    NSSortDescriptor(key: "email", ascending: true),
                    NSSortDescriptor(key: "primaryPhoneNumber", ascending: true)
                ]
                
                _fetchedResultsController = NSFetchedResultsController(fetchRequest: query, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: ViewController.cacheName)
                _fetchedResultsController?.delegate = FetchDelegate(tableView: self.tableView)
            }
            return _fetchedResultsController!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Contacts"
        GIDSignIn.sharedInstance().uiDelegate = self
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: DataChanged), object: nil)
        
        self.navigationController?.delegate = self
        self.setBarButtonItems()
    }
    
    func setBarButtonItems() {
        // Set the bar button items
        let token = UserDefaults.standard.string(forKey: UserAccessToken)
        if token == nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(signIn))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "retour", style: .plain, target: self, action: #selector(backk))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        }
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    @objc func signIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
 
    
    @objc func backk() {
        
        
        print("*********************************************")
        let mystoryboard:UIStoryboard = UIStoryboard(name:"Menu", bundle: nil)
        
        let ViewController = mystoryboard.instantiateViewController(withIdentifier: "ImportViewController") as! ImportViewController
        self.navigationController?.present(ViewController, animated: true, completion: nil)
        
    }
    
    @objc func signOut() {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            GIDSignIn.sharedInstance().signOut()
            
            UserDefaults.standard.removeObject(forKey: UserAccessToken)
            UserDefaults.standard.synchronize()
            
            let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            delegate.clearCoreDataStore()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: DataChanged), object: nil)
            
            alert.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh() {
        let options = [
            kCRToastTextKey: "Refreshing data ...",
            kCRToastTextAlignmentKey : kCAAlignmentCenter,
            kCRToastBackgroundColorKey : UIColor(hex: "BC2869"),
            kCRToastAnimationInTypeKey : CRToastAnimationType.gravity,
            kCRToastAnimationOutTypeKey : CRToastAnimationType.gravity,
            kCRToastAnimationInDirectionKey : CRToastAnimationDirection.left,
            kCRToastAnimationOutDirectionKey : CRToastAnimationDirection.right
            ] as [String : Any]
        CRToastManager.showNotification(options: options, completionBlock: nil)
        
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.contactsHandler.loadContacts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadData() {
        self.setBarButtonItems()
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: ViewController.cacheName)
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error as NSError {
            NSLog("Unresolved error %@", [error.localizedDescription])
            exit(-1)
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections?[section] as NSFetchedResultsSectionInfo!
        if sectionInfo == nil {
            return 0
        }
        return sectionInfo!.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            let CellIdentifier = "ViewControllerTableViewCell"
            var cell: ContactCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? ContactCell
            if (cell == nil) {
                cell = ContactCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: CellIdentifier)
                cell?.selectionStyle = UITableViewCellSelectionStyle.gray
                cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell?.accessoryType = .disclosureIndicator
            }
            return cell!
        } ()
        
        let doc: GoogleContact = self.fetchedResultsController.object(at: indexPath as IndexPath)
        if doc.name != nil {
            cell.textLabel?.text = doc.name
            
            
            print(doc.name!)
            
        } else if doc.email != nil {
            cell.textLabel?.text = doc.email
            
            
            print(doc.email!)
            
        } else if doc.numbers!.count > 0 {
            let number = doc.numbers?.object(at: 0) as! PhoneNumber
            cell.textLabel?.text = number.number
        } else {
            cell.textLabel?.text = "N/A"
        }
        
        if doc.url != nil {
            cell.imageView!.sd_setImage(with: URL(string: doc.url!), placeholderImage:UIImage(named:"contacts.png")!)
            
          print(doc.url!)
            
            
        } else {
            cell.imageView!.image = UIImage(named:"contacts.png")
        }
        
        /*
        
      if doc.name != nil {
       
        let pr = ["Nom": doc.name!,
                  "Prenom": doc.email!,
                  "photoURL": doc.url!,
                  "origine": "Google",
                  "idContact": self.userId]
        
        Service.sharedInstance.postIt(parameters:pr , url:self.urlRegisterContact)
        
        }
        else
      {
        let pr = ["Nom": doc.email!,
                  "Prenom": doc.email!,
                  "photoURL": doc.url!,
                  "origine": "Google",
                  "idContact": self.userId]
        
        Service.sharedInstance.postIt(parameters:pr , url:self.urlRegisterContact)
        
        }
       
       */
        
        
        
        
         
         let p = ["idU" : userId]
         Service.sharedInstance.loadInfoAny(parameters: p, url: urlgetContacts) { (state, Objets) in
         if state {
         
         self.FriendArray = Objets!
         
         for i in 0...self.FriendArray.count-1 {
         self.friend = Objets![i]
         
         
         let pp = ["IdUkjk" : self.userId, "idContacttt" : self.friend.idc]
         
         Service.sharedInstance.loadCorrespondance(parameters: pp as! [String : String], url: self.urlgetCorrespondance) { (state, Objets) in
         if state {
         
         print("déjà importé")
         
         } else {
         let params = [
         "idU": self.userId,
         "idContact": self.friend.idc]
         
         Service.sharedInstance.postIt(parameters:params as! [String : String] , url:self.urlUserContact)
         
         
         if doc.name != nil {
         
         let pr = ["Nom": doc.name!,
         "Prenom": doc.email!,
         "photoURL": doc.url!,
         "origine": "Google",
         "idContact": self.userId]
         
         Service.sharedInstance.postIt(parameters:pr , url:self.urlRegisterContact)
         
         }
         else
         {
         let pr = ["Nom": doc.email!,
         "Prenom": doc.email!,
         "photoURL": doc.url!,
         "origine": "Google",
         "idContact": self.userId]
         
         Service.sharedInstance.postIt(parameters:pr , url:self.urlRegisterContact)
         
         }
         
         print("Objets")
         print("nooo")
         }
         }
         }
         
         } else {
         print("nooo")
         }
         }
         
         
      
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let doc: GoogleContact = self.fetchedResultsController.object(at: indexPath as IndexPath)
        let controller = ViewContactViewController(coreDataId: doc.objectID)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == UINavigationControllerOperation.push) {
            return self.animator
        }
        return nil
    }
}
