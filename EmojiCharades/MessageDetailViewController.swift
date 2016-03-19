import UIKit

class MessageDetailViewController: UIViewController {
    var message: Message?
    var username: String?
    
    @IBOutlet weak var who: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var response: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var grade: UISwitch!
    @IBOutlet weak var action: UIButton!
    @IBOutlet weak var gradeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        view.addGestureRecognizer(tap)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupView() {
        if message?.PointTo != Score.NotYetScored {
            completed()
        } else {
            if message?.Sender == username {
                grading()
            } else  {
                responding()
            }
        }
        gradeLabel.hidden = grade.hidden
    }
    
    func responding() {
        self.navigationItem.title = "Respond to Message"
        self.view.tag = 1
        if let m = message {
        who.text = "From: \(m.Sender)"
        content.text = "Message: \(m.Content)"
        
        
        grade.enabled = false
        grade.hidden = true
        
        
        action.hidden = false
        action.setTitle("Submit Response", forState: .Normal)
        
        response.hidden = false
        responseLabel.hidden = true
    }
    }
    
    func grading() {
        self.view.tag = 2
        self.navigationItem.title = "Grade message"
        if let m = message {
            who.text = "To: \(m.Reciever)"
            content.text = "Message: \(m.Content)"
            responseLabel.text = "Response: \(m.Response)"
            
            grade.enabled = true
            grade.hidden = false
            
            action.hidden = true
            
            response.hidden = true
            responseLabel.hidden = false
            
            action.hidden = false
            action.setTitle("Submit Grade", forState: .Normal)
        }
    }
    
    func completed() {
        self.navigationItem.title = "View Message"
        self.view.tag = 3
        if let m = message {
            if message?.Sender == username {
                who.text = "To: \(m.Reciever)"
                content.text = "Message: \(m.Content)"
                responseLabel.text = "Response: \(m.Response)"
                
                grade.setOn(message?.PointTo == .Reciever, animated: false)
                grade.enabled = false
                grade.hidden = false
                
                action.hidden = true
                response.hidden = true
                responseLabel.hidden = false
                
            } else if message?.Reciever == username {
                who.text = "From: \(m.Reciever)"
                content.text = "Message: \(m.Content)"
                responseLabel.text = "Response: \(m.Response)"
                
                grade.setOn(m.PointTo == .Reciever, animated: false)
                grade.enabled = false
                grade.hidden = false
                
                action.hidden = true
                response.hidden = true
                responseLabel.hidden = false
            }
        }
    }
    
    @IBAction func SubmitChange(sender: UIButton) {
        captureResponse()
    }
    func captureResponse() {
        switch self.view.tag {
        case 1:
            if testTextBox() {
                message?.Response = response.text!
                FireBaseHelper.insertNewMessage(message!)
                self.navigationController?.popViewControllerAnimated(true)
            }
            break;
        case 2:
            if grade.on {
                message?.PointTo = .Reciever
                FireBaseHelper.insertNewMessage(message!)
//                FireBaseHelper.updateGloablScore() 
            } else {
                message?.PointTo = .Sender
                FireBaseHelper.insertNewMessage(message!)
            }
            self.navigationController?.popViewControllerAnimated(true)
            break;
        default:
            break;
        }
    }
    
    func testTextBox() -> Bool {
        if response.text == "" {
            action.setTitle("Please enter a response", forState: .Normal)
            return false
        }
        return true
    }
}
