//
//  ViewController.swift
//  HitList
//
//  Created by Xavi Moll on 05/12/2016.
//  Copyright © 2016 Xavi Moll. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
	
	
	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var tableView: UITableView!
	
	var people = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.tintColor = UIColor.orange
		navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.orange]
		
		configureTable()
		
		tableView.dataSource = self
		
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
		do {
			people = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Coudn't fetch \(error), description: \(error.userInfo)")
		}
	}

	@IBAction func addPerson(_ sender: UIBarButtonItem) {
		addPersonAlertController()
	}
	
	func configureTable() {
		title = "People List"
		image.image = UIImage(named: "apple")
		image.contentMode = .scaleAspectFill
		tableView.separatorInset.left = 5
		tableView.separatorInset.right = 5
		tableView.separatorColor = UIColor.orange.withAlphaComponent(0.2)
		tableView.backgroundColor = UIColor.black
		tableView.allowsSelection = false
	}
	
	func addPersonAlertController() {
		let alertController = UIAlertController(title: "Add Person", message: "Type first and last name of your friend", preferredStyle: .alert)
		let saveAlert = UIAlertAction(title: "Save", style: .default) { (action) in
			guard let textField = alertController.textFields?.first,
				let friendName = textField.text else {
					return
			}
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
			let managedContext = appDelegate.persistentContainer.viewContext
			let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
			let person = NSManagedObject(entity: entity, insertInto: managedContext)
			person.setValue(friendName, forKey: "name")
			
			do {
				try managedContext.save()
				self.people.append(person)
			} catch let error as NSError {
				print("Could not save \(error), \(error.userInfo)")
			}
			
			self.tableView.reloadData()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			return
		}
		alertController.addTextField { (textField) in
			textField.placeholder = "Friend name"
		}
		alertController.addAction(cancelAction)
		alertController.addAction(saveAlert)
		
		present(alertController, animated: true, completion: nil)
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return people.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let person = people[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.backgroundColor = UIColor.black
		cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
		cell.textLabel?.textColor = UIColor.orange.withAlphaComponent(0.75)
		cell.textLabel?.text = person.value(forKey: "name") as? String
		cell.textLabel?.textAlignment = .center
		cell.separatorInset.left = 5
		cell.separatorInset.right = 5
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		let nameToRemove = cell!.textLabel!.text
		let removedRow = indexPath.row
		people.remove(at: removedRow)
		
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContex = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
		fetchRequest.predicate = NSPredicate(format: "name == %@", nameToRemove!)
		
		do {
			let result = try managedContex.fetch(fetchRequest)
			if result.count > 0 {
				let managedObjectToRemove = result.first
				managedContex.delete(managedObjectToRemove!)
				print("\(nameToRemove! as String) removed")
			}
		} catch let error as NSError {
			print("Could not finde name to remove \(error), \(error.userInfo)")
		}
		do {
			try managedContex.save()
			tableView.deleteRows(at: [indexPath], with: .automatic)
		} catch let error as NSError {
			print("Could not save \(error), \(error.userInfo)")
		}
		
	}
	
	
}

