//
//  Task.swift
//  Todo-List
//
//  Created by 佐藤瑠偉史 on 2021/04/11.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var contents = ""
    @objc dynamic var createTime = 0
}
