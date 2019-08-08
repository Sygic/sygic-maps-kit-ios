//// SYMKLaneAssistView.swift
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


public class SYMKLaneAssistView: UIView {
    
    private let bundle = Bundle(for: SYMKLaneAssistView.self)
    
    private let laneStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateLaneArrows(_ lanes: [(arrows: [String], highlighted: Bool)]) {
        laneStack.removeAll()
        
        for lane in lanes {
            let arrowImagesView = UIView()
            arrowImagesView.translatesAutoresizingMaskIntoConstraints = false
            arrowImagesView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            arrowImagesView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            for arrow in lane.arrows {
                let arrowImage = UIImageView(image: UIImage(named: arrow, in: bundle, compatibleWith: nil))
                arrowImage.tintColor = lane.highlighted ? .systemGray : .white
                arrowImagesView.addSubview(arrowImage)
                arrowImage.translatesAutoresizingMaskIntoConstraints = false
                arrowImage.coverWholeSuperview()
            }
            
            laneStack.addArrangedSubview(arrowImagesView)
        }
    }
    
    private func initDefaults() {
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        layer.cornerRadius = 8
        backgroundColor = .black
        setupLaneStack()
    }
    
    private func setupLaneStack() {
        addSubview(laneStack)
        laneStack.translatesAutoresizingMaskIntoConstraints = false
        laneStack.centerInSuperview()
    }
    
}
