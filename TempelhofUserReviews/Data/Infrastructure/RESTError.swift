

enum RESTError {
    case notFound
    case serverError
    case other

    init(code: Int) {
        switch code {
        case 404:
            self = .notFound
        case 500...513:
            self = .serverError
        default:
            self = .other
        }
    }
}
