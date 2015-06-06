//
//  IDFYAddAndDecideInteractorTest.swift
//  iDecide4U
//
//  Created by Dominic Frei on 05/06/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation
import XCTest
import UIKit
import CoreData

class IDFYAddAndDecideInteractorTest : XCTestCase {
  
  class MockAddAndDecidePresenter : IDFYAddAndDecidePresenter {
    var mockList = [String]()
    var decision = ""
    @objc override func updateListWithGivenList(list: [String]) {
      mockList = list
    }
    @objc override func updateInterfaceWithNewData() {}
    @objc override func presentDecision(option: String) {
      decision = option
    }
  }
  
  class MockDataManager : IDFYDataManager {
    var mockList = IDFYOptionList()
    override func getCurrentList() -> IDFYOptionList {
      return mockList
    }
    override func updateCurrentList(optionList: IDFYOptionList) {
      mockList = optionList
    }
  }
  
  let addAndDecideInteractor = IDFYAddAndDecideInteractor()
  let mockPresenter = MockAddAndDecidePresenter()
  let mockDataManager = MockDataManager()
  
  override func setUp() {
    super.setUp()
    addAndDecideInteractor.dataManager = mockDataManager
    addAndDecideInteractor.addAndDecidePresenter = MockAddAndDecidePresenter()
    mockPresenter.addAndDecideInteractor = addAndDecideInteractor
    addAndDecideInteractor.addAndDecidePresenter = mockPresenter
  }
  
  func testWillAddNewOption() {
    addAndDecideInteractor.willAddNewOption("foo")
    XCTAssertEqual(1, mockPresenter.mockList.count , "The item list should contain exactly one item.")
    XCTAssertEqual("foo", mockPresenter.mockList[0], "The item list should contain the element 'foo'.")
    
    addAndDecideInteractor.willAddNewOption("bar")
    XCTAssertEqual(2, mockPresenter.mockList.count , "The item list should contain exactly two item.")
    XCTAssertEqual("bar", mockPresenter.mockList[1], "The item list should contain the element 'bar'.")
  }
  
  func testWillDecide() {
    let testList = ["foo", "bar"]
    mockDataManager.mockList = IDFYOptionList(name: "foo", options: testList)
    addAndDecideInteractor.willDecide()
    XCTAssertTrue(contains(testList, mockPresenter.decision), "One of the elements from the test list should be chosen as decision.")
    XCTAssertTrue("foo" == mockPresenter.decision || "bar" == mockPresenter.decision, "The decision should be 'foo' or 'bar'.")
  }
  
}
