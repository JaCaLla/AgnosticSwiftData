//
//  AppSingletons.swift
//  LocationSampleApp
//
//  Created by Javier Calatrava on 1/12/24.
//

import Foundation

@MainActor
struct AppSingletons {
    var dbManager: DBManager
    
    init(dbManager: DBManager = DBManager.shared) {
        self.dbManager = dbManager
    }
}

@MainActor var appSingletons = AppSingletons()
