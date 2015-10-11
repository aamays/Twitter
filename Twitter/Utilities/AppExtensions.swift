//
//  AppExtensions.swift
//  Twitter
//
//  Created by Amay Singhal on 10/4/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}

extension UIView {
    func addBorderToViewAtPosition(position: BorderPotion, color: UIColor = AppConstants.Colors.LightBorderColor, andThickness thickness: CGFloat = 1) {
        let border = CALayer()
        switch position {
        case .Top:
            border.frame = CGRectMake(0, 0, self.frame.size.width, thickness)
        case .Bottom:
            border.frame = CGRectMake(0, self.bounds.height - thickness, self.frame.size.width, thickness)
//            border.frame = CGRectMake(0, 40, self.frame.size.width, thickness)
        }

        border.backgroundColor = color.CGColor
        self.layer.addSublayer(border)
    }
}


extension UIImageView {
    
    func setFilteredImageFromUrlRequest(urlRequest: NSURLRequest, withFilter filter: CIFilter, andContext context: CIContext, placeholderImage: UIImage?, success: ((NSURLRequest, NSHTTPURLResponse, UIImage) -> Void)?, failure: ((NSURLRequest, NSHTTPURLResponse, NSError) -> Void)?) -> Void {
        self.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: { (request, response, bannerImage) -> Void in
            let inputImage = CIImage(image: bannerImage)
            filter.setValue(inputImage, forKey:"inputImage")
            if let filteredImage = filter.outputImage, let imageExtent = inputImage?.extent {
                let cgImage = context.createCGImage(filteredImage, fromRect: imageExtent)
                self.image = UIImage(CGImage: cgImage)
            } else {
                self.image = bannerImage
            }
            
            
            success?(request, response, bannerImage)
            }) { (request, response, error) -> Void in
                // @todo: Handle error case
                failure?(request, response, error)
        }
    }
    
}