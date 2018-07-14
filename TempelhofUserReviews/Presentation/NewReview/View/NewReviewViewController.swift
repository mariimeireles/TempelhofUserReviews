

import RxSwift
import UIKit

final class NewReviewViewController: UIViewController {

    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var reviewTitle: UITextField!
    @IBOutlet weak var reviewText: UITextView!
    private let disposeBag = DisposeBag()
    private let viewModel: NewReviewViewModel
    
    init(withViewModel viewModel: NewReviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: NewReviewViewController.identifier, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        guard let titleText = reviewTitle.text else { return }
        viewModel.postNewReview(with: ratingControl.rating, title: titleText, message: reviewText.text)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in self?.render(state) })
            .disposed(by: disposeBag)
    }
    
    private func render(_ state: ReviewScreenState) {
        switch state {
        case .loading:
            print("loading")
        case let .success(reviews):
            print("success\(reviews)")
        case .successWithNoReviews:
            print("successWithNoReviews")
        case let .failure(error):
            print("failure\(error)")
        }
    }
    
}
