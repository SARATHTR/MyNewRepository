//
//  ContentListViewModel.swift
//  Test Project
//
//  Created by Acemero on 02/09/22.
//

import Foundation
import UIKit

class ContentListViewModel {
    
    var contentListModel: ContentListModel?
    
    func contentListApiCall(pageNumber : Int, completion: (ContentListModel)->()) {
        if let jsonRsponse = loadJson(fileName: "CONTENTLISTINGPAGE-PAGE\(pageNumber)") {
            contentListModel = jsonRsponse
            if contentListModel != nil {
                completion(contentListModel!)
            }
        }
    }
    
    func loadJson(fileName: String) -> ContentListModel? {
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let contentData = try? decoder.decode(ContentListModel.self, from: data)
        else {
            return nil
        }
        return contentData
    }
}
