//
//  Comment.swift
//  Sentiment
//
//  Created by Skip Wilson on 9/11/14.
//  Copyright (c) 2014 Skip Wilson. All rights reserved.
//

import Foundation

class Comment {
    var body = ""
    var commentID = 0
    var ownerRep = 0
    var ownerName = ""

    init(body:String, commentID:Int, ownerRep:Int, ownerName:String){
        self.body = body
        self.commentID = commentID
        self.ownerRep = ownerRep
        self.ownerName = ownerName
    }
}