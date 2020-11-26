//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 11.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IPresenentationAssembly = PresenentationAssembly(serviceAssembly: serviceAssembly)
    private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
