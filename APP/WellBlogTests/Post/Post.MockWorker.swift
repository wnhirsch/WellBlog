//
//  Post.MockWorker.swift
//  WellBlogTests
//
//  Created by Wellington Nascente Hirsch on 22/06/23.
//

@testable import WellBlog

class PostMockWorker: Worker.Post {
    
    var getPostsByPageCalled = 0
    var getPostsByPagePage: Int?
    var posts: [Model.Post]?
    
    var getPostCalled = 0
    var getPostCalledWithId: Int?
    var post: Model.Post?
    
    var deletePostCalled = 0
    var deletePostCalledWithId: Int?
    
    var createPostCalled = 0
    var createdPost: Model.NewPost?
    
    var successBlock: (() -> Void)?
    
    override func getPostsByPage(
        page: Int,
        pageSize: Int = APIHost.itemsPerPage,
        success: (([Model.Post]) -> Void)? = nil,
        failure: (() -> Void)? = nil
    ) {
        getPostsByPageCalled += 1
        getPostsByPagePage = page
        
        successBlock = {
            if let posts = self.posts {
                success?(posts)
            } else {
                failure?()
            }
        }
    }
    
    override func getPost(id: Int, success: ((Model.Post) -> Void)? = nil, failure: (() -> Void)? = nil) {
        getPostCalled += 1
        getPostCalledWithId = id
        
        successBlock = {
            if let posts = self.post {
                success?(posts)
            } else {
                failure?()
            }
        }
    }
    
    override func deletePost(id: Int, success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
        deletePostCalled += 1
        deletePostCalledWithId = id
        successBlock = success
    }
    
    override func createPost(post: Model.NewPost, success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
        createPostCalled += 1
        createdPost = post
        successBlock = success
    }
}
