//
//  ViewController.swift
//  todo-server
//
//  Created by Danylo Kushlianskyi on 10.05.2022.
//

import UIKit

class ToDoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var priritySegment: UISegmentedControl!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var todos: [ToDo] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self // dont forget
        tableView.dataSource = self // dont forget
        getTodos()
        
    }
    
    func getTodos(){
        NetworkService.shared.getToDos(
            // on success closure
            {(todos) in
            self.todos = todos.items
            self.tableView.reloadData()},
            // on error closure
            {(errorMessage) in
                self.createAlert(description: errorMessage)
            }
        )
    }
    
    func addTodos(){
        guard let todoItem = txtField.text else{
            createAlert(description: "You must enter a todo item")
            return
        }
        
        let item = ToDo(item: todoItem, priority: priritySegment.selectedSegmentIndex)
    
        NetworkService.shared.addToDo(todo:item) { todos in
            self.txtField.text = ""
            self.todos = todos.items
            self.tableView.reloadData()
        } _: { errorMessage in
            self.createAlert(description: errorMessage)
        }

    }
    
    func deteteTodos(item: ToDo){
        NetworkService.shared.deleteTodos(todo:item) { todos in
            self.todos = todos.items
            self.tableView.reloadData()
        } _: { errorMessage in
            self.createAlert(description: errorMessage)
        }
    }
    
    @IBAction func addTaskBtnPressed(_ sender: Any) {
        addTodos()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoCell {
            cell.updateCell(todo: todos[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove", handler:
        {(_,_,comletionHandler) in
            comletionHandler(true)
            self.deteteTodos(item:self.todos[indexPath.row])
        })
        deleteAction.backgroundColor = UIColor.red
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    
    func createAlert(description: String){
        let alertError = UIAlertController(title: "Networking Error", message: description, preferredStyle: .alert)
        
        alertError.addAction(UIAlertAction(title: "Understood :( ", style: .default, handler: nil))
        
        self.present(alertError, animated: true, completion: nil)
    }
    

}

