//
//  ViewController.swift
//  SpaceXApp
//
//  Created by JustMac on 04/12/23.
//

import UIKit
import Alamofire
import KSToastView
import SwiftyJSON
import Kingfisher

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
class ViewController: UIViewController {

    @IBOutlet weak var tblSpaceX: UITableView!
    var spaceXList = [SpaceXData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        getSpaceXDataAPI()
    }

    
    func getSpaceXDataAPI(){
        if !Connectivity.isConnectedToInternet() {
//                self.hud.dismiss(afterDelay: 3.0)
            KSToastView.ks_showToast("No Internet Connection.")
        }else {
            let urlString = APIConstants.getSpaceX
            
            ApiManager().requestAPI(with: urlString, runLoader: true, showError: true) { (jsonResponse, success) in
//                print(jsonResponse)
                if success {
                    let jsonData = JSON(jsonResponse)
                    if(jsonData.count != 0){
//                        KSToastView.ks_showToast(jsonResponse["responsemessage"].stringValue, duration: 4.0)
                        
//                        let data = jsonData["data"]
                        self.spaceXList.removeAll()
                       
                            for i in 0...jsonData.count-1  {
                                let newSpace = jsonData[i]
                                var spaceXObj = SpaceXData()
                                let rocketObj = newSpace["rocket"].dictionaryValue
                                let launchObj = newSpace["launch_site"].dictionaryValue
                                let imgArray = newSpace["links"].dictionaryValue
                                let dateString = newSpace["launch_date_local"].stringValue
                                let dateFormatterGet = DateFormatter()
                                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                let dateFormatterPrint = DateFormatter()
                                dateFormatterPrint.dateFormat = "yyyy-MM-dd"
                                let date: Date? = dateFormatterGet.date(from: dateString)
                                let launDate = dateFormatterPrint.string(from: date!)
                                let fairingObj = rocketObj["fairings"]?.dictionaryValue["recovery_attempt"]?.stringValue
                                let firstStageCoreObj = rocketObj["first_stage"]?.dictionaryValue
                                let SecondStageObj = rocketObj["second_stage"]?.dictionaryValue
                                let ships = newSpace["ships"].arrayValue
                                let missionIDs = newSpace["mission_id"].arrayValue
                                let flickerImage = imgArray["flickr_images"]?.arrayValue
                                var shipNames = String()
                                if(ships.count != 0){
                                    for i in 0...ships.count-1{
                                        shipNames += ships[i].stringValue
                                        shipNames += ","
                                    }
                                    shipNames.removeLast()
                                }
                                var missionID = String()
                                if(missionIDs.count != 0){
                                    for i in 0...missionIDs.count-1{
                                        missionID += missionIDs[i].stringValue
                                        missionID += ","
                                    }
                                    missionID.removeLast()
                                }
                                let payloads = SecondStageObj?["payloads"]?.arrayValue
                                let coreData = firstStageCoreObj?["cores"]?.arrayValue
                                var payloadNew = [PayloadStage]()
                                if(payloads?.count != 0){
                                    
                                    for i in 0...(payloads?.count ?? 1)-1 {
                                        var secondObj = PayloadStage()
                                        let payloadObj = payloads?[i].dictionaryValue
                                        let custArray = payloadObj?["customers"]?.arrayValue
                                        var customers = String()
                                        if(custArray?.count != 0){
                                            for i in 0...(custArray?.count ?? 1)-1{
                                                customers += custArray?[i].stringValue ?? ""
                                                customers += ","
                                            }
                                            customers.removeLast()
                                        }
                                        secondObj.customers = customers
                                        secondObj.manufacture = payloadObj?["manufacturer"]?.stringValue ?? ""
                                        secondObj.nationality = payloadObj?["nationality"]?.stringValue ?? ""
                                        secondObj.payloadType = payloadObj?["payload_type"]?.stringValue ?? ""
                                        secondObj.orbit = payloadObj?["orbit"]?.stringValue ?? ""
                                        secondObj.referenceSystem = payloadObj?["orbit_params"]?.dictionaryValue["reference_system"]?.stringValue ?? ""
                                        secondObj.payloadID = payloadObj?["payload_id"]?.stringValue ?? ""
                                        secondObj.regime = payloadObj?["orbit_params"]?.dictionaryValue["regime"]?.stringValue ?? ""
                                        payloadNew.append(secondObj)
                                    }
                                }
                               
                                spaceXObj.recoveryAttempt = fairingObj ?? ""
                                spaceXObj.flightNo = newSpace["flight_number"].stringValue
                                spaceXObj.missionName = "\(newSpace["mission_name"].stringValue)"
                                spaceXObj.rocketName = rocketObj["rocket_name"]!.stringValue
                                spaceXObj.launchDate = "\(launDate)"
                                spaceXObj.missionID = missionID
                                spaceXObj.launchSiteName = launchObj["site_name"]!.stringValue
                                spaceXObj.siteID = launchObj["site_id"]!.stringValue
                                spaceXObj.videoID = imgArray["youtube_id"]?.stringValue ?? ""
                                spaceXObj.details = (newSpace["details"].stringValue)
                                spaceXObj.payloadArr = payloadNew
                                if(coreData?.count != 0){
                                    guard let newCoreValue = coreData?[0].dictionaryValue else {
                                        return
                                    }
                                    spaceXObj.coreSerial = newCoreValue["core_serial"]?.stringValue ?? ""
                                    spaceXObj.flight = newCoreValue["flight"]?.stringValue ?? ""
                                    spaceXObj.legs = newCoreValue["legs"]?.stringValue ?? ""
                                    spaceXObj.gridfins = newCoreValue["gridfins"]?.stringValue ?? ""
                                    spaceXObj.reused = newCoreValue["reused"]?.stringValue ?? ""
                                    
                                }
                                let timeline = newSpace["timeline"].dictionaryValue["webcast_liftoff"]?.stringValue ?? ""
                                spaceXObj.ships = shipNames
                                spaceXObj.webCast = timeline
                                spaceXObj.rocketType = rocketObj["rocket_type"]?.stringValue ?? ""
                                spaceXObj.articleLink = imgArray["article_link"]?.stringValue ?? ""
                                spaceXObj.missionPatch = imgArray["mission_patch"]?.stringValue ?? ""
                                spaceXObj.videoLink = imgArray["video_link"]?.stringValue ?? ""
                                spaceXObj.launchYear = newSpace["launch_year"].stringValue
                                var imgFliterArr = [String]()
                                if(flickerImage?.count != 0 ){
                                    for i in 0...(flickerImage?.count ?? 1)-1{
                                        imgFliterArr.append(flickerImage?[i].stringValue ?? "")
                                    }
                                }
                                spaceXObj.imagLaunch = imgFliterArr
                                self.spaceXList.append(spaceXObj)
                            }
                        self.tblSpaceX.reloadData()
                    }else {
                        KSToastView.ks_showToast(jsonResponse["responsemessage"].stringValue, duration: 4.0)
                    }
                }
            }
        }
    }
}
extension Date {
    static func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        let date: Date? = dateFormatterGet.date(from: "2018-02-01T19:10:04+00:00")
//        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }
}

extension ViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spaceXList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpaceXCell", for: indexPath) as! SpaceXCell
        cell.selectedBackgroundView = UIView()
        let cellObj = spaceXList[indexPath.row]
        cell.mainView.layer.shadowColor =  #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        cell.mainView.layer.shadowOffset = CGSize(width: 0 , height:2)
        cell.mainView.layer.shadowOpacity = 0.7
        cell.mainView.layoutIfNeeded()
        cell.mainView.layer.cornerRadius = 10
//        cell.mainView.layer.borderColor = UIColor.black.cgColor
//        cell.mainView.layer.borderWidth = 1
        
        cell.imgLaunch.layer.cornerRadius = 5
        cell.imgLaunch.layer.borderColor = UIColor.gray.cgColor
        cell.imgLaunch.layer.borderWidth = 1
        
        cell.lblMissionName.text = cellObj.missionName
        cell.lblRocketName.text = cellObj.rocketName
        cell.lblDateLaunch.text = cellObj.launchDate
        cell.lblLSiteNameName.text = cellObj.launchSiteName
//        if(cellObj.imagLaunch.count != 0){
            cell.imgLaunch.kf.setImage(with: URL(string: cellObj.missionPatch), placeholder: UIImage(named: "image_placeholder_white"), options: nil, progressBlock: nil) { (result) in
                
            }
//        }
        cell.imgLaunch.image = UIImage(named: "image_placeholder_white")
        cell.imgLaunch.contentMode = .scaleAspectFill
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        vc.jsonData =  spaceXList[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.jsonData =  spaceXList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
