//
//  Segments.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/15/24.
//

import Foundation
import PureSwiftUI


final class Segments {
static let layoutConfig = LayoutGuideConfig.grid(columns: 375, rows: 471)
    
    struct OpportunitySegment: Shape {
        func path(in rect: CGRect) -> Path {
            let grid = layoutConfig.layout(in: rect)
            var path = Path()
            
            path.move(to: grid[10, 10])
            path.addLine(to: grid[320, 10])
            path.curve(grid[365, 50], cp1: grid[350, 10], cp2: grid[365, 20])
            
            path.addLine(to: grid[365, 116])
            path.addLine(to: grid[214, 266])
            path.curve(grid[177, 266], cp1: grid[194, 284], cp2: grid[177, 266])
            
            path.addLine(to: grid[10, 89])
            path.addLine(to: grid[10, 50])
            path.curve(grid[45, 10], cp1: grid[10, 15], cp2: grid[35, 10])
                      
            return path
        }
    }
    
    struct CuriositySegment: Shape {
        func path(in rect: CGRect) -> Path {
            let grid = layoutConfig.layout(in: rect)
            var path = Path()
            
            path.move(to: grid[10, 150])
            path.addLine(to: grid[10, 421])
            path.curve(grid[45, 461], cp1: grid[10, 461], cp2: grid[45, 461])
            
            path.addLine(to: grid[311, 461])
            path.curve(grid[312, 441], cp1: grid[332, 459], cp2: grid[312, 441])

            path.addLine(to: grid[35, 150])
            path.curve(grid[10, 150], cp1: grid[22, 134], cp2: grid[10, 140])
         
            return path
        }
    }
    
    struct SpiritSegment: Shape {
        func path(in rect: CGRect) -> Path {
            let grid = layoutConfig.layout(in: rect)
            var path = Path()
            
            path.move(to: grid[365, 177])
            path.addLine(to: grid[365, 423])
            path.curve(grid[330, 426], cp1: grid[365, 470], cp2: grid[330, 426])
            
            path.addLine(to: grid[225, 315])
            path.curve(grid[225, 289], cp1: grid[210, 302], cp2: grid[225, 289])
            
            path.addLine(to: grid[330, 186])
            path.curve(grid[365, 177], cp1: grid[365, 148], cp2: grid[365, 177])
         
            return path
        }
    }
}
