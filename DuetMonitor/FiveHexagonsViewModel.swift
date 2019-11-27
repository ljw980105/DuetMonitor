//
//  FiveHexagonsViewModel.swift
//  DuetMonitor
//
//  Created by Jing Wei Li on 11/25/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class FiveHexagonsViewModel {
    /// format: `(x ratio, y ratio, e ratio)`
    private let data: [(Double, Double, Double)] = [
        // hex 1
        (406.299, 294.479, 0),
        (380.970979132, 309.103490440, 0),
        (380.970979132, 309.103490440, 0),
        
        (365.239711944, 309.103490440, 0.68396813863287398),
        (357.374078349, 295.479813421, 0.68396813863286965),
        (365.239711944, 281.856136402, 0.68396813863286965),
        (380.970979132, 281.856136402, 0.68396813863287398),
        (388.836612727, 295.479813421, 0.68396813863286476),
        (380.970979132, 309.103490440, 0.68396813863286476),
        
        // hex 2
        (380.970979132, 309.103490440, 0),
        (406.299930723, 323.727167459, 0),
        (406.299930723, 323.727167459, 0),
        
        (390.568663534, 323.727167459, 0.6839681386328641),
        (382.703029940, 310.103490440, 0.68396813863286965),
        (390.568663534, 296.479813421, 0.68396813863286965),
        (406.299930723, 296.479813421, 0.6839681386328641),
        (414.165564317, 310.103490440, 0.68396813863286965),
        (406.299930723, 323.727167459, 0.68396813863286965),
        
        // hex 3
        (406.299930723, 323.727167459, 0),
        (380.970979132, 338.350844478, 0),
        (380.970979132, 338.350844478, 0),
        
        (365.239711944, 338.350844478, 0.68396813863287398),
        (357.374078349, 324.727167459, 0.68396813863286476),
        (365.239711944, 311.103490440, 0.68396813863286476),
        (380.970979132, 311.103490440, 0.68396813863287398),
        (388.836612727, 324.727167459, 0.68396813863286965),
        (380.970979132, 338.350844478, 0.68396813863286965),
        
        // hex 4
        (380.970979132, 338.350844478, 0),
        (406.299930723, 352.974521497, 0),
        (406.299930723, 352.974521497, 0),
        
        (390.568663534, 352.974521497, 0.6839681386328641),
        (382.703029940, 339.350844478, 0.68396813863286965),
        (390.568663534, 325.727167459, 0.68396813863286965),
        (406.299930723, 325.727167459, 0.6839681386328641),
        (414.165564317, 339.350844478, 0.68396813863286965),
        (406.299930723, 352.974521497, 0.68396813863286965),
        
        // hex 5
        (406.299930723, 352.974521497, 0),
        (380.970979132, 367.598198516, 0),
        (380.970979132, 367.598198516, 0),
        
        (365.239711944, 367.598198516, 0.68396813863287398),
        (357.374078349, 353.974521497, 0.68396813863286476),
        (365.239711944, 340.350844478, 0.68396813863286476),
        (380.970979132, 340.350844478, 0.68396813863287398),
        (388.836612727, 353.974521497, 0.68396813863286965),
        (380.970979132, 367.598198516, 0.68396813863286965)
    ]
    
    private let extruderIncrement = 0.028
    
    func writeGCode(
        fastSpeed: Int,
        printSpeed: Int,
        zAxisExt: Double,
        augerRatio: Double,
        pumpRatio: Double) -> String
    {
        var result = ""
        var lineNumber = 11
        var position = 0
        var extruderRatio = 0.0
        
        result += """
        N0 ; G_Code for CAST_IT Dynamic Mixing

        N1 ; Center for Architecture Science and Ecology



        N2 ; MACHINE SETTINGS

        N3 T0 ; selects and activate the tool 0

        N4 ; END MACHINE SETTINGS

        N5 ; OFFSET MATERIAL LINES
        N6 ; OFFSET MATERIAL LINES
        N7 ; OFFSET MATERIAL LINES
        N8 ; OFFSET MATERIAL LINES
        N9 ; OFFSET MATERIAL LINES

        N10 G1 x583.602591856 y338.350844478 z0.0 E0.68396813863286965 f\(fastSpeed)
        
        """
        
        for _ in 0 ..< data.count / 9 {
            retractMaterial(position: &position, lineNumber: &lineNumber, gCode: &result, fastSpeed: fastSpeed,
                            printSpeed: printSpeed, eRatio: &extruderRatio, zRatio: zAxisExt,
                            augerRatio: augerRatio, pumpRatio: pumpRatio)
            unretractMaterial(position: &position, lineNumber: &lineNumber, gCode: &result, fastSpeed: fastSpeed,
                              printSpeed: printSpeed, eRatio: &extruderRatio,
                              zRatio: zAxisExt, augerRatio: augerRatio, pumpratio: pumpRatio)
            // print("completed pass \(i)")
        }
        
        return result
    }
    
    func retractMaterial(
        position: inout Int,
        lineNumber: inout Int,
        gCode: inout String,
        fastSpeed: Int,
        printSpeed: Int,
        eRatio: inout Double,
        zRatio: Double,
        augerRatio: Double,
        pumpRatio: Double)
    {
        gCode += """
        N\(lineNumber) M567 P0 \(formatExtrusion(eRatio, augerRatio, pumpRatio: pumpRatio))
        N\(lineNumber + 1) G1 E-2 f\(fastSpeed) ;.................................retract material\n
        """
        lineNumber += 2
        eRatio += extruderIncrement
        
        for _ in 0 ..< 2 {
            let entry = data[position]
            gCode += "N\(lineNumber) G1 x\(entry.0) y\(entry.1) z\(zRatio) E0 f\(fastSpeed)\n\n"
            position += 1
            lineNumber += 1
        }
        
        let entry2 = data[position]
        gCode += "N\(lineNumber) G1 x\(entry2.0) y\(entry2.1) z0.0 E0 f\(printSpeed)\n\n"
        position += 1
        lineNumber += 1
        gCode += "\n"
        // print("position: \(position)")
    }
    
    func unretractMaterial(
        position: inout Int,
        lineNumber: inout Int,
        gCode: inout String,
        fastSpeed: Int,
        printSpeed: Int,
        eRatio: inout Double,
        zRatio: Double,
        augerRatio: Double,
        pumpratio: Double)
    {
        gCode += "N\(lineNumber) G1 E2 f\(fastSpeed) ;...............................unretract material\n"
        lineNumber += 1
        
        for _ in 0 ..< 6 {
            gCode += "N\(lineNumber) M567 P0 \(formatExtrusion(eRatio, augerRatio, pumpRatio: pumpratio))\n"
            lineNumber += 1
            gCode += "\n"
            
            let entry = data[position]
            gCode += "N\(lineNumber) G1 x\(entry.0) y\(entry.1) z0.0 E\(entry.2) f\(printSpeed)\n"
            position += 1
            lineNumber += 1
            gCode += "\n"
            
            eRatio += extruderIncrement
        }
        // print("position: \(position)")
    }
    
    func formatExtrusion(_ eRatio: Double, _ augerRatio: Double, pumpRatio: Double) -> String {
        return String(format: "E%.2f:%.2f:%.2f", eRatio * pumpRatio, (1 - eRatio) * pumpRatio, augerRatio)
    }
}
