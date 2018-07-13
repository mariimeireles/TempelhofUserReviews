

enum ServiceError: Error {
    case rest(RESTError)
    case connection(InternetConnectionError)
    case jsonParse
    case internalServerError
}
