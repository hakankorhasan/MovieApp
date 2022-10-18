//
//  Extensions.swift
//  MovieApp
//
//  Created by Hakan Körhasan on 28.08.2022.
//

import Foundation
import UIKit

extension String {
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() +  self.lowercased().dropFirst()
    }
}

func AppColorTheme() -> UIColor {
    return UIColor(red: 0, green: 0.7882, blue: 0.7882, alpha: 1.0)
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
