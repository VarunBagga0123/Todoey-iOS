//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Varun Bagga on 26/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categoriesArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadCategories()
    }
    //MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoriesArray[indexPath.row].name

        return cell
        
    }
    //MARK: - TableView Delegate Methods
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            performSegue(withIdentifier: "goToItems", sender: self)
            
            
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categoriesArray[indexPath.row]
            }
        }
            
//MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoriesArray.append(newCategory)
            self.saveCategories()
           
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
//MARK: - Data manipulation
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories (){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoriesArray = try context.fetch(request)
        }catch{
            print("Error: \(error)")
        }
        tableView.reloadData()
    }
}
