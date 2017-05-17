//
//  YahooLookUpModel.swift
//  RaniaArbash'sProject
//
//  Created by Rania on 2016-12-15.
//  Copyright © 2016 Rania. All rights reserved.
//

import UIKit

@objc protocol YahooSearchDelegate {

    func SearchDidFinishWithResult(result : NSArray)
    func searchFinished()
    
}
@objc class YahooLookUpModel : NSObject{
    
    var delegat : YahooSearchDelegate?
    
    func lookUpForSymbol(text : String)  {
        
        DispatchQueue.global(qos: .background).async {

        let stringUrl : String = "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=\(text)&region=1&lang=en&callback=YAHOO.Finance.SymbolSuggest.ssCallback"
        let url = URL(string: stringUrl)
        do{
        var jsonString = try String(contentsOf: url!)

            
            let index = jsonString.index(jsonString.startIndex, offsetBy: 39)
            
          jsonString = jsonString.substring(from: index)
           
            let index2 = jsonString.index(jsonString.endIndex, offsetBy: -2)
            
            jsonString = jsonString.substring(to: index2)
            
            let jsonData = jsonString.data(using: String.Encoding.utf8)
            
            let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
            
            if jsonDictionary != nil {
                let results = jsonDictionary?["ResultSet"]
              
                let resultArray = results?["Result"] as! NSArray
                DispatchQueue.main.async {
                    self.delegat?.searchFinished()
                    self.delegat?.SearchDidFinishWithResult(result: resultArray)
                    print(resultArray)
                }
            }
        }
        catch _{
            print("error here")
        }
    }
    }
}
