//
//  Category.swift
//  EchoNotes
//
//  Created by ANSH on 31/03/24.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    
    let items = List<Notes>()
}
