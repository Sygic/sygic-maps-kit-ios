//// SYMKSignpostView.swift
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

import SygicUIKit
import SygicMaps


/// View for extended direction instructions with signposts.
public class SYMKSignpostView: UIView, SYMKInstructionView {
    
    // MARK: - Public Properties
    
    /// Actual arrow direction instruction.
    public let actualInstructionDirection = UIImageView()
    
    /// Next arrow direction instruction.
    public let nextInstructionDirection = UIImageView()
    
    /// Distance to actual instruction label.
    public let instructionDistance: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36.0, weight: .bold)
        return label
    }()
    
    /// Actual instruction text label.
    public let actualInstructionText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    /// Next instruction text label.
    public let nextInstructionText: UILabel = {
        let label = UILabel()
        label.text = LS("signpost.nextDirection.then")
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    /// Maximum number of route numbers and pictograms at signpost.
    public let maxSymbols = 3
    
    // MARK: - Private Properties
    
    private let margin: CGFloat = 16
    private let actualInstructionSize = 32
    private let nextInstructionSize = 24
    private let nextInstructionAnimationDuration = 0.2
    private let nextInstructionBackground = UIView()
    private let symbolsStackView = UIStackView()
    private var routeNumbers = [SYMKRouteNumberView]()
    private var pictograms = [UILabel]()
    
    // MARK: - Public Methods
    
    public init() {
        super.init(frame: .zero)
        initDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Update symbols with formatted route numbers.
    ///
    /// - Parameter formats: Formatted route numbers from signposts.
    public func updateRouteNumbers(with formats: [SYRouteNumberFormat]) {
        for (index, view) in routeNumbers.enumerated() {
            if formats.indices.contains(index) {
                view.update(with: formats[index])
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }
    
    /// Update symbols with pictograms.
    ///
    /// - Parameter pictograms: Pictograms from signposts.
    public func updatePictograms(with pictograms: [String]) {
        for (index, view) in self.pictograms.enumerated() {
            if pictograms.indices.contains(index) {
                view.text = pictograms[index]
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }
    
    /// Animate visibility of next instruction information.
    ///
    /// - Parameter visible: Bool value whether animation is showing or hiding.
    public func animateNextInstruction(visible: Bool) {
        UIView.animate(withDuration: nextInstructionAnimationDuration) {
            self.nextInstructionBackground.alpha = visible ? 1 : 0
        }
    }
    
    // MARK: - Private Methods
    
    private func initDefaults() {
        backgroundColor = .black
        clipsToBounds = true
        layer.cornerRadius = 8
        
        symbolsStackView.distribution = .fillProportionally
        nextInstructionBackground.backgroundColor = UIColor(argb: 0xff1B1B1B)
        
        addSubview(instructionDistance)
        instructionDistance.translatesAutoresizingMaskIntoConstraints = false
        instructionDistance.topAnchor.constraint(equalTo: topAnchor, constant: margin/2).isActive = true
        instructionDistance.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        
        addSubview(actualInstructionDirection)
        actualInstructionDirection.translatesAutoresizingMaskIntoConstraints = false
        actualInstructionDirection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        actualInstructionDirection.centerYAnchor.constraint(equalTo: instructionDistance.centerYAnchor).isActive = true
        NSLayoutConstraint.activate(actualInstructionDirection.widthAndHeightConstraints(with: CGSize(width: actualInstructionSize, height: actualInstructionSize)))
        
        addSubview(actualInstructionText)
        actualInstructionText.translatesAutoresizingMaskIntoConstraints = false
        actualInstructionText.topAnchor.constraint(equalTo: instructionDistance.bottomAnchor, constant: margin/2).isActive = true
        actualInstructionText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        
        addSubview(symbolsStackView)
        symbolsStackView.translatesAutoresizingMaskIntoConstraints = false
        symbolsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        symbolsStackView.centerYAnchor.constraint(equalTo: actualInstructionText.centerYAnchor).isActive = true
        
        actualInstructionText.trailingAnchor.constraint(equalTo: symbolsStackView.leadingAnchor, constant: -margin).isActive = true
        
        addSubview(nextInstructionBackground)
        nextInstructionBackground.translatesAutoresizingMaskIntoConstraints = false
        nextInstructionBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nextInstructionBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nextInstructionBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nextInstructionBackground.topAnchor.constraint(equalTo: actualInstructionText.bottomAnchor, constant: margin/2).isActive = true
        
        nextInstructionBackground.addSubview(nextInstructionText)
        nextInstructionText.translatesAutoresizingMaskIntoConstraints = false
        nextInstructionText.leadingAnchor.constraint(equalTo: nextInstructionBackground.leadingAnchor, constant: margin).isActive = true
        nextInstructionText.centerYAnchor.constraint(equalTo: nextInstructionBackground.centerYAnchor).isActive = true
        
        nextInstructionBackground.addSubview(nextInstructionDirection)
        nextInstructionDirection.translatesAutoresizingMaskIntoConstraints = false
        nextInstructionDirection.trailingAnchor.constraint(equalTo: nextInstructionBackground.trailingAnchor, constant: -margin).isActive = true
        nextInstructionDirection.topAnchor.constraint(equalTo: nextInstructionBackground.topAnchor, constant: margin/2).isActive = true
        nextInstructionDirection.bottomAnchor.constraint(equalTo: nextInstructionBackground.bottomAnchor, constant: -margin/2).isActive = true
        NSLayoutConstraint.activate(nextInstructionDirection.widthAndHeightConstraints(with: CGSize(width: nextInstructionSize, height: nextInstructionSize)))
        
        initRouteNumbers()
        initPictograms()
    }
    
    private func initRouteNumbers() {
        for _ in 0..<maxSymbols {
            let routeNumberView = SYMKRouteNumberView()
            symbolsStackView.addArrangedSubview(routeNumberView)
            routeNumbers.append(routeNumberView)
        }
    }
    
    private func initPictograms() {
        for _ in 0..<maxSymbols {
            let pictogram = UILabel()
            pictogram.translatesAutoresizingMaskIntoConstraints = false
            pictogram.font = SYUIFont.with(SYUIFont.iconFont, size: 28.0)
            symbolsStackView.addArrangedSubview(pictogram)
            pictograms.append(pictogram)
        }
    }
    
}
