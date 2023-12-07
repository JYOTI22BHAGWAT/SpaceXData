//
//  SpaceXModel.swift
//  SpaceXApp
//
//  Created by JustMac on 04/12/23.
//

import Foundation

struct SpaceXData {
    var missionName = String()
    var rocketName = String()
    var launchSiteName = String()
    var launchDate = String()
    var imagLaunch = [String]()
    var launchYear = String()
    var flightID = String()
    var rocketType = String()
    var coreSerial = String()
    var flight = String()
    var payloadArr = [PayloadStage]()
    var legs = String()
    var details = String()
    var gridfins = String()
    var reused = String()
    var ships = String()
    var missionID = String()
    var flightNo = String()
    var siteID = String()
    var videoLink = String()
    var block = String()
    var landIntend = String()
    var recoveryAttempt = String()
    var webCast = String()
    var missionPatch = String()
    var articleLink = String()
    var videoID = String()
}

struct PayloadStage {
    var customers = String()
    var nationality = String()
    var manufacture = String()
    var orbit = String()
    var referenceSystem = String()
    var payloadType = String()
    var regime = String()
    var payloadID = String()
}
