//
//  DataProvider.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/31/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

class DataProviderBase: NSObject {
    // Errors to handle via throw/catch.
    enum Error: ErrorType {
        case URLFormat
    }

    // Possible network statuses.
    enum Status {
        case kNetNoop
        case kNetExecuting
        case kNetFinished
        case kNetNoHost
        case kNetError
    }

    var status = Status.kNetNoop
    var dataProcessor: DataProcessorProtocol! = nil


    // Factory method.
    class func dataProvider(config: ConfigProtocol) -> DataProviderProtocol {
        var provider: DataProviderProtocol

        switch config.kProviderType {
        case .Async:
            provider = AsyncDataProvider()
        case .AsyncSession:
            provider = AsyncSessionDataProvider()
            provider.setup(config)
        case .Alamofire:
            provider = AlamofireDataProvider()
            provider.setup(config)
        }

        switch config.kProcessorType {
        case .Json:
            provider.dataProcessor = JsonDataProcessor()
        case .SwiftyJson:
            provider.dataProcessor = SwiftyJsonDataProcessor()
        default:
            assert(false)
            provider.dataProcessor = JsonDataProcessor()
        }

        return provider
    }
}
