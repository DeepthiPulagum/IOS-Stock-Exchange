
import UIKit

@objc protocol SymbolDetailsDelegate {
    
    func ModelDidFinishWithDetails(symbole : String,ask :String,change:String)
    
}

@objc class SymbolDetailsModel : NSObject{
    
    var delegat : SymbolDetailsDelegate?
    
    func lookUpForSymbolDetails(text : String)  {
        DispatchQueue.global(qos: .background).async {
            let stringUrl : String = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20%3D%20%22\(text)%22&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json"
            let url = URL(string: stringUrl)
            do{
                let jsonString = try String(contentsOf: url!)
                let jsonData = jsonString.data(using: String.Encoding.utf8)
                let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
                if jsonDictionary != nil {
                    let results = jsonDictionary?["query"]?["results"] as? [String : AnyObject]
                     let resultArray2 = results!["quote"] as? [String: AnyObject]
                    var symbolD = resultArray2?["symbol"] as? String
                    var askD = resultArray2?["Ask"] as? String
                    var changeD = resultArray2?["Change"] as? String
                    DispatchQueue.main.async {
                        if askD == nil
                        { askD = "Not Available"}
                        if symbolD == nil
                        { symbolD = "Not Available"}
                        if changeD == nil
                        {changeD = "Not Available"}
                        
                        self.delegat?.ModelDidFinishWithDetails(symbole: symbolD!, ask: askD!, change: changeD!)
                    }
                }
            }
            catch _{
                print("error here")
            }
        }
    }
}
