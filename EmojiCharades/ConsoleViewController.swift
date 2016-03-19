import UIKit

class SentMsgsViewController: UITableViewController {
    var user: User?
    var parentView: TabViewController?
    var currentSelection = -1 {
        didSet {
            if currentSelection > -1 {
                performSegueWithIdentifier("viewMessage", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        parentView = self.parentViewController as? TabViewController
        user = parentView!.user!
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateView"), name: "userChange", object: nil)
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user!.sent().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let messages = user!.sent()
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as! MessageCell
        cell.sender.text = messages[indexPath.row].Sender
        cell.content.text = messages[indexPath.row].Content
        cell.score.text = messages[indexPath.row].PointTo.rawValue.description
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentSelection = indexPath.row
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextView = segue.destinationViewController as! MessageDetailViewController
        nextView.message = user!.sent()[currentSelection]
        nextView.username = user!.UserName
    }
}

class recievedViewController: UITableViewController {
    var user: User?
    var parentView: TabViewController?
    var currentSelection = -1 {
        didSet {
            if currentSelection > -1 {
                performSegueWithIdentifier("viewRecieved", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        parentView = self.parentViewController as? TabViewController
        user = parentView!.user!
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateView"), name: "userChange", object: nil)
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentSelection = indexPath.row
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableUser = user {
            return tableUser.recieved().count
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let messages = user!.recieved()
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as! MessageCell
        cell.sender.text = messages[indexPath.row].Sender
        cell.content.text = messages[indexPath.row].Content
        cell.score.text = messages[indexPath.row].PointTo.rawValue.description
        return cell

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextView = segue.destinationViewController as! MessageDetailViewController
        nextView.message = user!.recieved()[currentSelection]
        nextView.username = user!.UserName
    }
}

class UnreadViewController: UITableViewController {
    var user: User?
    var parentView: TabViewController?
    var currentSelection = -1 {
        didSet {
            if currentSelection > -1 {
                performSegueWithIdentifier("viewUnread", sender: self)
            }
        }
    }

    
    override func viewDidLoad() {
        parentView = self.parentViewController as? TabViewController
        user = parentView!.user!
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateView"), name: "userChange", object: nil)
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableUser = user {
            return tableUser.unread().count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let messages = user!.unread()
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as! MessageCell
        cell.sender.text = messages[indexPath.row].Sender
        cell.content.text = messages[indexPath.row].Content
        cell.score.text = messages[indexPath.row].PointTo.rawValue.description
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentSelection = indexPath.row
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextView = segue.destinationViewController as! MessageDetailViewController
        nextView.message = user!.unread()[currentSelection]
        nextView.username = user!.UserName
    }
}