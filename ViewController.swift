//
//  ViewController.swift
//  Note-Taking App
//
//  Created by fana fili on 3/21/20.
//  Copyright © 2020 fana fili. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate {

    @IBOutlet weak var noteInfoView: UIView!
   
    @IBOutlet weak var noteImageViewview: UIView!
    
    @IBOutlet weak var noteNameLabel: UITextField!
    
    @IBOutlet weak var noteDescriptionLabel: UITextView!
    
    @IBOutlet weak var noteImageView: UIImageView!
    var managedObjectContext: NSManagedObjectContext?{
        return(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    var notesFetchedResultsController: NSFetchedResultsController<Note>!
    var notes = [Note]()
    var note: Note?
    var isExisting = false
    var indexPath: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let note = note{
            noteNameLabel.text = note.noteName
            noteDescriptionLabel.text = note.noteDescription
            noteImageView.image = UIImage(data: note.noteImage! as Data)
        }
        if noteNameLabel.text != ""{
            isExisting = true
        }
       noteNameLabel.delegate = self
        noteDescriptionLabel.delegate = self
        noteInfoView.layer.shadowColor = UIColor(red:0/255.0,green: 0/255.0,blue: 0/255.0, alpha: 1.0).cgColor
        noteInfoView.layer.shadowOffset = CGSize(width: 0.76, height: 0.75)
        noteInfoView.layer.shadowRadius = 1.5
        noteInfoView.layer.shadowOpacity = 0.2
        noteInfoView.layer.cornerRadius = 2
       noteImageViewview.layer.shadowColor = UIColor(red:0/255.0,green: 0/255.0,blue: 0/255.0, alpha: 1.0).cgColor
        noteImageViewview.layer.shadowOffset = CGSize(width: 0.76, height: 0.75)
        noteImageViewview.layer.shadowRadius = 1.5
        noteImageViewview.layer.shadowOpacity = 0.2
       noteImageViewview.layer.cornerRadius = 2
       noteImageView.layer.cornerRadius = 2
       noteNameLabel.setBottomBorder()
            }
    func saveToCoreData(completion: @escaping () -> Void){
        managedObjectContext!.perform {
            do{
                try self.managedObjectContext?.save()
                completion()
                print ( "Note save to ore data")
            }
            catch let error {
                print("coudnot save to core data:\(error.localizedDescription)")
            }
        }
    }

    @IBAction func pickImageButtonWasPressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
    let alertController = UIAlertController(title: "add image",message: "choose From",preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "camera", style: .default) {
            (action) in pickerController.sourceType = .camera
            self.present(pickerController,animated: true,completion: nil)
        }
            let photoliberaryAction = UIAlertAction(title: "photo Liberary", style: .default){
                (action) in pickerController.sourceType = .photoLibrary
                self.present(pickerController,animated: true,completion: nil)
                
            }
            
                let savedPhotoAction = UIAlertAction(title: "saved photo album",style: .default){
                    (action) in pickerController.sourceType = .savedPhotosAlbum
                    self.present(pickerController,animated: true,completion: nil)
                }
        let cancelAction = UIAlertAction(title: "Cancel",style: .destructive,handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoliberaryAction)
        alertController.addAction(savedPhotoAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.noteImageView.image = image
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //save
    
    @IBAction func saveButtonWasPressed(_ sender: UIBarButtonItem) {
        if noteNameLabel.text == "" || noteNameLabel.text == "NOTE NAME" || noteDescriptionLabel.text == "" || noteDescriptionLabel.text == "Note Description..."{
           let alertController  = UIAlertController(title: "MissingInformation", message: "you left one or more fields empty.please make sure all fields are filled befer attempting to save.", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction(title: "dissmis", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            if(isExisting == false){
                let noteName = noteNameLabel.text
                let noteDescription = noteDescriptionLabel.text
                if let moc = managedObjectContext{
                  let note = Note(context: moc)
                    if  self.noteImageView.image != nil{
                    if let data  = self.noteImageView.image!.jpegData(compressionQuality: 0.1){
                        note.noteImage = data as NSData as Data}
                    }
                    note.noteName = noteName
                    note.noteDescription = noteDescription
                    saveToCoreData(){
                        let isPresentingInAddNoteMode = self.presentingViewController is UINavigationController
                        if  isPresentingInAddNoteMode {
                            self.dismiss(animated: true, completion: nil)
                        }
                        else{
                            self.navigationController!.popViewController(animated: true)
                        }
                    }
                }
                
            }
            else if (isExisting == true){
                let note = self.note
                let manegedObject = note
                manegedObject!.setValue(noteNameLabel.text, forKey: "noteName")
                manegedObject!.setValue(noteDescriptionLabel.text, forKey: "noteDescription")
                
                if  let data = self.noteImageView.image!.jpegData(compressionQuality: 0.1){
                    manegedObject!.setValue(data, forKey: "noteImage")
                }
                do{
                    try context.save()
                    let isPresentingInAddNoteMode = self.presentingViewController is UINavigationController
                    if isPresentingInAddNoteMode{self.dismiss(animated: true, completion: nil)
                        
                    }
                    else{
                        self.navigationController!.popViewController(animated: true)
                    }
                    
            }
                catch{
                    print("Failed to Update Existing Note.")
                }
        
                
            }
        }
        UserDefaults.standard.set(noteNameLabel.text, forKey: "noteName")
        UserDefaults.standard.set(noteDescriptionLabel.text, forKey: "noteDescription")
        UserDefaults.standard.set(Data(), forKey: "noteImage")
    }
    
   
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddNoteMode = presentingViewController is UINavigationController
        if isPresentingInAddNoteMode{
            dismiss(animated: true, completion: nil)
        }
        else{
            navigationController!.popViewController(animated: true)
        }
    
}
//textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
}
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(
            text == "\n"){
                
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "Note Description..."){
            textView.text = ""
        }
    
    }}
    extension UITextField{
        func setBottomBorder()
        {
          self.borderStyle = .none
            self.layer.backgroundColor = UIColor.white.cgColor
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor(red: 245.0/255.0, green: 79.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 0.0
            
        }
        
          
        
}

