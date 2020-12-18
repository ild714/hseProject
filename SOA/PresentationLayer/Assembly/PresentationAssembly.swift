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
            let modelRoomsConfig = self.modelRoomsConfig()
            if let userId = UserDefaults.standard.object(forKey: "UserId") as? String {
                let collectionVC =  CollectionViewController(coder: coder, presentationAssembly: self, userId: userId, model: modelRoomsConfig)
                modelRoomsConfig.delegate = collectionVC
                return collectionVC
            } else {
                return nil
            }
        })
    }

    private func modelRoomsConfig() -> ModelProtocol {
        return ModelRoomsConfig(roomConfigService: self.serviceAssembly.roomsConfigService)
    }

    private let serviceAssembly: ServiceAssemblyProtocol

    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }

}