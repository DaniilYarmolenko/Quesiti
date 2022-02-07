//
//  textView.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 06.12.2021.
//

import UIKit

@IBDesignable
open class SwiftyTextView: UITextView {

    /**
     * UI Customization ------ Start
     */
    
    @IBInspectable open var placeholderColor: UIColor = UIColor.lightGray { // placeholder color
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var placeholder: String = "Please input text..." { // placeholder content
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var minNumberOfWords: Int = 0 {// start from 0 by default
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var maxNumberOfWords: Int = 30 { // max num is 30 by default
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var showTextCountView: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    /**
     * UI Customization ------ End
     */
    
    var textLayer: CATextLayer!
    
    var countdownTextLayer: CATextLayer!
    
    weak var swiftyDelegate: SwiftyTextViewDelegate?
    
//    override open func awakeFromNib() {
//        super.awakeFromNib()
//
//        delegate = self
//    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        delegate = self
        if textLayer == nil {
            
            textLayer = CATextLayer()
            
            textLayer.contentsScale = UIScreen.main.scale
            
            textLayer.alignmentMode = CATextLayerAlignmentMode.left
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.foregroundColor = placeholderColor.cgColor
            textLayer.font = font
            textLayer.fontSize = font!.pointSize
            
            textLayer.string = placeholder
                        textLayer.frame = CGRect(origin: CGPoint(x: 8, y: bounds.minY + 8), size: bounds.size)
            
            layer.insertSublayer(textLayer, at: 0)
        }
        
        if showTextCountView {
        
            if countdownTextLayer == nil {
                
                countdownTextLayer = CATextLayer()
                
                countdownTextLayer.contentsScale = UIScreen.main.scale
                
                countdownTextLayer.alignmentMode = CATextLayerAlignmentMode.right
                countdownTextLayer.backgroundColor = UIColor.clear.cgColor
                countdownTextLayer.foregroundColor = ThemeColors.mainColor.cgColor
                countdownTextLayer.font = font
                countdownTextLayer.fontSize = font!.pointSize - 4.0
                
                let tempLabel = UILabel()
                let tempText = "\(maxNumberOfWords)/\(maxNumberOfWords)"
                
                tempLabel.text = tempText
                tempLabel.font = font
                tempLabel.tintColor = ThemeColors.mainColor
                tempLabel.sizeToFit()
                
                countdownTextLayer.frame = tempLabel.frame
                
                countdownTextLayer.string = "\(minNumberOfWords)/\(maxNumberOfWords)"
                
                layer.addSublayer(countdownTextLayer)
            }
            
            countdownTextLayer.frame.origin = CGPoint(x: bounds.size.width - countdownTextLayer.bounds.size.width-15, y: bounds.size.height - countdownTextLayer.bounds.size.height - 15)
        }
        
        delegate?.textViewDidChange!(self)
    }
}

extension SwiftyTextView: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        
        if showTextCountView == true {
        
        countdownTextLayer.string = "\(text.count)/\(maxNumberOfWords)"
        
        textLayer.isHidden = text.count > 0
        
        if let delegate = swiftyDelegate, delegate.responds(to: #selector(SwiftyTextViewDelegate.textViewDidChange(_:))) {
            delegate.textViewDidChange!(textView)
        }
    } else {
        textLayer.isHidden = text.count > 0
        if let delegate = swiftyDelegate, delegate.responds(to: #selector(SwiftyTextViewDelegate.textViewDidChange(_:))) {
            delegate.textViewDidChange!(textView)
        }
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var result: Bool = true
        let oldText = textView.text as NSString
        let newText = oldText.replacingCharacters(in: range, with: text)
        
        if let delegate = swiftyDelegate, delegate.responds(to: #selector(SwiftyTextViewDelegate.textView(_:shouldChangeTextIn:replacementText:))) {
            result = delegate.textView!(textView, shouldChangeTextIn: range, replacementText: text)
        }

        guard showTextCountView == true else {
            return result
        }
        
        if newText.count > maxNumberOfWords {
            countdownTextLayer.fontSize = font!.pointSize
            countdownTextLayer.foregroundColor = UIColor.red.cgColor
            return false
        } else {
            countdownTextLayer.font = font
            countdownTextLayer.fontSize = font!.pointSize - 4.0
            countdownTextLayer.foregroundColor = ThemeColors.mainColor.cgColor
            return result
        }

    }
}


//MARK: -
//MARK: delegate

@objc public protocol SwiftyTextViewDelegate: NSObjectProtocol {
    
    
    @objc optional func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
 
    @objc optional func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    
    @objc optional func textViewDidBeginEditing(_ textView: UITextView)
    
    @objc optional func textViewDidEndEditing(_ textView: UITextView)
    
    
    @objc optional func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    
    @objc optional func textViewDidChange(_ textView: UITextView)
    
    @objc optional func textViewDidChangeSelection(_ textView: UITextView)
    
    @objc optional func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool
    
}
