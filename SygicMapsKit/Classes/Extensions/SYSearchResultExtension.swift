//// SYSearchResultExtension.swift
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
import SygicMaps
import SygicUIKit


extension SYSearchResult: SYUIDetailCellDataSource {
    public var height: CGFloat {
        return 60
    }
    
    public var detailCellTitle: NSMutableAttributedString? {
        let title = self.title?.value ?? "\(type)"
        let highlights = (self.title?.highlights ?? []).compactMap { $0.rangeValue }
        
//        guard let mapResult = self as? SYMapSearchResult else {
//            return NSMutableAttributedString(string: title, attributes: SYSearchResult.defaultTitleAttributes)
//        }
//
//        if mapResult.mapResultType == .poiCategory || mapResult.mapResultType == .poiCategoryGroup {
//            if let poiCategory = mapResult.resultLabels.poiCategory?.value, !poiCategory.isEmpty {
//                title = poiCategory
//            } else if let poiGroup = mapResult.resultLabels.poiCategoryGroup?.value, !poiGroup.isEmpty {
//                title = poiGroup
//            }
//        } else if mapResult.mapResultType == .poi {
//            if let poi = mapResult.resultLabels.poi?.value {
//                title = poi
//            }
//        } else {
//            if let street = mapResult.resultLabels.street?.value, !street.isEmpty {
//                title = street
//                if let addressPoint = mapResult.resultLabels.addressPoint?.value, addressPoint.count > 0 {
//                    title += " \(addressPoint)"
//                }
//            } else {
//                if let city = mapResult.resultLabels.city?.value {
//                    title = city
//                }
//            }
//        }
        
        if self is SYSearchAutocompleteResult {
            let highlightedTitle = NSMutableAttributedString(string: title, attributes: SYSearchResult.defaultTitleAttributes)
            for highlight in highlights {
                highlightedTitle.addAttribute(.font, value: SYUIFont.with(.bold, size: SYUIFontSize.headingOld)!, range: highlight)
            }
            return highlightedTitle
        }
        
        return NSMutableAttributedString(string: title, attributes: SYSearchResult.defaultTitleAttributes)
    }
    
    public var detailCellSubtitle: NSMutableAttributedString? {
        var title: String? = subtitle
//        if let mapResult = self as? SYMapSearchResult {
//            if mapResult.mapResultType == .poiCategory || mapResult.mapResultType == .poiCategoryGroup {
//                return nil
//            }
//            if let city = mapResult.resultLabels.city?.value, let country = mapResult.resultLabels.country?.value {
//                title = "\(city), \(country)"
//            }
//        }
        guard let subtitle = title else { return nil }
        return NSMutableAttributedString(string: subtitle, attributes: SYSearchResult.defaultSubtitleAttributes)
    }
    
    public var leftIcon: SYUIDetailCellIconDataSource? {
        var icon = SYUIIcon.pinPlace
        var color: UIColor = .textBody
        var categoryTag: String?
        if let autocomplete = self as? SYSearchAutocompleteResult, let category = autocomplete.categoryTags.first {
            categoryTag = category
        } else if let place = self as? SYSearchPlaceResult,  let category = place.categoryTags.first {
            categoryTag = category
        }
        if let category = categoryTag {
            let poiCategory = SYMKPlaceCategory.with(sdkPlaceCategory: category)
            icon = poiCategory.icon
            color = poiCategory.color
        }
        return SYUIDetailCellIconDataSource(icon: icon, color: .textInvert, backgroundColor: color)
    }
    
    public var rightIcon: SYUIDetailCellIconDataSource? {
        return nil
    }
    
    public var backgroundColor: UIColor? {
        return UIColor.background
    }
    
}
