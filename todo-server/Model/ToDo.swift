//
//  ToDo.swift
//  todo-server
//
//  Created by Danylo Kushlianskyi on 10.05.2022.
//

import Foundation

struct ToDoss: Codable{
    let items: [ToDo]
}

struct ToDo: Codable{
    let item: String
    let priority: Int
}
