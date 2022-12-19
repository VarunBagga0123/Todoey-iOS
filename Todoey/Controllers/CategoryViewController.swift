//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Varun Bagga on 26/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
//import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoriesArray : Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        loadCategories()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .cyan
    }
    //MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category  = categoriesArray?[indexPath.row]{
            cell.textLabel?.text = category.name
            if let color = UIColor(hexString: category.colour){
                cell.backgroundColor = color
//                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
            }
          
        }
       
         return cell
        
    }
    //MARK: - TableView Delegate Methods
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            performSegue(withIdentifier: "goToItems", sender: self)
            
            
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categoriesArray?[indexPath.row]
            }
        }
            
//MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            self.saveCategories(category: newCategory)
           
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
//MARK: - Data manipulation
    func saveCategories(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories (){
        
         categoriesArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoriesArray?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print(error)
            }
        }
    }
    
}

