//
//  ViewController.swift
//  CoreData TODOList Demo
//
//  Created by Adwait Barkale on 15/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblViewTodoList: UITableView!
    
    // MARK: - Variable Declarations
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var arrItems = [TODOListItem]()

    // MARK: - View's Initialization Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        configureTableView()
    }
    
    // MARK: - User Defined Functions
    
    func setupUI() {
        title = "TODO List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddTapped))
    }
    
    @objc func btnAddTapped() {
        let alert = UIAlertController(title: "New Item", message: "Enter Item Name", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let newItem = field.text, !newItem.isEmpty else {
                self?.showAlert(title: "Empty Name", message: "Item Name cannot be empty")
                return
            }
            self?.createItem(name: newItem)
        }))
        
        self.present(alert, animated: true)
    }
    
    func configureTableView() {
        tblViewTodoList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblViewTodoList.delegate = self
        tblViewTodoList.dataSource = self
        //tblViewTodoList.separatorStyle = .none
        self.getAllItems()
    }

    func getAllItems() {
        do {
            arrItems = try context.fetch(TODOListItem.fetchRequest())
            tblViewTodoList.reloadData()
        } catch let err {
            print("Error Fetching Items: \(err)")
        }
    }
    
    func createItem(name: String) {
        let newItem = TODOListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
            self.getAllItems()
        } catch let err {
            print("Error Creating Item: \(err)")
        }

    }
    
    func deleteItem(item: TODOListItem) {
        context.delete(item)
        do {
            try context.save()
            self.getAllItems()
        } catch let err {
            print("Error Creating Item: \(err)")
        }
    }
    
    func updateItem(item: TODOListItem, newName: String) {
        item.name = newName
        do {
            try context.save()
            self.getAllItems()
        } catch let err {
            print("Error Creating Item: \(err)")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let itemData = arrItems[indexPath.row]
        cell.textLabel?.text = itemData.name ?? ""
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = arrItems[indexPath.row]
        let actionSheet = UIAlertController(title: "Options", message: "Select operation to be performed", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Enter Item Name", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = selectedItem.name ?? ""
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newItem = field.text, !newItem.isEmpty else {
                    self?.showAlert(title: "Empty Name", message: "Item Name cannot be empty")
                    return
                }
                self?.updateItem(item: selectedItem, newName: newItem)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alert, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteItem(item: selectedItem)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(actionSheet, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
