//
//  Worker.Post.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

extension Worker {
    
    class Post {
        
        private let api: Repository.Post
        
        init(api: Repository.Post = .init()) {
            self.api = api
        }
        
        func getPost(id: Int, success: ((Model.Post) -> Void)? = nil, failure: (() -> Void)? = nil) {
            api.getPost(id: id) { result in
                switch result {
                case let .success(response):
                    do {
                        let post = try response.mapObject(Model.Post.self)
                        success?(post)
                    } catch let error {
                        print(error)
                        failure?()
                    }
                case let .failure(error):
                    print(error)
                    failure?()
                }
            }
        }
        
        func getPostsByPage(
            page: Int,
            pageSize: Int = APIHost.itemsPerPage,
            success: (([Model.Post]) -> Void)? = nil,
            failure: (() -> Void)? = nil
        ) {
            api.getPostsByPage(page: page, pageSize: pageSize) { result in
                switch result {
                case let .success(response):
                    do {
                        let posts = try response.mapObject([Model.Post].self)
                        success?(posts)
                    } catch let error {
                        print(error)
                        failure?()
                    }
                case let .failure(error):
                    print(error)
                    failure?()
                }
            }
        }
        
        func createPost(post: Model.NewPost, success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
            api.createPost(post: post) { result in
                switch result {
                case .success:
                    success?()
                case let .failure(error):
                    print(error)
                    failure?()
                }
            }
        }
        
        func deletePost(id: Int, success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
            api.deletePost(id: id) { result in
                switch result {
                case .success:
                    success?()
                case let .failure(error):
                    print(error)
                    failure?()
                }
            }
        }
    }
}
