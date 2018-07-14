

import UIKit

final class ReviewModel {

    let title: String
    let rating: UIImage
    let message: String
    let author: String

    init(review: UserReview.DataDetails) throws {
        title = review.title
        let number = (review.rating as NSString).integerValue
        let imageName = "\(number)Stars"
        guard let image = UIImage(named: imageName) else { throw ServiceError.internalServerError }
        rating = image
        message = review.message
        author = "\(review.author) • \(review.date)"
    }
}
