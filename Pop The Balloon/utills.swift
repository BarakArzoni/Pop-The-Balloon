//
//  utills.swift
//  Pop The Balloon
//
//  Created by Barak on 30/12/2020.
//

import Foundation

func randomBool(odds: Int) -> Bool {
    let random = Int.random(in: 0..<odds)
    if random < 1 {
        return true
    } else {
        return false
    }
}


