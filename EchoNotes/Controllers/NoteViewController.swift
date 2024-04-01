//
//  NoteViewController.swift
//  EchoNotes
//
//  Created by ANSH on 22/03/24.
//

import UIKit
import RealmSwift

class NoteViewController: UIViewController, UITextViewDelegate , UITextFieldDelegate{
    
    @IBOutlet weak var textView: UITextView!
    var toDoNotes : Results<Notes>?
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet{
            loadNotes()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isScrollEnabled = true
        textView.frame = CGRect(x:10,y:200,width: 350,height: 800)
        textView.textColor = UIColor.label
        textView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadNotes()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        textView.resignFirstResponder()
//        saveNote()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveNote()
    }
    
   
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        saveNote()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        saveNote()
    }
    
    
    
    //MARK: - Data Manipulation
    
    func loadNotes() {
        
//            if let selectedCategory = selectedCategory {
//                //                    toDoNotes = selectedCategory.items.sorted(byKeyPath: "", ascending: true)
//                
//                // Check if toDoNotes is not nil and has at least one element before accessing its properties
//                if let lastNote = toDoNotes?.last {
//                    textView.text = lastNote.body
//                } else {
//                    // Handle case where there are no notes
//                    guard let textView = textView else {
//                        fatalError("textView is nil")
//                    }
//                    textView.text = ""
//                }
//            }
        if let currentCategory = selectedCategory {
            toDoNotes = currentCategory.items.sorted(byKeyPath: "body", ascending: true)
            textView?.text = toDoNotes?.first?.body
            
        }
        
        
        
    }
    
    
    func saveNote() {
        guard let currentNote = selectedCategory else {
            print("Error: selectedCategory is nil")
            return
        }
        
        do {
            try realm.write {
                let newNote = Notes()
                newNote.body = textView.text ?? "write something"
                //                        newNote.dateCreated = Date()
                currentNote.items.append(newNote)
                print("Saved successfully: \(newNote.body)")
            }
        } catch {
            print("Error saving note body: \(error)")
        }
        
    }
    
}
