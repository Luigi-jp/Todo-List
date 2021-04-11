//
//  ViewController.swift
//  Todo-List
//
//  Created by 佐藤瑠偉史 on 2021/04/06.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var todoList: [String] = []
    var taskTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Todoを追加", message: "追加するタスクを入力してください。", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (taskTextField: UITextField) in
            taskTextField.placeholder = "タスクを入力してください。"
            self.taskTextField = taskTextField
        }
        let confirmAction = UIAlertAction(title: "追加", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            if let task = self.taskTextField.text {
                self.todoList.append(task)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

