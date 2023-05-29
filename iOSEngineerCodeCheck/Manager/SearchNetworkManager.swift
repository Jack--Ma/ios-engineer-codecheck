//
//  SearchNetworkManager.swift
//  iOSEngineerCodeCheck
//
//  Created by jackma on 2023/5/28.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import Alamofire

class SearchNetworkManager {
    private var request: DataRequest?
    
    public func requestSearchList(_ searchWord: String?,
                                  completionHandler: @escaping (SearchListModel?, AFError?) -> Void) {
        guard let searchWord = searchWord, searchWord.count != 0 else { return }
        guard let searchRequestURL = SearchUtils.searchRequestURL else { return }
        self.cancelRequest()
        
        let param: [String:String] = ["q":searchWord]
        
        request = AF.request(searchRequestURL, parameters: param)
        request?.responseDecodable(of:SearchListModel.self) { response in
            if let listModel = try? response.result.get() {
                completionHandler(listModel, response.error)
            } else {
                completionHandler(nil, response.error)
            }
        }
    }
    
    public func cancelRequest() {
        request?.cancel()
    }
}
