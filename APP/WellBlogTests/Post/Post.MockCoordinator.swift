//
//  Post.MockCoordinator.swift
//  WellBlogTests
//
//  Created by Wellington Nascente Hirsch on 22/06/23.
//

@testable import WellBlog

class PostMockCoordinator: Coordinator.Post {
    
    var dismissCalled = false
    
    var startDetailsCalled = 0
    var startDetailsPostId: Int?
    
    var startCreateCalled = 0
    
    override func startDetails(postId: Int) {
        startDetailsCalled += 1
        startDetailsPostId = postId
    }
    
    override func startCreate() {
        startCreateCalled += 1
    }
    
    override func dismiss() {
        dismissCalled = true
    }
}
