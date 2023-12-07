//
//  DetailViewController.swift
//  SpaceXApp
//
//  Created by JustMac on 06/12/23.
//

import Foundation
import UIKit
import ImageSlideshow
import SwiftyJSON
import Alamofire
import Kingfisher

class DetailViewController : UIViewController, ImageSlideshowDelegate{
    
    @IBOutlet weak var tblSecondStage: MyOwnTableView!
    @IBOutlet weak var lblMissionID: UILabel!
    @IBOutlet weak var lblMissionName: UILabel!
    @IBOutlet weak var lblMissionDesc: UILabel!
    @IBOutlet weak var lblRecovery: UILabel!
    @IBOutlet weak var lblRocketName: UILabel!
    @IBOutlet weak var lblRocketType: UILabel!
    @IBOutlet weak var lblCoreSerial: UILabel!
    @IBOutlet weak var lblFlight: UILabel!
    @IBOutlet weak var lblBlock: UILabel!
    @IBOutlet weak var lblGridfins: UILabel!
    @IBOutlet weak var lblLegs: UILabel!
    @IBOutlet weak var lblReused: UILabel!
    
    @IBOutlet weak var lblFlightNo: UILabel!
    @IBOutlet weak var lblShips: UILabel!
    @IBOutlet weak var lblSiteID: UILabel!
    @IBOutlet weak var lblSiteName: UILabel!
    @IBOutlet weak var lblArticleLink: UILabel!
    @IBOutlet weak var lblViedoLink: UILabel!
    @IBOutlet weak var lblYoutubeID: UILabel!
    @IBOutlet weak var flickerImages: ImageSlideshow!
    @IBOutlet weak var lblWebcast: UILabel!
    @IBOutlet weak var lblYear: UILabel!
//    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
    var jsonData = SpaceXData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        tblSecondStage.isScrollEnabled = false
        tblSecondStage.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupData()
    {
        print("Details, \(jsonData)")
        var imageSource: [ImageSource] = []
        flickerImages.slideshowInterval = 5.0
        flickerImages.contentScaleMode = UIViewContentMode.scaleToFill
        flickerImages.delegate = self
        lblSiteName.text = jsonData.launchSiteName
        lblSiteID.text = jsonData.siteID
        lblRocketName.text = "Rocket Name :\(jsonData.rocketName)"
        lblRocketType.text = "Rocket Type :\(jsonData.rocketType)"
        lblMissionName.text = jsonData.missionName
        lblMissionDesc.text = jsonData.details
        lblYear.text = "\(jsonData.launchYear)"
        lblFlightNo.text = jsonData.flightNo
        lblViedoLink.text = jsonData.videoLink
        lblMissionID.text = jsonData.missionID != "" ? "Mission ID : \(jsonData.missionID)" : ""
        lblYoutubeID.text = "Youtube ID : \(jsonData.videoID)"
        lblCoreSerial.text = "Core serial : \(jsonData.coreSerial)"
        lblLegs.text = jsonData.legs != "" ? "Legs : \(jsonData.legs)" : ""
        lblFlight.text = jsonData.flight != "" ? "Flight : \(jsonData.flight)" : ""
        lblBlock.text = jsonData.block != "" ? "Block : \(jsonData.block)" : ""
        lblReused.text = jsonData.reused != "" ? "Reused : \(jsonData.reused)" : ""
        lblGridfins.text = jsonData.gridfins != "" ? "Gridfins : \(jsonData.gridfins)" : ""
        lblWebcast.text = "TimeLine Web cast : \(jsonData.webCast)"
        lblRecovery.text = jsonData.recoveryAttempt != "" ? "Recovery Attempt : \(jsonData.recoveryAttempt)" : ""
        lblShips.text = jsonData.ships.count != 0 ? "Ships : \(jsonData.ships)" : ""
        lblArticleLink.text = jsonData.articleLink != "" ? "Article Link : \(jsonData.articleLink)" : ""
        if(jsonData.imagLaunch.count != 0){
            for imagePath in jsonData.imagLaunch
            {
                let imageName = imagePath.description.replacingOccurrences(of: " ", with: "%20")
                AF.request(imageName).response
                { response in
                    guard let image = UIImage(data:response.data!)
                    else
                    {
                        return
                    }
                    imageSource.append(ImageSource(image: image))
                    self.flickerImages.setImageInputs(imageSource)
                }
            }
        }else{
            imageSource.append(ImageSource(image: UIImage(named: "image_placeholder_white")!))
            self.flickerImages.setImageInputs(imageSource)
        }
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData.payloadArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RocketCell", for: indexPath) as! RocketCell
        cell.selectedBackgroundView = UIView()
        let cellObj = jsonData.payloadArr[indexPath.row]
        cell.lblCustomer.text = "Customers : \(cellObj.customers)"
        cell.lblManufacture.text = "Manufactures : \(cellObj.manufacture)"
        cell.lblNationality.text = "Nationality : \(cellObj.nationality)"
        cell.lblPayloadType.text = "Payload Type : \(cellObj.payloadType)"
        cell.lblRefernceSys.text = "Reference System : \(cellObj.referenceSystem)"
        cell.lblRegime.text = "Regime : \(cellObj.regime)"
        cell.lblPayloadId.text = "Payload ID : \(cellObj.payloadID)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
     return 90
    }
    
}
class MyOwnTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.layoutIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
