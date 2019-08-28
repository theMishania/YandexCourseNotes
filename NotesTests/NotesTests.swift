//
//  NotesTests.swift
//  NotesTests
//
//  Created by Мишаня on 26/06/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import XCTest
@testable import Notes

class NotesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testNoteInitialization(){
        let note = Note(title: "Title", content: "Content", importance: .important)
        
        XCTAssertEqual(note.color, UIColor.white)
        XCTAssertEqual(note.selfDestructionDate, nil, "Date is not nil")
        XCTAssertEqual(note.title, "Title")
    }
    
    func testColorComputing(){
        let redInt = 0xFF0000FF
        XCTAssertEqual(redInt.color, UIColor.red)
        
        var color = UIColor.white
        XCTAssertEqual(color.rgb, 0xFFFFFFFF)
        
        color = UIColor.blue
        XCTAssertEqual(color.rgb, 0x0000FFFF)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
    }

}
