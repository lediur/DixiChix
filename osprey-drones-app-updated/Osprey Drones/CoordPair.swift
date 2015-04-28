//
//  CoordPair.swift
//  Osprey Drones
//
//  Created by Tyler Fallon on 4/28/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import Foundation

let comp = 1e-2

class CoordPair : Hashable {
    var coord1 : CLLocationCoordinate2D
    var coord2 : CLLocationCoordinate2D
    
    var hashValue : Int {
        return Int(UInt32(self.coord1.latitude) ^ UInt32(UInt64(self.coord1.latitude) >> 32) ^
                UInt32(self.coord2.latitude) ^ UInt32(UInt64(self.coord2.latitude) >> 32) ^
                UInt32(self.coord1.longitude) ^ UInt32(UInt64(self.coord1.longitude) >> 32) ^
                UInt32(self.coord2.longitude) ^ UInt32(UInt64(self.coord2.longitude) >> 32))
    }
    
    init(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) {
        self.coord1 = coord1
        self.coord2 = coord2
    }
}

func helperCompare(one: Double, two: Double) -> Bool {
    return abs(one - two) < comp
}

func ==(lhs: CoordPair, rhs: CoordPair) -> Bool {
    return ((helperCompare(lhs.coord1.latitude, rhs.coord1.latitude) &&
            helperCompare(lhs.coord1.longitude, rhs.coord1.longitude) &&
            helperCompare(lhs.coord2.latitude, rhs.coord2.latitude) &&
            helperCompare(lhs.coord2.longitude, rhs.coord2.longitude)) ||
            (helperCompare(lhs.coord1.latitude, rhs.coord1.latitude) &&
            helperCompare(lhs.coord1.longitude, rhs.coord1.longitude) &&
            helperCompare(lhs.coord2.latitude, rhs.coord2.latitude) &&
            helperCompare(lhs.coord2.longitude, rhs.coord2.longitude)))
}