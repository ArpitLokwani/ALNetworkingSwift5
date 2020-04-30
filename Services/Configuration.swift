//
//  Configuration.swift
//  ALNetworking
//
//  Created by Arpit Lokwani on 29/04/20.
//  Copyright © 2020 Arpit Lokwani. All rights reserved.
//

import Foundation


struct Configuration {
    lazy var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of: "Staging") != nil {
                return Environment.Staging
            }
        }

        return Environment.Production
    }()
}
//https://reqres.in/api/users
enum Environment: String {
    case Staging = "staging"
    case Production = "production"

    var baseURL: String {
        switch self {
        case .Staging: return "https://reqres.in/"
        case .Production: return "https://reqres.in/"
        }
    }
    var method: String {
        switch self {
        case .Staging: return "api/users"
        case .Production: return "api/users"
        }
    }

    var token: String {
        switch self {
        case .Staging: return "lktopir156dsq16sbi8"
        case .Production: return "5zdsegr16ipsbi1lktp"
        }
    }
}
