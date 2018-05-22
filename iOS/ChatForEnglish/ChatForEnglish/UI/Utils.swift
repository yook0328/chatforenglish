//
//  Utils.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 2. 3..
//  Copyright © 2018년 aram. All rights reserved.
//
import UIKit

class Utils {
    public static func getTokenToString(_ deviceToken : Data) -> String {
        
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        
        return token
    }
    public static func estimateTextWidth(text: String, font: UIFont) -> CGSize {
        let size = text.size(withAttributes: [NSAttributedStringKey.font: font])
        return size
    }
    public static func estimateFrameForText(_ text: String,width: CGFloat, font: UIFont) -> CGRect {
        let size = CGSize(width: width, height: 2000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font.pointSize)], context: nil)
    }
    
    public static func convertTimestampForString(_ timestamp: Int64) -> String{
        
        let date = Date(timeIntervalSince1970: Double.init(timestamp)/1000)
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
        
        
    }
    static public func fontToFitHeight(_ text : String, view : UIView) -> UIFont {
        
        var minFontSize: CGFloat = 5
        var maxFontSize: CGFloat = 100
        var textAndLabelHeightDiff: CGFloat = 0
        var fontSizeAverage : CGFloat = 0
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard text.characters.count > 0 else {
                break
            }
            
            let labelHeight = view.frame.size.height
            
            let testStringHeight = text.size(
                withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSizeAverage)]
                ).height
            
            textAndLabelHeightDiff = labelHeight - testStringHeight
            
            if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                if (textAndLabelHeightDiff < 0) {
                    return UIFont.systemFont(ofSize: fontSizeAverage - 1)
                }
                return UIFont.systemFont(ofSize: fontSizeAverage)
            }
            
            if (textAndLabelHeightDiff < 0) {
                maxFontSize = fontSizeAverage - 1
                
            } else if (textAndLabelHeightDiff > 0) {
                minFontSize = fontSizeAverage + 1
                
            } else {
                return UIFont.systemFont(ofSize: fontSizeAverage)
            }
        }
        return UIFont.systemFont(ofSize: fontSizeAverage)
    }
}
