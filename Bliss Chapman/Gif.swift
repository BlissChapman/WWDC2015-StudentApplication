//
//  Gif.swift
//  Bliss Chapman
//
//  Created by Bliss Chapman on 4/22/15.
//  Copyright (c) 2015 Bliss Chapman. All rights reserved.
//

import Foundation
import UIKit
import ImageIO


//Much of this was not written by me although it may be slightly tweaked to suit my purposes.  It is a simple UIImage extension that converts gifs into images that can be displayed in an image view.  It is licensed under the MIT license and can be found in the github repository "SwiftGif" by JoelSimonoff (https://github.com/JoelSimonoff/SwiftGif).

extension UIImage {
    
//    class func firstImageInGif(data: NSData) -> UIImage? {
//        let source = CGImageSourceCreateWithData(data, nil)
//        
//        if let firstImageInGif = CGImageSourceCreateImageAtIndex(source, 0, nil) {
//            return UIImage(CGImage: firstImageInGif)
//        } else { return nil }
//    }
    
    class func animatedImageWithData(data: NSData) -> UIImage? {
        if let source = CGImageSourceCreateWithData(data, nil) {
            return UIImage.animatedImageWithSource(source)
        } else {
            return nil
        }
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSourceRef)
        -> Double {
            var delay = 0.1
            
            // Get dictionaries
            let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
            let gifProperties: CFDictionaryRef = unsafeBitCast(
                CFDictionaryGetValue(cfProperties,
                    unsafeAddressOf(kCGImagePropertyGIFDictionary)),
                CFDictionary.self)
            
            // Get delay time
            var delayObject: AnyObject = unsafeBitCast(
                CFDictionaryGetValue(gifProperties,
                    unsafeAddressOf(kCGImagePropertyGIFUnclampedDelayTime)),
                AnyObject.self)
            if delayObject.doubleValue == 0 {
                delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                    unsafeAddressOf(kCGImagePropertyGIFDelayTime)), AnyObject.self)
            }
            
            delay = delayObject as! Double
            
            if delay < 0.1 {
                delay = 0.1 // Make sure they're not too fast
            }
            
            
            return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b

        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImageRef]()
        var delays = [Int]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            images.append(CGImageSourceCreateImageAtIndex(source, i, nil)!)
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
            }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(CGImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImageWithImages(frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}