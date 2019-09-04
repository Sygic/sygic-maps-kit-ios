//// SYUIPoiDetailContact.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the &quot;Software&quot;), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import SygicUIKit


/// Supported contact types for poi detail
///
/// - phone: phone contact
/// - email: email contact
/// - website: website url
public enum SYMKPoiDetailContact {
    case phone(_ value: String)
    case email(_ value: String)
    case website(_ value: String)
    
    /// Title for contact detail
    public var title: String {
        switch self {
        case .phone:
            return LS("detail.contact.phone")
        case .email:
            return LS("detail.contact.mail")
        case .website:
            return LS("detail.contact.url")
        }
    }
    
    /// Value for contact detail
    public var value: String {
        switch self {
        case .phone(let value):
            return value
        case .email(let value):
            return value
        case .website(let value):
            return value
        }
    }
    
    /// Icon for contact detail
    public var icon: String {
        switch self {
        case .phone:
            return SYUIIcon.call
        case .email:
            return SYUIIcon.email
        case .website:
            return SYUIIcon.website
        }
    }
    
    /// Contact data source for cell in poi detail
    ///
    /// - Returns: cell data source
    func cellDataSourece() -> SYUIPoiDetailCellDataSource {
        return SYUIPoiDetailCellData(title: self.title, subtitle: self.value, icon: self.icon)
    }
}
