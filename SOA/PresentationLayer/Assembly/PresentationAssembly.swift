//
//  PresentationAssembly.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

protocol PresentationAssemblyProtocol {
    func collectionViewController() -> CollectionViewController?
}

class PresentationAssembly: PresentationAssemblyProtocol {
    func collectionViewController() -> CollectionViewController? {
        let storyboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
        return storyboard.instantiateViewController(identifier: "CollectionViewController", creator: { coder in
            return CollectionViewController(coder: coder, roomConfigService: self.serviceAssembly.roomsConfigService)
        })
        return nil
//        return collectionVC
    
    }
    
    private let serviceAssembly: ServiceAssemblyProtocol
    
    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    
}
