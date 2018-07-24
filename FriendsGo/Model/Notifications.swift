//
//  Notification.swift
//  FriendsGo
//
//  Created by Design on 13/07/2018.
//  Copyright © 2018 Radhia Mighri. All rights reserved.
//

import Foundation
import ObjectMapper

class  Notifications: NSObject, Mappable{
   
    var IdN: String!
    var InvitEventID: String!
    var InvitFGID: String!
    var TypeN: String!
    var Body: String!
    var DateNotif: String!
    var IDUN: String!
    
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        IdN    <- map["IdN"]
        InvitEventID     <- map["InvitEventID"]
        InvitFGID    <- map["InvitFGID"]
        TypeN   <- map["TypeN"]
        Body   <- map["Body"]
        DateNotif   <- map["DateNotif"]
        IDUN   <- map["IdUN"]
    }
    
}
