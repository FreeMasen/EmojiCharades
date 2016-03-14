import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var about: UITextView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let path = NSBundle.mainBundle().pathForResource("info", ofType: "txt")
        if let info = try? String(contentsOfFile: path!) {
            about.text = info
        }
    }
}
