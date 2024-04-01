//
//  Notes.swift
//  EchoNotes
//
//  Created by ANSH on 31/03/24.
//

import Foundation
import RealmSwift

class Notes : Object{
    
    @objc dynamic var body : String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
