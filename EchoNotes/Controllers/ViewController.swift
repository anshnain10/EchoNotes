//
//  ViewController.swift
//  EchoNotes
//
//  Created by ANSH on 21/03/24.
//

import UIKit
import RealmSwift



class ViewController : SwipeTableViewController {

    let realm = try! Realm()
    var categories:Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadCategory()
        tableView.rowHeight = 80.0
        tableView.separatorColor = .none
        
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else{
            fatalError("error")}
        
        navBar.backgroundColor = UIColor(named: "1D9BF6")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            
//
        }
        return cell
    }
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print(error)
            }
            
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Note", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Note", style: .default){ (action) in
            
            let newItem = Category()
            if ((textField.text?.isEmpty) != nil){
                newItem.name = textField.text ?? ""

            }
            self.save(category : newItem)
            
            
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new note"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true,completion: nil)
    }
    
    //MARK: - delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NoteViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    func save(category : Category ){
        
        do{
            try realm.write{
                realm.add(category)
            }
            
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    func loadCategory(){
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
}
extension ViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategory()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
        
    }
    
}

