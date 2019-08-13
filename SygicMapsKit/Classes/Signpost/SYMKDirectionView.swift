//// SYMKDirectionView.swift
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


/// Navigation view with instructions using arrow direction with distance and road street names.
public class SYMKDirectionView: UIView, SYMKInstructionView {
    
    // MARK: - Public Properties
    
    /// Actual arrow direction instruction.
    public let actualInstructionDirection = UIImageView()
    
    /// Next arrow direction instruction.
    public let nextInstructionDirection = UIImageView()
    
    /// Actual instruction text label.
    public let actualInstructionText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    /// Next instruction text label.
    public let nextInstructionText: UILabel = {
        let label = UILabel()
        label.text = LS("signpost.nextDirection.then")
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        label.adjustsFontSizeToFitWidth = false
        return label
    }()
    
    /// Distance to actual instruction label.
    public let instructionDistance: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    // MARK: - Private Properties
    
    private let actualInstructionStackView = UIStackView()
    private let nextInstructionStackView = UIStackView()
    private let nextInstructionBackground = UIView()
    private let actualInstructionSize = 48
    private let nextInstructionSize: CGFloat = 24
    private let nextInstructionAnimationDuration = 0.2
    private let margin: CGFloat = 16
    
    // MARK: - Public Methods
    
    public init() {
        super.init(frame: .zero)
        initDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        nextInstructionBackground.backgroundColor = UIColor(argb: 0xff1B1B1B)
        actualInstructionStackView.axis = .vertical
        nextInstructionStackView.axis = .vertical
        
        actualInstructionDirection.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actualInstructionDirection)
        actualInstructionDirection.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        actualInstructionDirection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        actualInstructionDirection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        NSLayoutConstraint.activate(actualInstructionDirection.widthAndHeightConstraints(with: CGSize(width: actualInstructionSize, height: actualInstructionSize)))
        
        actualInstructionStackView.addArrangedSubview(instructionDistance)
        actualInstructionStackView.addArrangedSubview(actualInstructionText)
        actualInstructionStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actualInstructionStackView)
        actualInstructionStackView.topAnchor.constraint(equalTo: actualInstructionDirection.topAnchor).isActive = true
        actualInstructionStackView.leadingAnchor.constraint(equalTo: actualInstructionDirection.trailingAnchor, constant: margin/2).isActive = true
        actualInstructionStackView.bottomAnchor.constraint(equalTo: actualInstructionDirection.bottomAnchor).isActive = true
        
        nextInstructionStackView.spacing = 8
        nextInstructionStackView.alignment = .center
        nextInstructionStackView.addArrangedSubview(nextInstructionDirection)
        nextInstructionStackView.addArrangedSubview(nextInstructionText)
        
        nextInstructionDirection.widthAnchor.constraint(equalToConstant: nextInstructionSize).isActive = true
        
        nextInstructionText.translatesAutoresizingMaskIntoConstraints = false
        nextInstructionText.widthAnchor.constraint(equalToConstant: 40).isActive = true
        nextInstructionText.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        nextInstructionBackground.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nextInstructionBackground)
        nextInstructionBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nextInstructionBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nextInstructionBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        nextInstructionStackView.translatesAutoresizingMaskIntoConstraints = false
        nextInstructionBackground.addSubview(nextInstructionStackView)
        nextInstructionStackView.leadingAnchor.constraint(equalTo: nextInstructionBackground.leadingAnchor, constant: margin/2).isActive = true
        nextInstructionStackView.trailingAnchor.constraint(equalTo: nextInstructionBackground.trailingAnchor, constant: -margin/2).isActive = true
        nextInstructionStackView.topAnchor.constraint(equalTo: nextInstructionBackground.topAnchor, constant: margin).isActive = true
        nextInstructionStackView.bottomAnchor.constraint(equalTo: nextInstructionBackground.bottomAnchor, constant: -margin).isActive = true
    }

}
