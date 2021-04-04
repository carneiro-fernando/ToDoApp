//
//  ViewController.swift
//  ToDoApp
//
//  Created by Fernando Carneiro on 28/12/20.
//

import UIKit
import GoogleMobileAds

class toDoViC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var toDoItemText : UITextField!
    @IBOutlet weak var prioritySegment : UISegmentedControl!
    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var banner: GADBannerView!
    
    
    
    var todos = Array<Todo>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTable.dataSource = self
        todoTable.delegate = self
        
        getTodos()
    
        //Google Ads
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = self
        banner.load(GADRequest())
    }
    
    func getTodos() {
        
        NetworkService.shared.getTodos(onSuccess: { (todos) in
            self.todos = todos.items
            self.todoTable.reloadData()
        }) { (errorMessage) in
            //show alert to user
            debugPrint(errorMessage)
        }
    }
    
    @IBAction func addToDo (_ sender:Any){
       guard let todoItem = toDoItemText.text else {
            debugPrint("Não conseguiu ler o textfield")//return Error message
            return
        }
        
        let todo = Todo(item: todoItem, priority: prioritySegment.selectedSegmentIndex)
        print("Os dados retirados foram: \(todo)")
        
        NetworkService.shared.addTodo(todo: todo, onSuccess: { (todos) in
            self.toDoItemText.text = "" //Clean Text Box
            self.todos = todos.items
            print(self.todos)
            self.todoTable.reloadData()
        }) { (errorMessage) in
                debugPrint(errorMessage)
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? TodoCell {
            cell.updateCell(todo: todos[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}
