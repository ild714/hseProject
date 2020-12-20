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
    func roomsViewController(curentVC: Int) -> RoomsViewController?
}

class PresentationAssembly: PresentationAssemblyProtocol {

    func collectionViewController() -> CollectionViewController? {
        let storyboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
        return storyboard.instantiateViewController(identifier: "CollectionViewController", creator: { coder in
            let modelRoomsConfig = self.modelRoomsConfig()
            var modelAppDatchik = self.modelAppDatchik()
            if let userId = UserDefaults.standard.object(forKey: "UserId") as? String {
                let collectionVC =  CollectionViewController(coder: coder, presentationAssembly: self, userId: userId, modelRoomsConfig: modelRoomsConfig, modelRoomDatchik: modelAppDatchik)
                modelRoomsConfig.delegate = collectionVC
                modelAppDatchik.delegate = collectionVC
                return collectionVC
            } else {
                return nil
            }
        })
    }

    func roomsViewController(curentVC: Int) -> RoomsViewController? {
        let storyboard = UIStoryboard(name: "RoomsViewController", bundle: nil)
        return storyboard.instantiateViewController(identifier: "RoomsViewController", creator: { coder in
            let modelRoomsConfig = self.modelRoomsConfig()
            var modelAppDatchik = self.modelAppDatchik()
            if let userId = UserDefaults.standard.object(forKey: "UserId") as? String {
                let roomsVC =  RoomsViewController(coder: coder, presentationAssembly: self, userId: userId, modelRoomsConfig: modelRoomsConfig, modelRoomDatchik: modelAppDatchik, curentVC: curentVC)
                modelRoomsConfig.delegate = roomsVC
                modelAppDatchik.delegate = roomsVC
                return roomsVC
            } else {
                return nil
            }
        })
    }
    private func modelRoomsConfig() -> ModelRoomsConfigProtocol {
        return ModelRoomsConfig(roomConfigService: self.serviceAssembly.roomsConfigService)
    }

    private func modelAppDatchik() -> ModelAppDatchikProtocol {
        return ModelAppDatchik(appDatchikService: self.serviceAssembly.appDatchikService)
    }

    private let serviceAssembly: ServiceAssemblyProtocol

    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }

}
