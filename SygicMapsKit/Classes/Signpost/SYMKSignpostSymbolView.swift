//// SYMKSignpostSymbolView.swift
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


/// Signpost symbols view. Symbols are road signs and pictograms. Same symbols as real signpost symbols on a road.
class SYMKSignpostSymbolView: UIView {
    
    // MARK: - Private properties
    
    private var roadSign = UIImageView()
    private let roadSignHeight: CGFloat = 28.0
    private let bundle = Bundle(for: SYMKSignpostSymbolView.self)
    
    private var roadNumber: SYUIInsetLabel = {
        let label = SYUIInsetLabel()
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.contentInset = UIEdgeInsets(top: 0, left: 7.5, bottom: 1, right: 7.5)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Public Methods
    
    init() {
        super.init(frame: .zero)
        initDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates road sign symbol.
    /// - Parameter format: Format for road sign.
    public func update(with format: SYMapRoadNumberFormat?) {
        guard let format = format else {
            clearRoadSign()
            return
        }
        roadSign.image = shapeToImage(shape: format.shape)
        roadNumber.text = format.insideNumber
        roadNumber.textColor = numberColor(from: format.numberColor)
    }
    
    /// Updates pictogram symbol.
    /// - Parameter pictogram: Pictogram type.
    public func update(with pictogram: SYSignpostElementPictogramType) {
        roadSign.image = pictogramToImage(pictogram: pictogram)
        roadNumber.text = ""
    }
    
    // MARK: - Private Methods
    
    private func clearRoadSign() {
        roadSign.image = nil
        roadNumber.text = nil
    }
    
    private func pictogramToImage(pictogram: SYSignpostElementPictogramType) -> UIImage? {
        var imageName: String
        
        switch pictogram {
        case .airport:
            imageName = "pictogram_airport"
        case .busStation:
            imageName = "pictogram_bus"
        case .fair:
            imageName = "pictogram_fair"
        case .ferryConnection:
            imageName = "pictogram_ferry"
        case .firstAidPost, .hospital:
            imageName = "pictogram_er"
        case .harbour:
            imageName = "pictogram_harbour"
        case .hotelOrMotel:
            imageName = "pictogram_acc"
        case .industrialArea:
            imageName = "pictogram_factory"
        case .informationCenter:
            imageName = "pictogram_info"
        case .parkingFacility:
            imageName = "pictogram_parking"
        case .petrolStation:
            imageName = "pictogram_gas"
        case .railwayStation:
            imageName = "pictogram_train"
        case .restArea:
            imageName = "pictogram_rest"
        case .restaurant:
            imageName = "pictogram_food"
        case .toilet:
            imageName = "pictogram_wc"
        case .none:
            imageName = ""
        }
        
        return UIImage(named: imageName, in: bundle, compatibleWith: nil)
    }
    
    private func shapeToImage(shape: SYNumberShapeType) -> UIImage? {
        var imageName: String
        
        switch shape {
        case .blueShape1:
            imageName = "roadsign_are_blue"
        case .greenEShape3:
            imageName = "roadsign_are_green"
        case .blueNavyShape2:
            imageName = "roadsign_hun_blue"
        case .greenEShape2:
            imageName = "roadsign_hun_green"
        case .greenAShape4:
            imageName = "roadsign_aus_4_green"
        case .redShape5:
            imageName = "roadsign_nzl_red"
        case .blueShape5:
            imageName = "roadsign_aus_2_blue"
        case .blueShape6:
            imageName = "roadsign_deu_blue"
        case .redShape6:
            imageName = "roadsign_tur_red"
        case .greenEShape6:
            imageName = "roadsign_svn_green"
        case .redShape8:
            imageName = "roadsign_che_red"
        case .redShape9, .redShape10:
            imageName = "roadsign_fra_red"
        case .brownShape7:
            imageName = "roadsign_aus_1_brown"
        case .blackShape11WhiteBorder:
            imageName = "roadsign_aus_4_black"
        case .whiteShape12BlueNavyBorder:
            imageName = "roadsign_aus_5_white"
        case .yellowShape13GreenABorder:
            imageName = "roadsign_aus_5_green"
        case .blueRedCanShape:
            imageName = "roadsign_can_blue_red_rebon"
        case .whiteShape14GreenEBorder:
            imageName = "roadsign_can_white_green_border"
        case .whiteShape15BlackBorder:
            imageName = "roadsign_can_white_black_border"
        case .greenEShape16WhiteBorder, .greenEShape18WhiteBorder:
            imageName = "roadsign_ita_green"
        case .blueShape17WhiteBorder:
            imageName = "roadsign_isr_blue"
        case .whiteShape17BlackBorder, .whiteShape24BlackBorder:
            imageName = "roadsign_isr_white_black_border"
        case .whiteShape24BlueMexBorder:
            imageName = "roadsign_isr_white_blue_border"
        case .whiteShape24RedBorder:
            imageName = "roadsign_isr_white_red_border"
        case .whiteShape24GreenEBorder:
            imageName = "roadsign_isr_white_green_border"
        case .blueShape18BlackBorder:
            imageName = "roadsign_vnm_blue"
        case .yellowShape18BlackBorder:
            imageName = "roadsign_mys_yellow"
        case .whiteShape20BlackBorder:
            imageName = "roadsign_nld_white"
        case .usaShield:
            imageName = "roadsign_us_1_blue"
        case .whiteShape22BlackBorder:
            imageName = "roadsign_us_2_white"
        case .whiteShape21BlackBorder:
            imageName = "roadsign_us_3_white"
        case .orangeShape23WhiteBorder:
            imageName = "roadsign_hkg_orange"
        case .blueMexShape, .redMexShape:
            imageName = "roadsign_mex_white"
        case .greenESauShape1:
            imageName = "roadsign_sau_1"
        case .greenESauShape2:
            imageName = "roadsign_sau_2"
        case .greenESauShape3:
            imageName = "roadsign_sau_3"
        case .orangeShape19BlackBorder:
            imageName = "roadsign_fra_orange"
        case .whiteRect, .whiteRectBlackBorder:
            imageName = "roadsign_rect_white"
        case .whiteRectGreenEBorder:
            imageName = "roadsign_rect_white_green_border"
        case .whiteRectYellowBorder:
            imageName = "roadsign_rect_white_yellow_border"
        case .blueRect, .blueNavyRect, .blueRectWhiteBorder, .blueNavyRectWhiteBorder:
            imageName = "roadsign_rect_blue"
        case .blueRectBlackBorder:
            imageName = "roadsign_rect_blue_black_border"
        case .redRect, .redRectWhiteBorder:
            imageName = "roadsign_rect_red"
        case .redRectBlackBorder:
            imageName = "roadsign_rect_red_black_border"
        case .brownRect:
            imageName = "roadsign_rect_brown"
        case .orangeRect:
            imageName = "roadsign_rect_orange"
        case .yellowRect, .yellowRectWhiteBorder:
            imageName = "roadsign_rect_yellow"
        case .yellowRectBlackBorder:
            imageName = "roadsign_rect_yellow_black_border"
        case .greenERectBlackBorder:
            imageName = "roadsign_rect_green_black_border"
        case .greenARect, .greenERect, .greenERectWhiteBorder, .greenARectGreenEBorder, .unknown:
            imageName = "roadsign_rect_green"
        }
        
        return UIImage(named: imageName, in: bundle, compatibleWith: nil)
    }
    
    private func numberColor(from shapeColor: SYNumberTextColor) -> UIColor {
        switch shapeColor {
        case .black:
            return .black
        case .white, .unknown:
            return .white
        case .greenA, .greenE:
            return UIColor(argb: 0xff0AA98B)
        case .blue, .blueMex, .blueNavy:
            return UIColor(argb: 0xff0080FF)
        case .red:
            return UIColor(argb: 0xffD6304C)
        case .yellow:
            return UIColor(argb: 0xffEADF52)
        case .orange:
            return UIColor(argb: 0xffE59B4A)
        case .brown:
            return UIColor(argb: 0xff613636)
        }
    }
    
    private func initDefaults() {
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        heightAnchor.constraint(equalToConstant: roadSignHeight).isActive = true
        
        roadSign.translatesAutoresizingMaskIntoConstraints = false
        addSubview(roadSign)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[roadSign]|", options: [], metrics: nil, views: ["roadSign": roadSign]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[roadSign]|", options: [], metrics: nil, views: ["roadSign": roadSign]))
        
        roadNumber.translatesAutoresizingMaskIntoConstraints = false
        addSubview(roadNumber)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[roadNumber]|", options: [], metrics: nil, views: ["roadNumber": roadNumber]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[roadNumber]|", options: [], metrics: nil, views: ["roadNumber": roadNumber]))
    }
    
}
