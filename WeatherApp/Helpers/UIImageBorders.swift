//
//  UIImageBorders.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 26.11.2021.
//

import Foundation
import UIKit

extension UIImage {


    func outline() -> UIImage? {



        UIGraphicsBeginImageContext(size)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.draw(in: rect, blendMode: .normal, alpha: 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 1.0)
        context?.setLineWidth(5.0)
        context?.stroke(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()



        return newImage



    }



}
