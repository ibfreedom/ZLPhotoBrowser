//
//  ZLError.swift
//  ZLPhotoBrowser
//
//  Created by iferret's on 2023/2/3.
//

import Foundation

enum ZLError {
    /// 自定义错误
    case custom(_ message: String)
}

extension ZLError: Error, LocalizedError {
    
    /// errorDescription
    internal var errorDescription: String? {
        switch self {
        case .custom(let message):
            return message
        }
    }
    
    /// localizedDescription
    internal var localizedDescription: String {
        switch self {
        case .custom(let message):
            return message
        }
    }
}
