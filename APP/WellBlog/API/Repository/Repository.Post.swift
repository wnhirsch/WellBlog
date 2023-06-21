//
//  Repository.Post.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Moya

extension Repository {
    
    struct Post {

        enum Target: APITarget {
            case getPost(id: Int)
            case getPostsByPage(page: Int, pageSize: Int)
            case createPost(post: Model.NewPost)
            case deletePost(id: Int)

            var path: String {
                switch self {
                case .getPost(let id), .deletePost(let id):
                    return "posts/\(id)"
                case .getPostsByPage(let page, let pageSize):
                    return "posts?page=\(page)&pageSize=\(pageSize)"
                case .createPost:
                    return "posts"
                }
            }

            var method: Method {
                switch self {
                case .getPost, .getPostsByPage:
                    return .get
                case .createPost:
                    return .post
                case .deletePost:
                    return .delete
                }
            }

            var task: Task {
                switch self {
                case .getPost, .getPostsByPage, .deletePost:
                    return .requestPlain
                case .createPost(let post):
                    return .requestJSONEncodable(post)
                }
            }

            var headers: [String: String]? {
               return sessionHeader()
            }
        }

        private let provider: MoyaProvider<Target> = APIProvider<Target>().build()
    }
    
}

extension Repository.Post {
    
    func getPost(id: Int, completion: @escaping Completion) {
        provider.request(.getPost(id: id), completion: completion)
    }
    
    func getPostsByPage(page: Int, pageSize: Int, completion: @escaping Completion) {
        provider.request(.getPostsByPage(page: page, pageSize: pageSize), completion: completion)
    }
    
    func createPost(post: Model.NewPost, completion: @escaping Completion) {
        provider.request(.createPost(post: post), completion: completion)
    }
    
    func deletePost(id: Int, completion: @escaping Completion) {
        provider.request(.deletePost(id: id), completion: completion)
    }
}
