//
//  ToDoCellTableViewCell.swift
//  todo-server
//
//  Created by Danylo Kushlianskyi on 10.05.2022.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var proiorityView: UIView!
    
    func updateCell(todo: ToDo){
        itemLabel.text = todo.item
        
        switch todo.priority {
        case 0:
            proiorityView.backgroundColor = UIColor.yellow
        case 1:
            proiorityView.backgroundColor = UIColor.orange
        default:
            proiorityView.backgroundColor = UIColor.red
        }
    }
    

}
