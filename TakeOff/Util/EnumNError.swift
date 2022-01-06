//
//  EnumNError.swift
//  TakeOff
//
//  Created by Jun on 2022/01/06.
//

import Foundation

public struct TakeOffError: Error {
    var msg: String
}

extension TakeOffError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(msg, comment: "")
    }
}
