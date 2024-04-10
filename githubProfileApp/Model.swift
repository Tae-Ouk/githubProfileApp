import Foundation

struct GitHubUser: Decodable {
    let username: String
    let avatarURL: String
    let repositoriesURL: String

    private enum CodingKeys: String, CodingKey {
        case username = "login"
        case avatarURL = "avatar_url"
        case repositoriesURL = "repos_url"
    }
}

struct GitHubRepository: Decodable {
    let name: String
    let description: String
    let stars: Int
}
