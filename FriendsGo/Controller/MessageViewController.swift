//
//  MessageViewController.swift
//  FriendsGo
//
//  Created by Radhia Mighri on 06/03/2018.
//  Copyright © 2018 Radhia Mighri. All rights reserved.
//
 
import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase

 
class Channel:NSObject{
    var id:String?
    var name:String?
    init(id:String,name:String) {
        self.id = id
        self.name = name
    }
}
 
class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
 
    var channels = [Channel]()
    private lazy var channelRef = Database.database().reference().child("channels")
    private var channelrefHandle:DatabaseHandle?
 
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var friend : Friend!
    var friendd : Friend!
    var conv : Message!
 
    var FriendArray = [Friend]()
    var currentFriendArray = [Friend]() //update table
    let urlgetAmis = MyClass.Constants.urlgetAmis
   let urlGetChannels = MyClass.Constants.urlGetChannels
     let urlGetMessageReciever = MyClass.Constants.urlgetMessageReciever
    let urlGetConvReciever = MyClass.Constants.urlGetConvReciever
     let urlGetUsername = MyClass.Constants.urlGetUsername
    
    var searching: Bool! = false
    
    let userId = UserDefaults.standard.string(forKey: "Saveid")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        
        //self.table.reloadData()
        /*
        let p = ["IdU" : userId]
        print(userId)
        Service.sharedInstance.loadInfoAny(parameters: p, url: urlgetAmis) { (state, Objets) in
            if state {
                self.FriendArray = Objets!
                self.currentFriendArray = self.FriendArray
                //self.table.reloadData(
         )
                
                print("Objets")
            } else {
                print("nooo")
                
            }
        }
 */
        setUpSearchBar()
        searchBar.placeholder = "Rechercher"
  
        self.observeChannels()
    }
    
    
    func observeChannels(){
        channelrefHandle = channelRef.observe(DataEventType.childAdded, with: { (snapshot) in
            let data = snapshot.value as! NSDictionary
            if let name = data["name"] as? String{
                self.channels.append(Channel(id: snapshot.key, name: name))
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        })
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
        searchBar.endEditing(true)
        //searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
        // searchBar.showsCancelButton = true
    }
    /*
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
     searching = false
     searchBar.endEditing(true)
     //searchBar.showsCancelButton = false
     }
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.endEditing(true)
        //searchBar.showsCancelButton = false
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.title = "Messages"
         self.table.reloadData()
    }
   
    deinit {
        if let ref = channelrefHandle{
            channelRef.removeObserver(withHandle: ref)
        }
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
    
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    print(self.channels.count)
    
        return self.channels.count
    }
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = self.table.dequeueReusableCell(withIdentifier: "Cell") as! TableCell
        
        print(self.channels[indexPath.row].name!)
        
        print(userId)
        
      // print(self.channelRef.child(self.channels[indexPath.row].id!))

        let parameters = ["ChannelName": self.channels[indexPath.row].name!,
                          "senderID": userId]
        
        Service.sharedInstance.loadConversations(parameters:parameters, url:urlGetChannels) { (state, Objets) in
            if state {
                print(Objets!)
                print("Channel existe")
                print(self.channels[indexPath.row].name!)
                cell.Nom.text = self.channels[indexPath.row].name!
                //tableView.separatorStyle = .none
            }
            else
            {
                 print("Channel n'existe pas")
                /*
                print("££££££££££££££££££££££££££££££££££££££££££")
                print(indexPath.row)
                UserDefaults.standard.set(indexPath.row, forKey: "tagCell")
*/
                
               
                //self.channels.remove(at: indexPath.row)
                //self.table.deleteRows(at: [indexPath], with: .automatic)
                //cell.isHidden = true
                // cell.tag = indexPath.row
                
                let pp = ["ChannelName": self.channels[indexPath.row].name!,
                          "RecieverID": self.userId]
                
                Service.sharedInstance.loadConversations(parameters: pp, url: self.urlGetConvReciever) { (state, Objets) in
                    if state {
                       self.conv = Objets![0]
                        print(self.conv.senderID!)
                        let ppp = ["IdU": self.conv.senderID!]
                        Service.sharedInstance.loadInfoAny(parameters: ppp, url: self.urlGetUsername) { (state, Objets) in
                            if state {
                                self.friendd = Objets![0]
                                print(self.friendd.prenom+" "+self.friendd.Nom)
                                
                                cell.Nom.text = self.friendd.prenom+" "+self.friendd.Nom
                                
                                print("Message Reciever Name")
                            }
                            else {
                                print("no Message Reciever Name")
                            }
                        }
                    }
                    else
                    {
                        
                    }
                }
                
                
                print("indexPath.rowindexPath.rowindexPath.rowindexPath.rowindexPath.rowindexPath.row")
                print(indexPath.row)
                UserDefaults.standard.set(indexPath.row, forKey: "tagCell")
                print("Channel n'existe pas")
                //self.channels.remove(at: indexPath.row)
                //self.table.deleteRows(at: [indexPath], with: .automatic)
                //cell.isHidden = true
                // cell.tag = indexPath.row
            }
        }
        return cell
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let tagg = UserDefaults.standard.integer(forKey: "tagCell")
        
        print("¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨")
        print(tagg)
        var rowHeight:CGFloat = 0.0
        
        if(indexPath.row == tagg){
            rowHeight = 0.0
        }
        else{
            rowHeight = 55.0    //or whatever you like
        }
        return rowHeight
    }

   /*
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 80
     }
 
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let reciverId = String(describing :currentFriendArray[indexPath.row].id)
       // let recieverName = currentFriendArray[indexPath.row].prenom+" "+currentFriendArray[indexPath.row].Nom
       
        let channel = self.channels[indexPath.row]
        let view = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        view.channel = channel
        view.channelRef = self.channelRef.child(self.channels[indexPath.row].id!)
        self.navigationController?.pushViewController(view, animated: true)
    
    }

    @IBAction func addUser()
    {
        /*
            let alert = UIAlertController(title: "Add Channel", message: "Give Channel Name!!!", preferredStyle: .alert)
            alert.addTextField { (textfield) in
                textfield.placeholder = "Channel Name"
            }
            alert.addAction(UIAlertAction(title: "Create Channel", style: UIAlertActionStyle.default, handler: { (_) in
                if (alert.textFields?.first?.hasText)!{
                    self.createChannel(name: (alert.textFields?.first?.text!)!)
                }
            }))
            self.present(alert, animated: true, completion: nil)
         */
        
        let popOverVC = UIStoryboard(name: "MWAPopup", bundle: nil).instantiateViewController(withIdentifier: "addUserPopUp") as! addUserPopUp
        //popOverVC.event = event
        self.addChildViewController(popOverVC)
        //popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        //popOverVC.show(vc: self)
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentFriendArray = FriendArray.filter({ friend -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { searching = true
                   // table.reloadData()
                }
                return (friend.Nom+" "+friend.prenom).lowercased().contains(searchText.lowercased())
            default:
                return searching == false
            }
        })
        //table.reloadData()
    }
    
    /*
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentFriendArray = FriendArray.filter({ friend -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty {
                    searching = true
                currentFriendArray = FriendArray
                     table.reloadData()
                }
                return (friend.Nom+" "+friend.prenom).lowercased().contains(searchText.lowercased())
            default:
               // self.currentFriendArray = self.FriendArray
                //table.reloadData()
                return searching == false
                
            }
        })
        table.reloadData()
    }
 */
}


 


