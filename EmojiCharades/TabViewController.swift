
import UIKit
import Google

class TabViewController: UITabBarController {
    var user: User? {
        willSet(newUser) {
            if user == nil && newUser != nil {
                addMessageObserver(newUser!)
            } 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let plus = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("newMsg"))
        self.navigationItem.rightBarButtonItem = plus
    }
    
    func addMessageObserver(user: User) {
        let ref = FireBaseHelper.ConnectToFirebase().childByAppendingPath("users/\(user.UserName)/messages")
        ref.observeEventType(.ChildAdded, withBlock: { u in
            FireBaseHelper.processMessageUpdate(u, user: self.user!)

        })
        ref.observeEventType(.ChildChanged, withBlock: { u in
            FireBaseHelper.processMessageUpdate(u , user: self.user!)

        })
        ref.observeEventType(.ChildRemoved, withBlock: { u in
            FireBaseHelper.processMessageUpdate(u, user: self.user!)
            })
    }
    
    @IBAction func newMsg() {
        performSegueWithIdentifier("newMsg", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = segue.destinationViewController as? MainViewController {
            GIDSignIn.sharedInstance().signOut()
        } else if let nextView = segue.destinationViewController as? NewMessageViewController {
            nextView.userName = user?.UserName
        }
    }
}
