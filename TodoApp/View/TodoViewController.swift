//
//  ViewController.swift
//  TodoApp
//
//  Created by Амиль Гусейнов on 24.02.25.
//

import UIKit

class TodoViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = TodoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    @objc private func addTask(){
        let alert = UIAlertController(title: "New Task",message:nil, preferredStyle: .alert)
        
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty{
                self?.viewModel.addNewTask(title: text)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
        
    

}

extension TodoViewController: TodoViewModelDelegate {
    func didUpdateTasks(_ task: [Task]) {
        tableView.reloadData()
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasksCount
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
                guard let self = self else { return }
                let task = viewModel.task(at: indexPath.row)
                viewModel.deleteTask(task: task)
                completion(true)
            }
            
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .red
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = viewModel.task(at: indexPath.row)
        cell.textLabel?.text = task.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        
            let task = viewModel.task(at: indexPath.row)
            
            let alert = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.text = task.title
            }
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                if let newText = alert.textFields?.first?.text, !newText.isEmpty {
                    self?.viewModel.updateTask(task: task, newTitle: newText)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alert, animated: true)
            
        }
    }
