import UIKit
import Google

class MainViewController : UIViewController, GIDSignInUIDelegate {
    var guser: GIDGoogleUser? {
        didSet {
            if self.guser != nil {
                print(guser?.profile.email)
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Seed.seedWithMessageTypes()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        guser = GIDSignIn.sharedInstance().currentUser
    }
    
    override func viewDidAppear(animated: Bool) {
        resetErrors()
        super.viewDidAppear(animated)
        guser = GIDSignIn.sharedInstance().currentUser
    }
    
    @IBAction func signUp(sender: UIButton) {
        resetErrors()
    }
    
    @IBAction func signIn(sender: UIButton) {
        resetErrors()
        GIDSignIn.sharedInstance().signIn()
        guser = GIDSignIn.sharedInstance().currentUser
    }
    
    func setUserAsync() {
        let email = guser!.profile.email
            FireBaseHelper.getUser(email) { u in
                self.user = u
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