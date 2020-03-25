
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor=UIColor(red:245.0/255.0,green:79.0/255.0,blue:80.0/255.0,alpha:1.0)
        UINavigationBar.appearance().tintColor=UIColor(red:245.0/255.0,green:79.0/255.0,blue:80.0/255.0,alpha:1.0)
        let color=UIColor(red:245.0/255.0,green:79.0/255.0,blue:80.0/255.0,alpha:1.0)
        let font=UIFont(name:"Roboto-Medium",size:18)
        let attributes: (AnyObject) = (
            NSFontAttributeName:font,
            NSForegroundColorAttributeName:color) as (AnyObject)
        UINavigationBar.appearance().titleTextAttributes = attributes as? [NSAttributedString.Key : Any]
      //  UIApplication.s
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Note_Taking_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
           
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
              
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
