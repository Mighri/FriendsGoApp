//
//  ActivatePositionTo.swift
//  FriendsGo
//
//  Created by Design on 16/07/2018.
//  Copyright © 2018 Radhia Mighri. All rights reserved.
//

import Foundation
import ObjectMapper

class  ActivatePositionTo: NSObject, Mappable{
 
    var IdAP: String!
    var IdUser: String!
    var ActivatePTo: String!
    var IdFriend: String!
  
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        IdAP    <- map["IdAP"]
        IdUser     <- map["IdUser"]
        ActivatePTo    <- map["ActivatePTo"]
        IdFriend   <- map["IdFriend"]
    }
    
}
