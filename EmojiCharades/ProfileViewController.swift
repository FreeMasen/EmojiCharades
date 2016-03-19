import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    var user: User?
    var parentView: TabViewController?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        parentView = self.parentViewController as? TabViewController
        if let user = parentView!.user {
        username.text = "Username: \(user.UserName)"
        name.text = "Name: \(user.Name)"
        score.text = "Score: \(user.GlobalScore)"
        }
    }
}
