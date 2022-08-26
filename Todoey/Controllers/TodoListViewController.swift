//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var selectedCategory :Category?{
        didSet{
            loadItem()
        }
    }
    var items = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        To Delete Items
        
//        context.delete(items[indexPath.row])
//        items.remove(at: indexPath.row)
        items[indexPath.row].done = !items[indexPath.row].done
        
        saveItem()
        
        tableView.reloadData()
        
        // This code is shifted to func(cellForRowAt)
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
// ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //what will happen once the user clicks the add item button on our UIalert
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.items.append(newItem)
            self.saveItem()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem(){
        
         do{
           try context.save()
         } catch {
           print("Error saving context \(error)")
         }
         
         self.tableView.reloadData()
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
              request.predicate = compoundPredicate
        }else{
            request.predicate = categoryPredicate
        }
        do{
          items = try context.fetch(request)
        }catch{
            print("Error fetching data from contest \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension TodoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let itemPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true )
        request.sortDescriptors = [sortDescriptor]
        
        
        
        loadItem(with: request,predicate: itemPredicate)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
