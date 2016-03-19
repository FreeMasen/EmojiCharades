import UIKit
import Google

class MainViewController : UIViewController, GIDSignInUIDelegate {
    var guser: GIDGoogleUser? {
        didSet {
            if self.guser != nil {
                setUserAsync()
            }
        }
    }
    var user: User? {
        didSet {
            if user != nil {
                performSegueWithIdentifier("signin", sender: self)
            }
        }
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUp: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.addObserver(self, forKeyPath: "user", options: .New , context: nil)
    }
    
    
    deinit {
        self.removeObserver(self, forKeyPath: "user")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "SignIn", object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        let notif = NSNotificationCenter.defaultCenter()
        notif.addObserver(self, selector: Selector("gidAssigned"), name: "SignIn", object: nil)
        
    }
    
    func gidAssigned() {
        guser = GIDSignIn.sharedInstance().currentUser
    }
    
    override func viewDidAppear(animated: Bool) {
        resetErrors()
        super.viewDidAppear(animated)
    }
    
    @IBAction func signUp(sender: UIButton) {
        resetErrors()
        FireBaseHelper.insertNewUser(User(googleUser: guser!))
    }
    
    @IBAction func signIn(sender: UIButton) {
        resetErrors()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func setUserAsync() {
        let email = guser!.profile.email
        do {
            try FireBaseHelper.getUser(email) { u in
                self.user = u
            }
        }catch {
            errorLabel.hidden = false
            errorLabel.text = "Unable to find user"
            signUp.hidden = false
            signUp.enabled = true
        }
    }
    
    func resetErrors() {
        signUp.enabled = false
        signUp.hidden = true
        errorLabel.hidden = true
        errorLabel.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tabView = segue.destinationViewController as? TabViewController {
            tabView.user = self.user
        }
    }
    
}