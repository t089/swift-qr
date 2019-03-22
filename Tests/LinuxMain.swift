import XCTest

import QRTests

var tests = [XCTestCaseEntry]()
tests += QRTests.allTests()
XCTMain(tests)