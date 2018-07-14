

import UIKit

final class ReviewCell: UITableViewCell {
    
    @IBOutlet private var title: UILabel!
    @IBOutlet private var rating: UIImageView!
    @IBOutlet private var message: UILabel!
    @IBOutlet private var author: UILabel!
    
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
