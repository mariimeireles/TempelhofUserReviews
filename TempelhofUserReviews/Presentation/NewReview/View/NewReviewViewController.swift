

import RxSwift
import UIKit

protocol NewReviewViewControllerDelegate: class {
    func newReviewResponse(_ newReviews: [ReviewModel])
}

final class NewReviewViewController: UIViewController {
    
    @IBOutlet private var ratingControl: RatingControl!
    @IBOutlet private var reviewTitle: UITextField!
    @IBOutlet private var reviewText: UITextView!
    private let disposeBag = DisposeBag()
    private let viewModel: NewReviewViewModel
    weak var delegate: NewReviewViewControllerDelegate?
    
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
        reviewText.layer.borderColor = UIColor.AppColor.General.lighterGray.cgColor
        reviewText.clipsToBounds = true
        reviewText.layer.cornerRadius = 5
    }
    
    @IBAction func submitButton(_ sender: Any) {
        setScreenState()
    }
    
    private func setScreenState() {
        guard let titleText = reviewTitle.text else { return }
        viewModel.postNewReview(with: ratingControl.rating, title: titleText, message: reviewText.text)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in self?.render(state) })
            .disposed(by: disposeBag)
    }
    
    private func render(_ state: ReviewScreenState) {
        switch state {
        case .loading:
            break
        case let .success(reviews):
            delegate?.newReviewResponse(reviews)
            navigationController?.popViewController(animated: false)
        case let .failure(error):
            showFailure(for: error)
        default:
            navigationController?.popViewController(animated: false)
        }
    }
    
    private func showFailure(for error: ReviewScreenErrorType) {
        switch error {
        case .noConnection:
            let alert = alertWith(title: "Oh no!", message: "Could not find a network connection. Connect to the internet and try submit the review again.", actionTitle: "Try again")
            alert.addAction(UIAlertAction(title: "Check connection", style: .default, handler: { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else { return }
                UIApplication.shared.open(settingsUrl)
            }))
            present(alert, animated: true, completion: nil)
        case .timeOut:
            let alert = alertWith(title: "Oh no!", message: "This is taking a little longer than usual.", actionTitle: "Try again")
            present(alert, animated: true, completion: nil)
        default:
            let alert = alertWith(title: "Something went wrong.", message: "Sorry, it's not you, it's us! Please try again later.", actionTitle: "Try again")
            present(alert, animated: true, completion: nil)
        }
    }
    
    func alertWith(title: String, message: String, actionTitle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { [unowned self] (_) -> Void in
            self.setScreenState()
        }))
        return alert
    }
}
