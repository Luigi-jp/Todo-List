//
//  ViewController.swift
//  Todo-List
//
//  Created by 佐藤瑠偉史 on 2021/04/06.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var todoList: [Task] = []
    var taskTextField = UITextField()
    let realm = try! Realm()
    let time = Date().timeIntervalSince1970
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadTask()
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Todoを追加", message: "追加するタスクを入力してください。", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (taskTextField: UITextField) in
            taskTextField.placeholder = "タスクを入力してください。"
            self.taskTextField = taskTextField
        }
        let confirmAction = UIAlertAction(title: "追加", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            if let contents = self.taskTextField.text {
                self.todoList = []
                try! self.realm.write {
                    self.realm.add(Task(value: ["contents": contents, "createTime": Int(Date().timeIntervalSince1970)]))
                }
                self.loadTask()
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    func loadTask() {
        let tasks = self.realm.objects(Task.self)
        for task in tasks {
            self.todoList.append(task)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row].contents
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deleteTask = realm.objects(Task.self).filter("createTime=\(todoList[indexPath.row].createTime)")
        try! realm.write {
            realm.delete(deleteTask)
        }
        todoList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
