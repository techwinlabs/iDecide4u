//
//  IDFYListOperationInteractor.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYListOperationInteractor : IDFYListOperationInteractorInterface {
  
  var listOperationPresenter : IDFYListOperationPresenterInterface!
  
  
  // MARK: - IDFYListOperationInteractorInterface
  
  func updateListOfLists() {
    listOperationPresenter.updateListOfListsWith([IDFYOptionList]())
  }
  
}
