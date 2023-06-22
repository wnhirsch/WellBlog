//
//  Post.List.Test.swift
//  WellBlogTests
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import XCTest
@testable import WellBlog

final class PostListTest: XCTestCase {

    var viewModel: Scene.Post.List.ViewModel!
    var coordinator: PostMockCoordinator!
    var worker: PostMockWorker!

    override func setUp() {
        super.setUp()
        coordinator = PostMockCoordinator()
        worker = PostMockWorker()
        viewModel = Scene.Post.List.ViewModel(coordinator: coordinator, worker: worker)
    }

    override func tearDown() {
        viewModel = nil
        coordinator = nil
        worker = nil
        super.tearDown()
    }

    func testGoToPostDetail() {
        let index = 0
        let postId = 123
        viewModel.posts = [Model.Post(id: postId, title: "Test Post")]
        
        viewModel.goToPostDetail(index: index)
        
        XCTAssertEqual(coordinator.startDetailsCalled, 1)
        XCTAssertEqual(coordinator.startDetailsPostId, postId)
    }
    
    func testGoToCreatePost() {
        viewModel.goToCreatePost()
        
        XCTAssertEqual(coordinator.startCreateCalled, 1)
    }
    
    func testFetchPosts() {
        worker.posts = [Model.Post(id: 1, title: "Post 1"), Model.Post(id: 2, title: "Post 2")]
        
        viewModel.fetchPosts()
        
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(worker.getPostsByPageCalled, 1)
        XCTAssertEqual(worker.getPostsByPagePage, 1)
        
        worker.successBlock?()
        
        XCTAssertEqual(viewModel.posts.count, 2)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testRefreshData() {
        worker.posts = [Model.Post(id: 1, title: "Post 1"), Model.Post(id: 2, title: "Post 2")]
        viewModel.page = 3
        viewModel.posts = [Model.Post(id: 11, title: "Existing Post")]
        
        viewModel.refreshData()
        
        XCTAssertEqual(viewModel.page, 1)
        XCTAssertTrue(viewModel.posts.isEmpty)
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(worker.getPostsByPageCalled, 1)
        XCTAssertEqual(worker.getPostsByPagePage, 1)
        
        worker.successBlock?()
        
        XCTAssertEqual(viewModel.page, 2)
        XCTAssertEqual(viewModel.posts.count, 2)
        XCTAssertFalse(viewModel.isLoading)
    }
}
