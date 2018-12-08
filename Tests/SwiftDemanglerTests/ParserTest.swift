//
//  ParserTest.swift
//  SwiftDemanglerTests
//
//  Created by Yuki Takahashi on 2018/12/08.
//

import XCTest
@testable import SwiftDemangler

class ParserTest: XCTestCase {
    func testparseInt() {
        var parser = Parser(name: "0")
        XCTAssertEqual(parser.parseInt(), 0)
        XCTAssertEqual(parser.remains, "")
        parser = Parser(name: "1")
        XCTAssertEqual(parser.parseInt(), 1)
        XCTAssertEqual(parser.remains, "")
        parser = Parser(name: "12")
        XCTAssertEqual(parser.parseInt(), 12)
        XCTAssertEqual(parser.remains, "")
        parser = Parser(name: "12A")
        XCTAssertEqual(parser.parseInt(), 12)
        XCTAssertEqual(parser.remains, "A")
        parser = Parser(name: "1B2A")
        XCTAssertEqual(parser.parseInt(), 1)
        XCTAssertEqual(parser.remains, "B2A")
        XCTAssertEqual(parser.parseInt(), nil)
    }

    func testparseIdentifierWithLength() {
        let parser = Parser(name: "3ABC4DEFG")
        XCTAssertEqual(parser.parseInt(), 3)
        XCTAssertEqual(parser.remains, "ABC4DEFG")
        XCTAssertEqual(parser.parseIdentifier(length: 3), "ABC")
        XCTAssertEqual(parser.remains, "4DEFG")
        XCTAssertEqual(parser.parseInt(), 4)
        XCTAssertEqual(parser.remains, "DEFG")
        XCTAssertEqual(parser.parseIdentifier(length: 4), "DEFG")
    }
    
    func testparseIdentifier() {
        let parser = Parser(name: "3ABC4DEFG")
        XCTAssertEqual(parser.parseIdentifier(), "ABC")
        XCTAssertEqual(parser.remains, "4DEFG")
        XCTAssertEqual(parser.parseIdentifier(), "DEFG")
    }
}
