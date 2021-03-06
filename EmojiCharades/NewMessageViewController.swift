import UIKit

class NewMessageViewController: UIViewController {
    var userName: String?
    
    @IBOutlet weak var reciever: UITextField!
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        view.addGestureRecognizer(tap)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    
    @IBAction func addMessage(sender: AnyObject) {
        if validateForm() {
            let username = SignInHelper.removeSpecialChars(reciever.text!)
            let newMsg = Message(sender: userName!, reciever: username!, content: content.text!)
            FireBaseHelper.insertNewMessage(newMsg)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    func validateForm() -> Bool{
        var status = true
        if (reciever.text == "") || !(reciever.text!.containsString("@")) || !(reciever.text!.containsString(".com")) {
            submitButton.setTitle("Email address not formatedd correctly", forState: .Normal)
            reciever.becomeFirstResponder()
            status = false
        }
        if content.text == "" {
            submitButton.setTitle("Content cannot be blank", forState: .Normal)
            content.becomeFirstResponder()
            status = false
        }
        return status
    }
    
}
