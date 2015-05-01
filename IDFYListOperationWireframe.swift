//
//  IDFYListOperationWireframe.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYListOperationWireframe {
  
  func setupWiresForPresenter(presenter: IDFYListOperationPresenter) {
    let listOperationInteractor = IDFYListOperationInteractor()
    listOperationInteractor.listOperationPresenter = presenter
    presenter.listOperationInteractor = listOperationInteractor
  }
  
}
