

import RxSwift
import UIKit

final class ReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var noReviewsLabel: UILabel!
    private let disposeBag = DisposeBag()
    private let viewModel: ReviewsViewModel!
    private var reviews: [ReviewModel]!
    
    init(withViewModel viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: ReviewsViewController.identifier, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewLayout()
        setScreenState()
    }
    
    private func tableViewLayout() {
        let nib = UINib(nibName: "ReviewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "ReviewCell")
    }
    
    @objc private func setScreenState() {
        viewModel.getReviews()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in self.render(state) })
            .disposed(by: disposeBag)
    }
    
    private func render(_ state: ReviewScreenState) {
        switch state {
        case .loading:
            showActivityIndicator(true)
        case let .success(reviews):
            showActivityIndicator(false)
            showReviews(with: reviews)
        case .successWithNoReviews:
            showActivityIndicator(false)
            noReviewsLabel.alpha = 1
        case let .failure(error):
            showActivityIndicator(false)
            showFailure(for: error)
        }
    }
    
    private func showActivityIndicator(_ bool: Bool) {
        activityIndicator.alpha = bool ? 1 : 0
    }
    
    private func showReviews(with reviews: [ReviewModel]) {
        self.reviews = reviews
        DispatchQueue.main.async {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 500
            self.tableView.reloadData()
        }
    }
    
    private func showFailure(for error: ReviewScreenErrorType) {
        switch error {
        case .noConnection:
            let alert = alertWith(title: "Oh no!", message: "Could not find a network connection. Connect to the internet to try again.", actionTitle: "Try again")
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
    
    private func alertWith(title: String, message: String, actionTitle: String) ->  UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { [unowned self] (_) -> Void in
            self.setScreenState()
        }))
        return alert
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.review = reviews[indexPath.row]
        return cell
    }


}
