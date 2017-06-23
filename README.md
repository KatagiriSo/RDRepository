# RDRepository
This is a class library of API calls made with Swift.

Let's call Wikipedia's API as an example.

we make RDWikipediaRecord and RDWikipediaCache.
```swift
struct RDWikipediaRecord : RDRecord {
...
```


```swift
class RDWikipediaCache : RDCache<[RDWikipediaRecord], RDWikipediaOperation> {
    
}
```

Finally, we create an RDWikipediaOperation and define the contents of load.

```swift
class RDWikipediaOperation : RDLoadOperation<[RDWikipediaRecord]> {
    
    private let semaphore:DispatchSemaphore = DispatchSemaphore(value: 0)
    private var result:(Any?, URLResponse?, Error?)? = nil
    
    override func getError() -> Error? {
        return result?.2
    }
    
    override func main() {
        let result = load()
        if let raw = result?.0 {
            let json = JSONValue.wrap(json: raw)
            if let jsonlist:[JSONValue] = json.dictionary!["query"]?.dictionary?["random"]?.array {
                let records = jsonlist.flatMap { RDWikipediaRecord(raw: $0) }
                data = records
            }
        }
    }
    
    func load() -> (Any?, URLResponse?, Error?)? {
        
        let url_ns = NSURL(string: "https://ja.wikipedia.org/w/api.php?action=query&list=random&rnnamespace=0&rnlimit=10&format=json&utf8=")!
        let url = url_ns.absoluteURL!
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.setValue("SampleApp", forHTTPHeaderField: "User-Agent")
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] (data, response, error_) in
                        
            var json:Any? = nil
            var error = error_
            if let data = data {
                do {
                    let json_ = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    json = json_
                } catch let e {
                    error = e
                }
            }
            
            self?.result = (json, response, error)
            self?.semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        
        
        
        return result
    }
```

The user calls load using RDCache as follows.

```swift
class RDWikipediaManager {
    static let share:RDWikipediaManager = RDWikipediaManager()
    
    let cache:RDWikipediaCache = RDWikipediaCache(expireInterval:0.0, operationBlock:{
        return RDWikipediaOperation()
    })
    
    private init() {
        
    }
    
    func loadList(completion:@escaping ([RDWikipediaRecord]?,Error?) -> Void) {
        cache.load(completion: completion)
    }
```
