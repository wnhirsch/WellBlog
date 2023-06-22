//
//  Post.Details.Test.swift
//  WellBlogTests
//
//  Created by Wellington Nascente Hirsch on 22/06/23.
//

import XCTest
@testable import WellBlog

class PostDetailsTest: XCTestCase {
    
    var postId: Int!
    var viewModel: Scene.Post.Details.ViewModel!
    var coordinator: PostMockCoordinator!
    var worker: PostMockWorker!

    override func setUp() {
        super.setUp()
        postId = 1
        coordinator = PostMockCoordinator()
        worker = PostMockWorker()
        viewModel = Scene.Post.Details.ViewModel(postId: postId, coordinator: coordinator, worker: worker)
    }

    override func tearDown() {
        postId = nil
        viewModel = nil
        coordinator = nil
        worker = nil
        super.tearDown()
    }
    
    func testFetchPost() {
        let expectedPost = Model.Post(id: 1, title: "Test Post")
        worker.post = expectedPost
        
        viewModel.fetchPost()
        
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(worker.getPostCalled, 1)
        XCTAssertEqual(worker.getPostCalledWithId, postId)
        
        worker.successBlock?()
        
        XCTAssertEqual(viewModel.post.id, expectedPost.id)
        XCTAssertEqual(viewModel.post.title, expectedPost.title)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testDeletePost() {
        viewModel.deletePost()
        
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(worker.deletePostCalled, 1)
        XCTAssertEqual(worker.deletePostCalledWithId, postId)
        
        worker.successBlock?()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(coordinator.dismissCalled)
    }
}
