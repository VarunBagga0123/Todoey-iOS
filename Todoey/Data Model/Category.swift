//
//  Category.swift
//  Todoey
//
//  Created by Varun Bagga on 26/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Category: Object{
    
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
//  let items = List<Item>()
}
