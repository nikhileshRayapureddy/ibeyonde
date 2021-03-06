//
//  FloatLabelTextView.swift
//  FloatLabelFields
//
//  Created by Fahim Farook on 28/11/14.
//  Copyright (c) 2014 RookSoft Ltd. All rights reserved.
//

import UIKit

@IBDesignable class FloatLabelTextView: UITextView {
	let animationDuration = 0.3
	let placeholderTextColor = UIColor.lightGray.withAlphaComponent(0.65)
	private var isIB = false
	private var title = UILabel()
	private var hintLabel = UILabel()
	private var initialTopInset:CGFloat = 0
	
	// MARK:- Properties
	override var accessibilityLabel:String? {
		get {
			if text.isEmpty {
				return title.text!
			} else {
				return text
			}
		}
		set {
		}
	}
	
    var titleFont:UIFont = UIFont.systemFont(ofSize: 18, weight: .regular) {
		didSet {
			title.font = titleFont
		}
	}
	
	@IBInspectable var hint:String = "" {
		didSet {
			title.text = hint
			title.sizeToFit()
			var r = title.frame
			r.size.width = frame.size.width
			title.frame = r
			hintLabel.text = hint
            if hint == "Message*"{
                let myString4:NSString = "Message*"
                var myMutableString4 = NSMutableAttributedString()
                
                myMutableString4 = NSMutableAttributedString(string: myString4 as String, attributes: [NSAttributedStringKey.font:UIFont(name: "HelveticaLTStd-Light", size: 14.0)!])
                
//                myMutableString4.addAttribute(NSForegroundColorAttributeName, value: Color_placeHolder, range: NSRange(location:0,length:7))
                myMutableString4.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:7,length:1))
                hintLabel.attributedText = myMutableString4

            }
            else {
            }
            
			hintLabel.sizeToFit()
		}
	}
	
	@IBInspectable var hintYPadding:CGFloat = 0.0 {
		didSet {
			adjustTopTextInset()
		}
	}
	
	@IBInspectable var titleYPadding:CGFloat = 0.0 {
		didSet {
			var r = title.frame
			r.origin.y = titleYPadding
			title.frame = r
		}
	}
	
	@IBInspectable var titleTextColour:UIColor = UIColor.gray {
		didSet {
			if !isFirstResponder {
				title.textColor = titleTextColour
                title.backgroundColor = UIColor.white

			}
		}
	}
	
	@IBInspectable var titleActiveTextColour:UIColor = UIColor.cyan {
		didSet {
			if isFirstResponder {
				title.textColor = titleActiveTextColour
                title.backgroundColor = UIColor.white
			}
		}
	}
	
	// MARK:- Init
	required init?(coder aDecoder:NSCoder) {
		super.init(coder:aDecoder)
		setup()
	}
	
	override init(frame:CGRect, textContainer:NSTextContainer?) {
		super.init(frame:frame, textContainer:textContainer)
		setup()
	}
	
	deinit {
		if !isIB {
			let nc = NotificationCenter.default
			nc.removeObserver(self, name:NSNotification.Name.UITextViewTextDidChange, object:self)
			nc.removeObserver(self, name:NSNotification.Name.UITextViewTextDidBeginEditing, object:self)
			nc.removeObserver(self, name:NSNotification.Name.UITextViewTextDidEndEditing, object:self)
		}
	}
	
	// MARK:- Overrides
	override func prepareForInterfaceBuilder() {
		isIB = true
		setup()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		adjustTopTextInset()
		hintLabel.alpha = text.isEmpty ? 1.0 : 0.0
		let r = textRect()
		hintLabel.frame = CGRect(x:r.origin.x, y:r.origin.y, width:hintLabel.frame.size.width, height:hintLabel.frame.size.height)
		setTitlePositionForTextAlignment()
		let isResp = isFirstResponder
		if isResp && !text.isEmpty {
			title.textColor = titleActiveTextColour
		} else {
			title.textColor = titleTextColour
		}
		// Should we show or hide the title label?
		if text.isEmpty {
			// Hide
			hideTitle(animated: isResp)
		} else {
			// Show
			showTitle(animated: isResp)
		}
	}
	
	// MARK:- Private Methods
	private func setup() {
		initialTopInset = textContainerInset.top
		textContainer.lineFragmentPadding = 0.0
		titleActiveTextColour = tintColor
		// Placeholder label
		hintLabel.font = font
		hintLabel.text = hint
		hintLabel.numberOfLines = 0
		hintLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
		hintLabel.backgroundColor = UIColor.clear
		hintLabel.textColor = placeholderTextColor
		insertSubview(hintLabel, at:0)
		// Set up title label
		title.alpha = 0.0
		title.font = titleFont
		title.textColor = titleTextColour
		title.backgroundColor = backgroundColor
		if !hint.isEmpty {
			title.text = hint
			title.sizeToFit()
		}
		self.addSubview(title)
		// Observers
		if !isIB {
			let nc = NotificationCenter.default
			nc.addObserver(self, selector:#selector(UIView.layoutSubviews), name:NSNotification.Name.UITextViewTextDidChange, object:self)
			nc.addObserver(self, selector:#selector(UIView.layoutSubviews), name:NSNotification.Name.UITextViewTextDidBeginEditing, object:self)
			nc.addObserver(self, selector:#selector(UIView.layoutSubviews), name:NSNotification.Name.UITextViewTextDidEndEditing, object:self)
		}
	}

	private func adjustTopTextInset() {
		var inset = textContainerInset
		inset.top = initialTopInset + title.font.lineHeight + hintYPadding
		textContainerInset = inset
	}
	
	private func textRect()->CGRect {
		var r = UIEdgeInsetsInsetRect(bounds, contentInset)
		r.origin.x += textContainer.lineFragmentPadding
		r.origin.y += textContainerInset.top
		return r.integral
	}
	
	private func setTitlePositionForTextAlignment() {
		var titleLabelX = textRect().origin.x
		var placeholderX = titleLabelX
		if textAlignment == NSTextAlignment.center {
			titleLabelX = (frame.size.width - title.frame.size.width) * 0.5
			placeholderX = (frame.size.width - hintLabel.frame.size.width) * 0.5
		} else if textAlignment == NSTextAlignment.right {
			titleLabelX = frame.size.width - title.frame.size.width
			placeholderX = frame.size.width - hintLabel.frame.size.width
		}
		var r = title.frame
		r.origin.x = titleLabelX
		title.frame = r
		r = hintLabel.frame
		r.origin.x = placeholderX
		hintLabel.frame = r
	}
	
	private func showTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut], animations:{
			// Animation
			self.title.alpha = 1.0
			var r = self.title.frame
			r.origin.y = self.titleYPadding + self.contentOffset.y
			self.title.frame = r
			}, completion:nil)
	}
	
	private func hideTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn], animations:{
			// Animation
			self.title.alpha = 0.0
			var r = self.title.frame
			r.origin.y = self.title.font.lineHeight + self.hintYPadding
			self.title.frame = r
			}, completion:nil)
	}
}
