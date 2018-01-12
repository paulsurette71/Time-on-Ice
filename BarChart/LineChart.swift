//
//  LineChart.swift
//  Time on Ice
//
//  Created by Surette, Paul on 2018-01-04.
//  Copyright © 2018 Surette, Paul. All rights reserved.
//

import UIKit

struct PointEntry {
    let value: Int
    let label: String

}

extension PointEntry: Comparable {
    static func <(lhs: PointEntry, rhs: PointEntry) -> Bool {
        return lhs.value < rhs.value
    }
    static func ==(lhs: PointEntry, rhs: PointEntry) -> Bool {
        return lhs.value == rhs.value
    }
}

class LineChart: UIView {
    
    //Class
    let timeFormat  = TimeFormat()
    
    /// gap between each point
    let lineGap: CGFloat = 60.0
    
    /// preseved space at top of the chart
    let topSpace: CGFloat = 5.0
    
    /// preserved space at bottom of the chart to show labels along the Y axis
    let bottomSpace: CGFloat = 40.0
    
    /// The top most horizontal line in the chart will be 10% higher than the highest value in the chart
    let topHorizontalLine: CGFloat = 110.0 / 100.0
    
    //Distance from edge
    let distanceFromEdge: CGFloat = 15  //Paul
    
    let fontSizeForLabels: CGFloat = 17
    
    var isCurved: Bool = false
    
    var averageStartPoint: CGPoint?
    var averageEndPoint: CGPoint?
    var averageTimeOnIce: Double?
    
    var dataEntries: [PointEntry]? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// Contains the main line which represents the data
    private let dataLayer: CALayer = CALayer()
    
    /// To show the gradient below the main line
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    /// Contains dataLayer and gradientLayer
    private let mainLayer: CALayer = CALayer()
    
    /// Contains mainLayer and label for each data entry
    private let scrollView: UIScrollView = UIScrollView()
    
    /// Contains horizontal lines
    private let gridLayer: CALayer = CALayer()
    
    /// An array of CGPoint on dataLayer coordinate system that the main line will go through. These points will be calculated from dataEntries array
    private var dataPoints: [CGPoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        mainLayer.addSublayer(dataLayer)
        scrollView.layer.addSublayer(mainLayer)
        
        gradientLayer.colors = [#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1).cgColor, #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor, #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor, #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor]
        
        scrollView.layer.addSublayer(gradientLayer)
        
        self.layer.addSublayer(gridLayer)
        self.addSubview(scrollView)
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    override func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        if let dataEntries = dataEntries {
            scrollView.contentSize = CGSize(width: CGFloat(dataEntries.count) * lineGap, height: self.frame.size.height)
            mainLayer.frame = CGRect(x: 0, y: 0, width: CGFloat(dataEntries.count) * lineGap, height: self.frame.size.height)
            dataLayer.frame = CGRect(x: 0, y: topSpace, width: mainLayer.frame.width, height: mainLayer.frame.height - topSpace - bottomSpace)
            gradientLayer.frame = dataLayer.frame
            dataPoints = convertDataEntriesToPoints(entries: dataEntries)
            gridLayer.frame = CGRect(x: 0, y: topSpace, width: self.frame.width, height: mainLayer.frame.height - topSpace - bottomSpace)
            
            clean()
//            drawHorizontalLines()
            
            if isCurved {
                drawCurvedChart()
            } else {
                drawChart()
            }
            maskGradientLayer()
            drawLables()
        }
    }
    
    /**
     Convert an array of PointEntry to an array of CGPoint on dataLayer coordinate system
     */
    private func convertDataEntriesToPoints(entries: [PointEntry]) -> [CGPoint] {
        if let max = entries.max()?.value,
            let min = entries.min()?.value {
            
            var result: [CGPoint] = []
            let minMaxRange: CGFloat = CGFloat(max - min) * topHorizontalLine
            
            //Average
            averageTimeOnIce = findAverage(array: entries)
            let averageHeight = dataLayer.frame.height * (1 - ((CGFloat(averageTimeOnIce!) - CGFloat(min)) / minMaxRange))
            averageStartPoint = CGPoint(x: CGFloat(0) * lineGap + distanceFromEdge, y: averageHeight)
            averageEndPoint = CGPoint(x: CGFloat(entries.count) * lineGap - 45, y: averageHeight)
            
            for i in 0..<entries.count {
                
                let height = dataLayer.frame.height * (1 - ((CGFloat(entries[i].value) - CGFloat(min)) / minMaxRange))
                let point = CGPoint(x: CGFloat(i)*lineGap + distanceFromEdge, y: height)
                result.append(point)
            }
            return result
        }
        return []
    }
    
    func findAverage(array: [PointEntry]) -> Double {
        
        var sumOfValues = 0
        
        for values in array {
            
            sumOfValues += values.value
            
        }
        
        let averageTimeOnIce = Double(sumOfValues) / Double(array.count)
        
        return averageTimeOnIce
        
    }  //findAverage
    
    /**
     Draw a zigzag line connecting all points in dataPoints
     */
    private func drawChart() {
        if let dataPoints = dataPoints,
            dataPoints.count > 0,
            let path = createPath() {
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = UIColor.black.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            dataLayer.addSublayer(lineLayer)
        }
    }
    
    /**
     Create a zigzag bezier path that connects all points in dataPoints
     */
    private func createPath() -> UIBezierPath? {
        guard let dataPoints = dataPoints, dataPoints.count > 0 else {
            return nil
        }
        let path = UIBezierPath()
        path.move(to: dataPoints[0])
        
        for i in 1..<dataPoints.count {
            path.addLine(to: dataPoints[i])
        }
        return path
    }
    
    /**
     Draw a curved line connecting all points in dataPoints
     */
    private func drawCurvedChart() {
        guard let dataPoints = dataPoints, dataPoints.count > 0 else {
            return
        }
        
        //print(dataPoints)
        
        if let path = CurveAlgorithm.shared.createCurvedPath(dataPoints) {
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.lineWidth = 4
            dataLayer.addSublayer(lineLayer)
        }
        
        //design the path
        let path = UIBezierPath()
        path.move(to: averageStartPoint!)
        path.addLine(to: averageEndPoint!)
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        shapeLayer.lineWidth = 2
        
        dataLayer.addSublayer(shapeLayer)
        
        
    }
    
    /**
     Create a gradient layer below the line that connecting all dataPoints
     */
    private func maskGradientLayer() {
        
        if let dataPoints = dataPoints,
            dataPoints.count > 0 {
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: dataPoints[0].x, y: dataLayer.frame.height))
            path.addLine(to: dataPoints[0])
            
            if isCurved,
                let curvedPath = CurveAlgorithm.shared.createCurvedPath(dataPoints) {
                path.append(curvedPath)
            } else if let straightPath = createPath() {
                path.append(straightPath)
            }
            
            path.addLine(to: CGPoint(x: dataPoints[dataPoints.count-1].x, y: dataLayer.frame.height))
            path.addLine(to: CGPoint(x: dataPoints[0].x, y: dataLayer.frame.height))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            maskLayer.fillColor = UIColor.clear.cgColor
            maskLayer.strokeColor = UIColor.clear.cgColor
            maskLayer.lineWidth = 0.5
            
            gradientLayer.mask = maskLayer
        }
    }
    
    /**
     Create titles at the bottom for all entries showed in the chart
     */
    private func drawLables() {
        
        if let dataEntries = dataEntries,
            dataEntries.count > 0 {
            
            for i in 0..<dataEntries.count {
                let textLayer = CATextLayer()
                textLayer.frame = CGRect(x: lineGap*CGFloat(i) - lineGap/2 + distanceFromEdge, y: mainLayer.frame.size.height - bottomSpace/2 - 8, width: lineGap, height: 20)
                
                textLayer.foregroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) //UIColor.black.cgColor
                textLayer.backgroundColor = UIColor.clear.cgColor
                textLayer.alignmentMode = kCAAlignmentCenter
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                textLayer.fontSize = fontSizeForLabels
                textLayer.string = dataEntries[i].label
                mainLayer.addSublayer(textLayer)
            }
        }
    }
    
    /**
     Create horizontal lines (grid lines) and show the value of each line
     */
    private func drawHorizontalLines() {
        guard let dataEntries = dataEntries else {
            return
        }
        
        var gridValues: [CGFloat]? = nil
        
//        if dataEntries.count < 4 && dataEntries.count > 0 {
//            gridValues = [0, 1]
//        } else if dataEntries.count >= 4 {
//            gridValues = [0, 0.25, 0.5, 0.75, 1]
//        }
        
        gridValues = [0, 0.5 ,1]
        
        if let gridValues = gridValues {
            
            for value in gridValues {
                let height = value * gridLayer.frame.size.height
                
                //                let path = UIBezierPath()
                //                path.move(to: CGPoint(x: 0, y: height))
                //                path.addLine(to: CGPoint(x: gridLayer.frame.size.width, y: height))
                //
                //                let lineLayer = CAShapeLayer()
                //                lineLayer.path = path.cgPath
                //                lineLayer.fillColor = UIColor.clear.cgColor
                //                lineLayer.strokeColor = UIColor.gray.cgColor
                //                if (value > 0.0 && value < 1.0) {
                //                    lineLayer.lineDashPattern = [4, 4]
                //                }
                
                //                gridLayer.addSublayer(lineLayer)
                
                var minMaxGap:CGFloat = 0
                var lineValue:Int = 0
                
                if let max = dataEntries.max()?.value  { //let min = dataEntries.min()?.value
                    minMaxGap = CGFloat(max) //* topHorizontalLine
                    lineValue = Int((1-value) * minMaxGap) //+ Int(min)
                }
                
                let textLayer = CATextLayer()
                textLayer.frame = CGRect(x: 4, y: height, width: 50, height: 20)
                textLayer.foregroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
                textLayer.backgroundColor = UIColor.clear.cgColor
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                textLayer.fontSize = fontSizeForLabels
                textLayer.string = timeFormat.mmSS(totalSeconds: lineValue)
                
                gridLayer.addSublayer(textLayer)
            }
        }
    }
    
    private func clean() {
        mainLayer.sublayers?.forEach({
            if $0 is CATextLayer {
                $0.removeFromSuperlayer()
            }
        })
        dataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        gridLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }
}
