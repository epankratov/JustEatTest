# Answers to technical questions.

1. I've spent 8 hours, and almost all of the time I've spent on networking client and parsing data from JSON. If I had the time, I'd preffer to use Codable framework, which was introduced in Swift 3.1 and higher. But instead, I've implemented manual parsing of JSON data. It was made intentionally: I believe, in that way is more convenient to show some Swift facilities like optionals and so on.
Also, it was convenient to write tests for data parsing which were made in that way. If I had little more time, I'd add some prettiness 
to UI: little bit more animations, more application states and error handling (saying, persist state when data has been tried to load, but was failed) and display those states in user-friendly way.

2. As I've mentioned above, the most powerfull feature is Codable framework. It's possible to use it in folowing way

``` swift
struct Person: Decodable {
  let fullName: String
  let id: Int
  let url: URL
}

let json = """
{
 "fullName": "John Doe",
 "id": 123456,
 "twitter": "http://some.host.com/query"
}
""".data(using: .utf8)! // our data in native (JSON) format
let myFrient = try JSONDecoder().decode(Person.self, from: json) // Decoding our data
print(myFrient) // decoded!!!!!
```

3. In order to profile issues with perfromance developer can use many technics or tools. First of all, XCTest framework allows to write measurement tests. The seconds, but not less important, is XCode Profiles tool (available from instruments). And most advanced thing is to meassure algorhythms used in order to implement application's feature. It's more about Computability and Complexity of algorhythms theory.

4. I've used only one API endpoint, and so much familier with it in order to made suggestions how to improve API. But, returning back to "/restaurants" endpoint, I'd preffer to have some pagination logic to avoid such a bit output data amount.

5. I hope, my previous answers told enough about myself in JSON. I honestly believe, JSON is much more convenient data exchange format for remote communications that other RPC protocols, like SOAP and so one.


