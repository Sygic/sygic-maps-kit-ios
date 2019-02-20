
/// Define API keys for using Sygic Maps SDK.
/// Obtain keys - http://www.sygic.com/enterprise/get-api-key/
public class SYMKApiKeys {

    static private(set) var appKey = ""
    static private(set) var appSecret = ""
    
    /// Set application key and application secret obtained by Sygic SDK.
    ///
    /// - Parameters:
    ///   - appKey: Application key.
    ///   - appSecret: Application secret.
    static public func set(appKey: String, appSecret: String) {
        SYMKApiKeys.appKey = appKey
        SYMKApiKeys.appSecret = appSecret
    }
    
}
