import Foundation

public struct IPLanguage {
    var code: String?
    var code2: String?   
    var name: String?          
    var nativeName: String? 
    var rtl: Bool?    

    static func fromJSON(json: Any?) -> Any? {
        if json is NSArray {
            let arr = json as! NSArray
            var result = [IPLanguage]()
            for entry in arr {
                let e = entry as? NSDictionary
                var item = IPLanguage()
                item.code = e!["code"] as? String 
                item.code2 = e!["code2"] as? String 
                item.name = e!["name"] as? String 
                item.nativeName = e!["native_name"] as? String 
                item.rtl = e!["rtl"] as? Bool 
                result.append(item)
            }
            return result
        }
        return nil
    }
}
