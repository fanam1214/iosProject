

import UIKit
import CoreData

class noteTableViewController: UITableViewController {
      var notes = [Note]()
    var managedObjectContext: NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor(red:245.0/255.0,green:79.0/255.0,blue:80.0/255.0,alpha:1.0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retriveNotes();
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell

        let note: Note = notes[indexPath.row]
       cell.configureCell(note: note)
        cell.backgroundColor = UIColor.clear

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      
        return true
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    
    tableView.reloadData()
}
func retriveNotes() {
    managedObjectContext.perform{
        self.fetchNotesFromCoreData { (notes) in
            if let notes = notes{
                self.notes = notes
                self.tableView.reloadData()
                
            }
        }
        
        
    }
          
    }
 
   
   func fetchNotesFromCoreData(completion: @escaping ([Note]?) -> Void){
        
        managedObjectContext .perform{
            var notes = [Note]()
        let requist: NSFetchRequest<Note> = Note.fetchRequest()
        do{
            notes = try self.managedObjectContext .fetch(requist)
            completion(notes)
        }
        catch{
            print("Could not from Coredata:\(error.localizedDescription)")
        }
        }
    }
  


}
