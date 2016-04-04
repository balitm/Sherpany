//
//  DataProvider.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/31/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

class DataProviderBase: NSObject {
    enum DataProviderType {
        case Async
        case AsyncSession
    }

    enum DataProcessorType {
        case Json
        case Xml
    }

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
    class func dataProvider(providerType: DataProviderType, processorType: DataProcessorType, urls: DataURLs) -> DataProviderProtocol {
        var provider: DataProviderProtocol

        switch providerType {
        case .Async:
            provider = AsyncDataProvider()
        case .AsyncSession:
            provider = AsyncSessionDataProvider()
            (provider as! AsyncSessionDataProvider).urls = urls
        }

        switch processorType {
        case .Json:
            provider.dataProcessor = JsonDataProcessor()
        default:
            assert(false)
            provider.dataProcessor = JsonDataProcessor()
        }

        return provider
    }
}
