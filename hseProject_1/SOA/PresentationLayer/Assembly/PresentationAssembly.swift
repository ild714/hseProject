//
//  PresentationAssembly.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol PresentationAssemblyProtocol {
    func collectionViewController() -> CollectionViewController?
    func roomsViewController(curentVC: Int, roomNumbersAndNames: [Int: String], resultDatchik: [String: JSON], currentRoomData: CurrentRoomData?) -> RoomsViewController?
    func scriptsViewController() -> ScriptsViewController?
    func newScriptViewController(scriptCreator: JSON) -> NewScriptViewController?
    func scriptForRoomViewController(scriptCreator: JSON, roomNumbers: [Int]) -> ScriptForRoomViewController?
    func scriptForDaysViewController(scriptCreator: JSON, daysString: [String]) -> ScriptForDaysViewController?
    func scriptServiceViewController(scriptCreator: JSON, previousRoomId: Int, previousDayId: Int) -> ScriptServiceViewController?
    func currentRoomsViewController(scriptCreator: JSON, rooms: [Int], dynamicIntForRooms: Int) -> ScriptCurrentRoomsViewController?
    func currentDaysViewController(scriptCreator: JSON, indexOfRooms: Int) -> ScriptCurrentDaysViewController?
}

class PresentationAssembly: PresentationAssemblyProtocol {

    func collectionViewController() -> CollectionViewController? {
        let storyboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
        return storyboard.instantiateViewController(identifier: "CollectionViewController", creator: { coder in
            let modelRoomsConfig = self.modelRoomsConfig()
            var modelAppDatchik = self.modelAppDatchik()
//            var modelAimData = self.modelAimData()
            if let userEmail = UserDefaults.standard.object(forKey: "UserEmail") as? String {
                let collectionVC =  CollectionViewController(
                    coder: coder,
                    presentationAssembly: self,
                    userId: userEmail,
                    modelRoomsConfig: modelRoomsConfig,
                    modelRoomDatchik: modelAppDatchik)
//                modelAimData.delegate = collectionVC
                modelRoomsConfig.delegate = collectionVC
                modelAppDatchik.delegate = collectionVC
                return collectionVC
            } else {
                return nil
            }
        })
    }

    func roomsViewController(curentVC: Int, roomNumbersAndNames: [Int: String], resultDatchik: [String: JSON], currentRoomData: CurrentRoomData?) -> RoomsViewController? {
        let storyboard = UIStoryboard(name: "RoomsViewController", bundle: nil)
        var modelAimData = self.modelAimData()
        return storyboard.instantiateViewController(identifier: "RoomsViewController", creator: { coder in
            if let userId = UserDefaults.standard.object(forKey: "UserEmail") as? String {
                let roomsVC =  RoomsViewController(coder: coder,
                                                   presentationAssembly: self,
                                                   userId: userId,
                                                   curentVC: curentVC,
                                                   roomNumbersAndNames: roomNumbersAndNames,
                                                   resultDatchik: resultDatchik,
                                                   currentRoomData: currentRoomData,
                                                   modelAimData: modelAimData)
                modelAimData.delegate = roomsVC
                return roomsVC
            } else {
                return nil
            }
        })
    }
    func scriptsViewController() -> ScriptsViewController? {
        let storyboard = UIStoryboard(name: "ScriptsViewController", bundle: nil)
        return storyboard.instantiateViewController(identifier: "ScriptsViewController", creator: { coder in
                let scriptsVC =  ScriptsViewController(coder: coder, presentationAssembly: self)
                return scriptsVC
        })
    }
    func newScriptViewController(scriptCreator: JSON) -> NewScriptViewController? {
        let storyboard = UIStoryboard(name: "NewScriptViewController", bundle: nil)
        return storyboard.instantiateViewController(identifier: "NewScriptViewController", creator: { coder in
                let newScriptVC =  NewScriptViewController(coder: coder, presentationAssembly: self, scriptCreator: scriptCreator)
                return newScriptVC
        })
    }
    func scriptForRoomViewController(scriptCreator: JSON, roomNumbers: [Int]) -> ScriptForRoomViewController? {
        let storyboard = UIStoryboard(name: "ScriptForRoomViewController", bundle: nil)
        return storyboard.instantiateViewController(identifier: "ScriptForRoomViewController", creator: { coder in
            let modelRoomsConfig = self.modelRoomsConfig()
            let scriptForRoomVC =  ScriptForRoomViewController(coder: coder, presentationAssembly: self, modelRoomsConfig: modelRoomsConfig, scriptCreator: scriptCreator, roomNumbers: roomNumbers )
            modelRoomsConfig.delegate = scriptForRoomVC
            return scriptForRoomVC
        })
    }
    func scriptForDaysViewController(scriptCreator: JSON, daysString: [String]) -> ScriptForDaysViewController? {
        let storyboard = UIStoryboard(name: "ScriptForDaysViewController", bundle: nil)
        return storyboard.instantiateViewController(identifier: "ScriptForDaysViewController", creator: { coder in
            let scriptForDaysVC =  ScriptForDaysViewController(coder: coder, presentationAssembly: self, scriptCreator: scriptCreator, daysString: daysString)
            return scriptForDaysVC
        })
    }
    func scriptServiceViewController(scriptCreator: JSON, previousRoomId: Int, previousDayId: Int) -> ScriptServiceViewController? {
        let storyboard = UIStoryboard(name: "ScriptServiceViewController", bundle: nil)
        return storyboard.instantiateViewController(identifier: "ScriptServiceViewController", creator: { coder in
            let scriptServiceVC =  ScriptServiceViewController(coder: coder, scriptCreator: scriptCreator, previousRoomId: previousRoomId, previousDayId: previousDayId)
            return scriptServiceVC
        })
    }
    func currentRoomsViewController(scriptCreator: JSON, rooms: [Int] = [], dynamicIntForRooms: Int) -> ScriptCurrentRoomsViewController? {
        let storyboard = UIStoryboard(name: "CurrentRoomsViewController", bundle: nil)
        let modelRoomsConfig = self.modelRoomsConfig()
        return storyboard.instantiateViewController(identifier: "CurrentRoomsViewController", creator: { coder in
            let currentRoomsVC = ScriptCurrentRoomsViewController(
                coder: coder,
                presentationAssembly: self,
                modelRoomsConfig: modelRoomsConfig,
                scriptCreator: scriptCreator,
                dynamicIntForRooms: dynamicIntForRooms)
            modelRoomsConfig.delegate = currentRoomsVC
            return currentRoomsVC
        })
    }
    func currentDaysViewController(scriptCreator: JSON, indexOfRooms: Int) -> ScriptCurrentDaysViewController? {
        let storyboard = UIStoryboard(name: "ScriptCurrentDaysViewController", bundle: nil)
        return storyboard.instantiateViewController(identifier: "ScriptCurrentDaysViewController", creator: { coder in
            let currentRoomsVC = ScriptCurrentDaysViewController(coder: coder, presentationAssembly: self, scriptCreator: scriptCreator, indexOfRooms: indexOfRooms)
            return currentRoomsVC
        })
    }
    private func modelRoomsConfig() -> ModelRoomsConfigProtocol {
        return ModelRoomsConfig(roomConfigService: self.serviceAssembly.roomsConfigService)
    }

    private func modelAppDatchik() -> ModelAppDatchikProtocol {
        return ModelAppDatchik(appDatchikService: self.serviceAssembly.appDatchikService)
    }

    private func modelAimData() -> ModelAimDataProtocol {
        return ModelAimData()
    }

    private let serviceAssembly: ServiceAssemblyProtocol

    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
}
