//
//  ViewController.swift
//  HitList
//
//  Created by Xavi Moll on 05/12/2016.
//  Copyright © 2016 Xavi Moll. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var tableView: UITableView!
	
	var people = ["a", "b", "c"]

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.tintColor = UIColor.orange
		navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.orange]
		configureTable()
		
		tableView.dataSource = self
		
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
			self.people.insert(friendName, at: 0)
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
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.backgroundColor = UIColor.black
		cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
		cell.textLabel?.textColor = UIColor.orange.withAlphaComponent(0.75)
		cell.textLabel?.text = people[indexPath.row]
		cell.textLabel?.textAlignment = .center
		cell.separatorInset.left = 5
		cell.separatorInset.right = 5
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		let removedRow = indexPath.row
		people.remove(at: removedRow)
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
	
	
}

