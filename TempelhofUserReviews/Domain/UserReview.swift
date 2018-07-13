

struct UserReview: Codable {
    let data: [DataDetails]
    
    struct DataDetails: Codable {
        let rating: String
        let title: String
        let message: String
        let author: String
        let date: String
    }
}
