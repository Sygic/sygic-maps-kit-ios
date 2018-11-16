public class SYMKApiKeys {
    
    static var appKey = ""
    static var appSecret = ""
    
    class public func set(appKey: String, appSecret: String) {
        SYMKApiKeys.appKey = appKey
        SYMKApiKeys.appSecret = appSecret
    }
    
}
