//
//  ViewController.swift
//  Todo-List
//
//  Created by 佐藤瑠偉史 on 2021/04/06.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var todoList: [Task] = []
    var taskTextField = UITextField()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadTask()
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "タスクを追加", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (taskTextField: UITextField) in
            taskTextField.placeholder = "新規タスク"
            self.taskTextField = taskTextField
        }
        let confirmAction = UIAlertAction(title: "追加する", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            if let title = self.taskTextField.text {
                try! self.realm.write {
                    self.realm.add(Task(value: ["title": title]))
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
        todoList = []
        let tasks = self.realm.objects(Task.self)
        for task in tasks {
            self.todoList.append(task)
        }
    }
}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, sourceView, completionHandler) in
            let deleteTask = self.realm.objects(Task.self).filter("id == '\(self.todoList[indexPath.row].id)'")
            try! self.realm.write {
                self.realm.delete(deleteTask)
            }
            self.todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = todoList[indexPath.row]
        let alert = UIAlertController(title: "タスクを編集", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            self.taskTextField = textField
            self.taskTextField.placeholder = task.title
            self.taskTextField.text = task.title
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if self.taskTextField.text != "" {
                try! self.realm.write {
                    task.title = self.taskTextField.text!
                }
                self.loadTask()
                self.tableView.reloadData()
            }
            
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row].title
        cell.setEditing(true, animated: false)
        return cell
    }
}

