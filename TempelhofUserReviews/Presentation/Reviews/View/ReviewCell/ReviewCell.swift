

import UIKit

final class ReviewCell: UITableViewCell {

    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var rating: UIImageView!
    @IBOutlet weak private var message: UILabel!
    @IBOutlet weak private var author: UILabel!
    
    var review: ReviewModel? {
        didSet {
            fillOutlets()
        }
    }
    
    private func fillOutlets() {
        guard let review = review else { return }
        DispatchQueue.main.async {
            self.title.text = review.title
            self.rating.image = review.rating
            self.message.text = review.message
            self.author.text = review.author
        }
    }
    
}
