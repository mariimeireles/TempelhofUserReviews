

import UIKit

final class NewReviewViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
    }
    
    private func setTextView() {
        textView.layer.borderWidth = 1
        let borderColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        textView.layer.borderColor = borderColor.cgColor
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 5
    }
    
}
