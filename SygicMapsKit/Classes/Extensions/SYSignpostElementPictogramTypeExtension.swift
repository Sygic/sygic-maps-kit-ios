//// SYSignpostElementPictogramTypeExtension.swift
//
// Copyright (c) 2019 Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SygicMaps
import SygicUIKit


/// Extension for mapping signpost element pictograms to font.
public extension SYSignpostElementPictogramType {
    
    func toSymbol() -> String {
        switch self {
        case .none:
            return ""
        case .airport:
            return SYUIIcon.plane
        case .busStation:
            return SYUIIcon.bus
        case .fair:
            return SYUIIcon.carCarrier
        case .ferryConnection:
            return SYUIIcon.boat
        case .firstAidPost:
            return SYUIIcon.hospital
        case .harbour:
            return SYUIIcon.harbor
        case .hospital:
            return SYUIIcon.hospital
        case .hotelOrMotel:
            return SYUIIcon.accomodation
        case .industrialArea:
            return SYUIIcon.factory
        case .informationCenter:
            return SYUIIcon.infoCenter
        case .parkingFacility:
            return SYUIIcon.parking
        case .petrolStation:
            return SYUIIcon.stationPetrol
        case .railwayStation:
            return SYUIIcon.train
        case .restArea:
            return SYUIIcon.restingArea
        case .restaurant:
            return SYUIIcon.restaurant
        case .toilet:
            return SYUIIcon.toilet
        }
    }
    
}
