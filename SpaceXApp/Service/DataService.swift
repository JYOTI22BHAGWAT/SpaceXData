//
//  DataService.swift
//  MVVM Alamofire
//
//  Created by Arifin Firdaus on 7/12/18.
//  Copyright © 2018 Arifin Firdaus. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RappleProgressHUD
import KSToastView

struct ApiManager {
    
    // MARK: - Singleton
    static let shared = ApiManager()
    
    // MARK: - Services
    func requestAPI(with url: String, runLoader: Bool, showError : Bool, completion:@escaping (_ response:JSON, _ success: Bool) -> Void) {
        var urlString = url
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading", attributes: RappleModernAttributes)
            AF.request(urlString, method: .get, headers: nil) .responseJSON { responseObject in
                      switch(responseObject.result) {
                      case .success(_):
                          if responseObject.value != nil {
                              if runLoader {
                                   //Progress.instance.hide()
                                  DispatchQueue.main.async {
                                      RappleActivityIndicatorView.stopAnimation(completionIndicator: .none, completionLabel: "", completionTimeout: 0.1)
                                  }
                              }
                              debugPrint(responseObject.value as Any)
                              let statusCode = responseObject.response?.statusCode
                              let result = JSON(responseObject.value!)
                              if statusCode == 200 {
                                  completion(result, true)
                              }else if statusCode == 204 && showError {
                                if showError {
                                    self.errorHandling(errorCode: statusCode!, errorMessage: "Something went wrong, Please try again.", JSON: [:])
                                }
                              }
                          } else if showError {
                              KSToastView.ks_showToast(responseObject.error!.localizedDescription, duration: 4.0)
                          }
                          break
                      case .failure(let error):
                            if runLoader {
                                DispatchQueue.main.async {
                                    RappleActivityIndicatorView.stopAnimation(completionIndicator: .none, completionLabel: "", completionTimeout: 0.1)
                                }
                            }
                            if showError {
                                print(urlString)
//                                print(paramters)
                                print(error.localizedDescription)
                                KSToastView.ks_showToast(error.localizedDescription, duration: 4.0)
                            }
                          break
                      }
                  }
        
    }
    
    //MARK:- ERROR Handling Method
    func errorHandling(errorCode: Int, errorMessage:String,JSON:JSON) {
        if errorCode == 401 {
            KSToastView.ks_showToast(errorMessage, duration: 4.0)
        } else if errorCode == 426{
            KSToastView.ks_showToast(errorMessage, duration: 4.0)
        } else {
            KSToastView.ks_showToast(errorMessage, duration: 4.0)
        }
    }
    
}
