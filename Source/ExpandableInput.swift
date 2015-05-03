//
//  ExpandableInput.swift
//  ExpandableInput
//
//  Created by Julien Colin on 5/1/15.
//  Copyright (c) 2015 Toldino. All rights reserved.
//

import UIKit

protocol ExpandableInputDelegate {
  func sendAction()
}

@IBDesignable
class ExpandableInputView: UIView {
  
  // MARK: - IBInspectable
  
  @IBInspectable var text: String?
  @IBInspectable var color: UIColor = UIColor.blackColor()
  @IBInspectable var size: CGFloat = UIFont.buttonFontSize()
  @IBInspectable var maxLines: Int = 5
  @IBInspectable var placeHolder: String = "Enter your text here..."
  
  @IBInspectable var buttonText: String = "Send"
  
  // MARK: - Internal views
  
  private var rightButton: UIButton!
  private var inputTextView: UITextView!
  
  private var widthOfRightButton: CGFloat = 50.0
  
  private var trailingOfInputConstraint: NSLayoutConstraint!
  private var trailingOfButtonConstraint: NSLayoutConstraint!
  
  // MARK: - External data
  
  @IBOutlet var contentView: UIView?
  var delegate: ExpandableInputDelegate?
  
  // MARK: - Drawing
  
  override func awakeFromNib() {
    setupViews()
  }
  
  override func prepareForInterfaceBuilder() {
    setupViews()
  }
  
  func setupViews() {
    
    let heightOfViewConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height,
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute,
      multiplier: 1, constant: 49)
    self.addConstraint(heightOfViewConstraint)
    
    
    inputTextView = UITextView()
    inputTextView.setTranslatesAutoresizingMaskIntoConstraints(false)
    inputTextView.text = text
    inputTextView.textColor = color
    inputTextView.font = UIFont.systemFontOfSize(size)
    inputTextView.backgroundColor = UIColor.whiteColor()
    inputTextView.textAlignment = NSTextAlignment.Left
    inputTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
    inputTextView.layer.borderWidth = 1.0
    inputTextView.layer.cornerRadius = 5
    inputTextView.delegate = self
    
    var tap = UITapGestureRecognizer(target: self, action: Selector("didTapOnTableView:"))
    contentView!.addGestureRecognizer(tap)
    
    // Keyboard change events
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    self.addSubview(inputTextView)
    
    let heightOfInputConstraint = NSLayoutConstraint(item: inputTextView, attribute: NSLayoutAttribute.Height,
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute,
      multiplier: 1, constant: 33)
    let bottomOfInputConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom,
      relatedBy: NSLayoutRelation.Equal,
      toItem: inputTextView, attribute: NSLayoutAttribute.Bottom,
      multiplier: 1, constant: 8)
    let leadingOfInputConstraint = NSLayoutConstraint(item: inputTextView, attribute: NSLayoutAttribute.Leading,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self, attribute: NSLayoutAttribute.Leading,
      multiplier: 1, constant: 8)
    inputTextView.addConstraint(heightOfInputConstraint)
    self.addConstraint(leadingOfInputConstraint)
    self.addConstraint(bottomOfInputConstraint)
    
    
    rightButton = UIButton()
    rightButton.setTitleColor(self.tintColor, forState: UIControlState.Normal)
    rightButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
    rightButton.setTitle(buttonText, forState: UIControlState.Normal)
    rightButton.titleLabel?.font = UIFont.systemFontOfSize(size)
    rightButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    rightButton.addTarget(self, action: "sendButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
    self.addSubview(rightButton)
    
    if let width = rightButton.titleLabel?.intrinsicContentSize().width {
      widthOfRightButton = width
    }
    
    let heightOfButtonConstraint = NSLayoutConstraint(item: rightButton, attribute: NSLayoutAttribute.Height,
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute,
      multiplier: 1, constant: 30)
    let widthOfButtonConstraint = NSLayoutConstraint(item: rightButton, attribute: NSLayoutAttribute.Width,
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute,
      multiplier: 1, constant: widthOfRightButton)
    trailingOfButtonConstraint = NSLayoutConstraint(item: rightButton, attribute: NSLayoutAttribute.Trailing,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self, attribute: NSLayoutAttribute.Trailing,
      multiplier: 1, constant: -8)
    let centerYOfButtonConstraint = NSLayoutConstraint(item: rightButton, attribute: NSLayoutAttribute.CenterY,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self, attribute: NSLayoutAttribute.CenterY,
      multiplier: 1, constant: 0)
    rightButton.addConstraint(heightOfButtonConstraint)
    rightButton.addConstraint(widthOfButtonConstraint)
    self.addConstraint(trailingOfButtonConstraint)
    self.addConstraint(centerYOfButtonConstraint)
    
    trailingOfInputConstraint = NSLayoutConstraint(item: inputTextView, attribute: NSLayoutAttribute.Trailing,
      relatedBy: NSLayoutRelation.Equal,
      toItem: rightButton, attribute: NSLayoutAttribute.Leading,
      multiplier: 1, constant: -8)
    self.addConstraint(trailingOfInputConstraint)
    
    
    // TextView appearence initialisation
    if inputTextView.text == "" {
      textViewDidEndEditing(inputTextView)
    }
  }
  
  // MARK: - Actions
  
  func sendButtonAction(sender:UIButton!)
  {
    delegate?.sendAction()
  }
  
  
  func didTapOnTableView(recognizer: UIGestureRecognizer) {
    inputTextView.resignFirstResponder()
  }
//  
//  func keyboardWillShow(notification: NSNotification) {
//    var info = notification.userInfo!
//    var animationDuration: Double = 0.25
//    var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//    if let keyboardAnimationDuration = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
//      animationDuration = Double(keyboardAnimationDuration)
//    }
//    self.bottomConstraint.constant = keyboardFrame.size.height
//    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
//      self.layoutIfNeeded()
//    })
//  }
//  
//  func keyboardWillHide(notification: NSNotification) {
//    var info = notification.userInfo!
//    var animationDuration: Double = 0.25
//    if let keyboardAnimationDuration = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
//      animationDuration = Double(keyboardAnimationDuration)
//    }
//    self.bottomConstraint.constant = initValueForBottomConstraint
//    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
//      self.layoutIfNeeded()
//    })
//  }
}

extension ExpandableInputView: UITextViewDelegate {
  
  func textViewDidEndEditing(textView: UITextView) {
    if textView.text == "" {
      textView.text = placeHolder
      textView.font = UIFont.italicSystemFontOfSize(size)
      textView.textColor = UIColor.lightGrayColor()
      trailingOfButtonConstraint.constant = widthOfRightButton
      UIView.animateWithDuration(0.25, animations: { () -> Void in
      self.rightButton.alpha = 0
      })
      UIView.animateWithDuration(0.25, animations: { () -> Void in
        self.layoutIfNeeded()
      })
    }
    textView.resignFirstResponder()
  }
  
  func textViewDidBeginEditing(textView: UITextView){
    if textView.text == placeHolder {
      textView.text = ""
      textView.font = UIFont.systemFontOfSize(size)
      textView.textColor = color
      trailingOfButtonConstraint.constant = -8
      UIView.animateWithDuration(0.25, animations: { () -> Void in
        self.rightButton.alpha = 1
      })
      UIView.animateWithDuration(0.25, animations: { () -> Void in
        self.layoutIfNeeded()
      })
    }
    textView.becomeFirstResponder()
  }
}
