

import UIKit

final class NewReviewViewController: UIViewController {

    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var reviewTitle: UITextField!
    @IBOutlet weak var reviewText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
    }
    
    private func setTextView() {
        reviewText.layer.borderWidth = 1
        let borderColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        reviewText.layer.borderColor = borderColor.cgColor
        reviewText.clipsToBounds = true
        reviewText.layer.cornerRadius = 5
    }
    @IBAction func submitButton(_ sender: Any) {
        print(ratingControl.rating)
        print(reviewTitle.text)
        print(reviewText.text)
    }
    
}
