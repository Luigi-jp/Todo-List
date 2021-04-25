//
//  Task.swift
//  Todo-List
//
//  Created by 佐藤瑠偉史 on 2021/04/11.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var id : String = NSUUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var createAt = Date()
    @objc dynamic var updateAt = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
