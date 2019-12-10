//
//  NetworkResponse.swift
//  PracticeEco
//
//  Created by Divum Corporate Services on 7/15/17.
//  Copyright © 2017 Divum Corporate Services. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - NetworkErrorCategory
enum NetworkErrorCategory {
    case unauthorized
    case server
    case unknown
    case connection
    case sessionExpired

    static func errorCategoryForStatusCode(_ statusCode: Int) -> NetworkErrorCategory {
        switch statusCode {
        case 401: //400 ... 499:
            return .unauthorized
        case 440:
            return .sessionExpired
        case 500 ... 599:
            return .server
        default:
            return .unknown
        }
    }
}

// MARK: - NetworkResponse
/**
Base response object generated and returned by an Alamofire response
 
### Properties:
 - **success: `Bool`**: Indicates interpretation of success of network request
 - **responseObject: `<ResponseType>`**?: Strongly typed (and usually parsed) response
 - **error: `NSError`**?: Populated by Alamofrie if an error occurred
 - **responseData: `NSDictionary`?**: raw JSON response in dictionary form
 - **errorCategory: `NetworkErrorCategory`?: Broad error interpretation based on HTTP status code in response
 - **responseType: `Any.Type`**: Type of the responseObject
 - **responseStatusCode: `Int`**: HTTP Status code of the response
*/
struct NetworkResponse<ResponseType> {
    init() {
        self.responseType = ResponseType.self
    }

    var success: Bool = false
    var responseObject: ResponseType?
    var error: NSError?
    var responseData: NSDictionary?
    var errorCategory: NetworkErrorCategory?
    let responseType: Any.Type
    var responseStatusCode: Int?
    var request: URLRequest?
}

// MARK: - Network call handler aliases
typealias NetworkServiceSuccessHandler = (_ statusCode: Int, _ resultSet: AnyObject) -> Void
typealias NetworkServiceFailureHandler = (_ statusCode: Int, _ error: NSError) -> Void

// MARK: - Global funcs

/**
 Convert an AlamoFire network Response object to a NetworkResponse<Void> object, ignoring the payload.
 
 - Parameter response: the response to convert
 
 - Returns: the a NetworkResponse<Void> with fields populated (but not responseObject)
 */
func networkResponseForResponse(_ response: DataResponse<Any>) -> NetworkResponse<Void> {
    return networkResponseForResponse(response, decode: nil)
}

/**
 Convert an AlamoFire network Response object to a NetworkResponse<Void> object, ignoring the payload.
 
 - Parameter response: the response to convert
 - Parameter resultType: The type of the result
 
 - Returns: the a NetworkResponse<ResultType> with fields populated (but not responseObject)
 */
func networkResponseForResponse<ResultType>(_ response: DataResponse<Any>, resultType: ResultType.Type) -> NetworkResponse<ResultType> {
    return networkResponseForResponse(response, decode: nil)
}

/**
 Convert AlamoFire network Response object to NetworkResponse object
 If decode parameter is non-nil it will parse responseObject.
 
 - Parameter response: The response to convert
 - Parameter resultType: The type of the result.  Use Void if none is parsed.
 - Parameter decode: The function to parse the json, if any.  Specifying none causes the response object to not be parsed, and should generally be used with Void
 
 - Returns: A new NetworkResponse of the appropriate type with all the relevant fields populated
 */

func networkResponseForResponse<ResultType>(_ response: DataResponse<Any>, decode: ((_ json: AnyObject) throws -> ResultType)?) -> NetworkResponse<ResultType> {

    var networkResponse = NetworkResponse<ResultType>()

    if let statusCode = response.response?.statusCode {
        networkResponse.responseStatusCode = statusCode
    }

    switch response.result {
    case .success(let json):

        networkResponse.success = true

        if let validDecode = decode {
            do {
                networkResponse.responseObject = try validDecode(json as AnyObject)
            } catch {
                print("Error getting json: \(error)")
            }
        }

        if let dict = json as? NSDictionary {
            networkResponse.responseData = dict
        }

        //Unauthorize status code assumes as success=false
        networkResponse.success = !(NetworkErrorCategory.errorCategoryForStatusCode(networkResponse.responseStatusCode ?? 0) == .sessionExpired)

    case .failure (let error):
        networkResponse.success = false
        networkResponse.error = error as NSError?

        if let statusCode = response.response?.statusCode {
            networkResponse.errorCategory = NetworkErrorCategory.errorCategoryForStatusCode(statusCode)
            networkResponse.responseStatusCode = statusCode
        } else {
            networkResponse.errorCategory = .connection
        }
//        if error.localizedDescription.caseInsensitiveCompare("The Internet connection appears to be offline.") == .orderedSame {
//            UIApplication.showEmtpyScreen(for: .networkError)
//        } else if error.localizedDescription.caseInsensitiveCompare("Could not connect to the server.") == .orderedSame {
//            UIApplication.showEmtpyScreen(for: .serverError)
//        }
    }

    networkResponse.request = response.request

    return networkResponse
}

func customNetworkResponseForResponse<ResultType>(_ response: DataResponse<Any>, resultType: ResultType.Type, decode: ((_ json: AnyObject) throws -> ResultType)?) -> NetworkResponse<ResultType> {
    var networkResponse = NetworkResponse<ResultType>()

    if let statusCode = response.response?.statusCode {
        networkResponse.responseStatusCode = statusCode

        if 200 ... 299 ~= statusCode {
            networkResponse.success = true

            if let validDecode = decode,
                let responseJSON = response.result.value {
                networkResponse.responseObject = try? validDecode(responseJSON as AnyObject)

                if let dict = responseJSON as? NSDictionary {
                    networkResponse.responseData = dict
                }
            }
        } else {
            networkResponse.success = false
            do {
                if let error = response.result.error {
                    networkResponse.error = customErrorFromTransportError(error as NSError)
                } else if let error = response.result.error {
                    networkResponse.error = customErrorFromTransportError(error as NSError)
                }
            }
//            catch { return networkResponse }
        }
    } else if let error = response.result.error {
        networkResponse.error = customErrorFromTransportError(error as NSError)
    }

    return networkResponse
}

func customErrorFromTransportError(_ error: NSError) -> NSError {
    var errorList: [String: String] = [:]
    errorList["\(error.code)"] = error.localizedDescription

    let userInfo = ["errors": errorList]
    return NSError(domain: "com.mobile.PracticeEco", code: 999, userInfo: userInfo)
}

func networkError(fromErrorType errorType: Error) -> NSError {
    return NSError(domain: "com.mobile.PracticeEco", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(errorType)"])
}

func networkResponse<ResultType>(withError error: NSError, resultType: ResultType.Type) -> NetworkResponse<ResultType> {
    var networkResponse = NetworkResponse<ResultType>()
    networkResponse.error = error
    networkResponse.success = false
    return networkResponse
}
