//
//  IDFYAddAndDecideWireframe.swift
//  iDecide4U
//
//  Created by Dominic Frei on 01/05/2015.
//  Copyright (c) 2015 dominicfrei.com. All rights reserved.
//

import Foundation

class IDFYAddAndDecideWireframe {
  
  func setupWiresForPresenter(presenter: IDFYAddAndDecidePresenter) {
    let addAndDecideInteractor = IDFYAddAndDecideInteractor()
    addAndDecideInteractor.addAndDecidePresenter = presenter
    addAndDecideInteractor.dataManager = IDFYDataManager()
    presenter.addAndDecideInteractor = addAndDecideInteractor
  }
  
}
