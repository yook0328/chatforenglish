//
//  ChatCollectionViewCell.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 11..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    var bubbleView : UIView?
    var textView : UITextView?
    var editTextView : UITextView?
    
    var arrowView : UIImageView?

    var bubbleViewXPosConstraint : NSLayoutConstraint?
    var bubbleViewWidthConstraint : NSLayoutConstraint?
    var bubbleViewHeightConstraint : NSLayoutConstraint?
    
    var editTextViewHeightConstraint : NSLayoutConstraint?
    var textViewHeightConstraint : NSLayoutConstraint?
    var arroaViewHeightConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bubbleView = UIView()
        self.addSubview(bubbleView!)
        
        bubbleView?.layer.cornerRadius = 5
        
        bubbleView?.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bubbleViewXPosConstraint = bubbleView?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewXPosConstraint?.isActive = true
        
        bubbleViewWidthConstraint = bubbleView?.widthAnchor.constraint(equalToConstant: 300)
        bubbleViewWidthConstraint?.isActive = true
        
        bubbleViewHeightConstraint = bubbleView?.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -5)
        bubbleViewHeightConstraint?.isActive = true
        
        textView = UITextView()
//        textView?.layoutMargins = .zero
        bubbleView?.addSubview(textView!)
        //let test = UITextView()
        textView?.backgroundColor = .clear
        textView?.textContainerInset = .zero
        //textView?.textContainer.lineFragmentPadding = 0
        textView?.isScrollEnabled = false
        textView?.isEditable = false
        
        textView?.translatesAutoresizingMaskIntoConstraints = false
        textView?.centerXAnchor.constraint(equalTo: (bubbleView?.centerXAnchor)!).isActive = true
        textView?.topAnchor.constraint(equalTo: (bubbleView?.topAnchor)!, constant: 5).isActive = true
        textViewHeightConstraint = textView?.heightAnchor.constraint(equalTo: (bubbleView?.heightAnchor)!, constant: -10)
        textViewHeightConstraint?.isActive = true
        textView?.widthAnchor.constraint(equalTo: (bubbleView?.widthAnchor)!, constant: -10).isActive = true
//        textView?.numberOfLines = 0
        
        arrowView = UIImageView(image: UIImage(named: "icon-bottom-arrow"))
        arrowView?.contentMode = .scaleAspectFit
        arrowView?.translatesAutoresizingMaskIntoConstraints = false
        bubbleView?.addSubview(arrowView!)
        
        arrowView?.topAnchor.constraint(equalTo: (textView?.bottomAnchor)!, constant: 8).isActive = true
        arroaViewHeightConstraint = arrowView?.heightAnchor.constraint(equalToConstant: 0)
        arroaViewHeightConstraint?.isActive = true
        arrowView?.centerXAnchor.constraint(equalTo: (bubbleView?.centerXAnchor)!).isActive = true
        arrowView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        editTextView = UITextView()
        //        textView?.layoutMargins = .zero
        bubbleView?.addSubview(editTextView!)
        //let test = UITextView()
        editTextView?.backgroundColor = .clear
        editTextView?.textContainerInset = .zero
        //textView?.textContainer.lineFragmentPadding = 0
        //editTextView?.isScrollEnabled = false
        editTextView?.isEditable = false
        
        editTextView?.translatesAutoresizingMaskIntoConstraints = false
        
        editTextView?.centerXAnchor.constraint(equalTo: (bubbleView?.centerXAnchor)!).isActive = true
        editTextView?.widthAnchor.constraint(equalTo: (bubbleView?.widthAnchor)!, constant: -10).isActive = true
        editTextView?.topAnchor.constraint(equalTo: (arrowView?.bottomAnchor)!, constant: 8).isActive = true
        editTextViewHeightConstraint = editTextView?.heightAnchor.constraint(equalToConstant: 0)
        editTextViewHeightConstraint?.isActive = true
        
    }
    func setEditTextChatCell(editText : String, originalText : String, bubbleWidth : CGFloat, editTextHeight : CGFloat, originalTextHeight : CGFloat){
        textView?.text = originalText
        editTextView?.text = editText
        
        
        bubbleViewWidthConstraint?.constant = bubbleWidth
        
        textViewHeightConstraint?.isActive =  false
        textViewHeightConstraint = textView?.heightAnchor.constraint(equalToConstant: originalTextHeight)
        textViewHeightConstraint?.isActive = true
        
        arroaViewHeightConstraint?.constant = 20
        editTextViewHeightConstraint?.constant = editTextHeight
        
    }
    func setTextChatCell(text : String, bubbleWidth : CGFloat) {
        textView?.text = text
        
        bubbleViewWidthConstraint?.constant = bubbleWidth
        
        textViewHeightConstraint?.isActive =  false
        textViewHeightConstraint = textView?.heightAnchor.constraint(equalTo: (bubbleView?.heightAnchor)!, constant: -10)
        textViewHeightConstraint?.isActive = true
        
        arroaViewHeightConstraint?.constant = 0
        editTextViewHeightConstraint?.constant = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
