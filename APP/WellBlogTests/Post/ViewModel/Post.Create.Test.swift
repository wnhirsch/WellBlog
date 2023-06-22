//
//  Post.Create.Test.swift
//  WellBlogTests
//
//  Created by Wellington Nascente Hirsch on 22/06/23.
//

import XCTest
@testable import WellBlog

class PostCreateTest: XCTestCase {
    
    var viewModel: Scene.Post.Create.ViewModel!
    var coordinator: PostMockCoordinator!
    var worker: PostMockWorker!

    override func setUp() {
        super.setUp()
        coordinator = PostMockCoordinator()
        worker = PostMockWorker()
        viewModel = Scene.Post.Create.ViewModel(coordinator: coordinator, worker: worker)
    }

    override func tearDown() {
        viewModel = nil
        coordinator = nil
        worker = nil
        super.tearDown()
    }
    
    func testCreatePostWithValidData() {
        viewModel.title = "Test Title"
        viewModel.description = "Test Description"
        viewModel.createPost()
        
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(worker.createPostCalled, 1)
        XCTAssertEqual(worker.createdPost?.title, viewModel.title)
        XCTAssertEqual(worker.createdPost?.description, viewModel.description)
        
        worker.successBlock?()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(coordinator.dismissCalled)
    }
    
    func testCreatePostWithInvalidData() {
        viewModel.title = ""
        viewModel.description = "Test Description"
        viewModel.createPost()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(worker.createPostCalled, 0)
        XCTAssertNil(worker.createdPost)
        XCTAssertFalse(coordinator.dismissCalled)
    }
    
    func testIsTitleValid() {
        viewModel.title = "    \n\n\n    "
        XCTAssertFalse(viewModel.isTitleValid())
        
        viewModel.title = "Test Title"
        XCTAssertTrue(viewModel.isTitleValid())
    }
    
    func testIsDescriptionValid() {
        viewModel.description = "    \n\n\n    "
        XCTAssertFalse(viewModel.isDescriptionValid())
        
        viewModel.description = "Test Description"
        XCTAssertTrue(viewModel.isDescriptionValid())
    }
    
}
