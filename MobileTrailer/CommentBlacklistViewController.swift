
import UIKit

class CommentBlacklistViewController: UITableViewController {

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return Settings.commentAuthorBlacklist.count == 0 ? 0 : 1
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Settings.commentAuthorBlacklist.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("UsernameCell", forIndexPath: indexPath) as UITableViewCell
		cell.textLabel?.text = Settings.commentAuthorBlacklist[indexPath.row]
		return cell
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {
			var blackList = Settings.commentAuthorBlacklist
			blackList.removeAtIndex(indexPath.row)
			Settings.commentAuthorBlacklist = blackList
			if blackList.count==0 { // last delete
				tableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
			} else {
				tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
			}
		}
	}

	@IBAction func addSelected() {

		let a = UIAlertController(title: "Block commenter",
			message: "Enter the username of the poster whose comments you don't want to be notified about",
			preferredStyle: UIAlertControllerStyle.Alert)

		a.addTextFieldWithConfigurationHandler({ textField in
			textField.placeholder = "Username"
		})
		a.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
		a.addAction(UIAlertAction(title: "Block", style: UIAlertActionStyle.Default, handler: { action in

			let tf = a.textFields?.first as UITextField
			var name = tf.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

			if startsWith(name, "@") {
				name = name.substringFromIndex(advance(name.startIndex, 1))
			}

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
				if !name.isEmpty && !contains(Settings.commentAuthorBlacklist, name) {
					var blackList = Settings.commentAuthorBlacklist
					blackList.append(name)
					Settings.commentAuthorBlacklist = blackList
					let ip = NSIndexPath(forRow: blackList.count-1, inSection: 0)
					if blackList.count == 1 { // first insert
						self.tableView.insertSections(NSIndexSet(index: 0), withRowAnimation:UITableViewRowAnimation.Automatic)
					} else {
						self.tableView.insertRowsAtIndexPaths([ip], withRowAnimation:UITableViewRowAnimation.Automatic)
					}
				}
			}
		}))

		presentViewController(a, animated: true, completion: nil)
	}
}
