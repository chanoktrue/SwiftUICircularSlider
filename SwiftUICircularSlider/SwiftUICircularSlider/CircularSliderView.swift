//
//  CircularSliderView.swift
//  SwiftUICircularSlider
//
//  Created by Thongchai Subsaidee on 5/8/2564 BE.
//

import SwiftUI

struct CircularSliderView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 34/255, green: 30/255, blue: 47/255))
                .edgesIgnoringSafeArea(.all)
            
            TemperatureControlView()
        }
    }
}

struct CircularSliderView_Previews: PreviewProvider {
    static var previews: some View {
        CircularSliderView()
    }
}

private struct Config {
    let minimumValue: CGFloat
    let maxinumValue: CGFloat
    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
    let degrees: Double
}

private struct TemperatureControlView: View {
    
    @State var temperatureValue: CGFloat = 0.0
    @State var angleValue: CGFloat = 0.0
    
    let config = Config(
        minimumValue: 0.0,
        maxinumValue: 76,
        totalValue: 100,
        knobRadius: 15.0,
        radius: 125.0,
        degrees: -225
     )
    
    var body: some View {
        
        ZStack {
            
            // Background circle black color
            Circle()
                .frame(width: config.radius * 2, height: config.radius * 2)
                .scaleEffect(1.2)
            
            // Background progress
            Circle()
                
                .trim(from: 0.0, to: config.maxinumValue / 100)
                .stroke(Color.gray, lineWidth: 4)
                .frame(width: config.radius * 2, height: config.radius * 2)
                .rotationEffect(.degrees(config.degrees))
            
            // Progress
            Circle()
                .trim(from: 0.0, to: temperatureValue / config.totalValue)
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: config.radius * 2 , height: config.radius * 2)
                .rotationEffect(.degrees(config.degrees))
            
            // Knob
            Circle()
                .fill(Color.blue)
                .frame(width: config.knobRadius * 2, height: config.knobRadius * 2)
                .padding(10)
                .offset(y: -config.radius)
                .rotationEffect(Angle.degrees(Double(angleValue)))
                .gesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged({ value in
                            change(location: value.location)
                        })
                )
                .rotationEffect(.degrees(config.degrees + 90))
            
            // Display
            Text(display())
                .font(.system(size: 60))
                .foregroundColor(.white)
        }
        
    }
    
    private func change(location: CGPoint) {
        
        // Creating vector from location point
        let vector = CGVector(dx: location.x, dy: location.y)
        
        // Geting angle in radius need to subtract the knob radius and padding
        let angle = atan2(vector.dy - (config.knobRadius + 10), vector.dx - (config.knobRadius + 10)) + .pi / 2.0
        
        // Convert angle from (-pi to pi) to (0 to 2pi)
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        
        // Convert angel value to temperature value
        let value = fixedAngle / (2.0 * .pi) * config.totalValue
        
        if value >= config.minimumValue && value <= config.maxinumValue {
            self.temperatureValue = value
            self.angleValue = fixedAngle * 180 / .pi // Convert to degree
        }
    }
    
    private func display() -> String {
        let tempValue: Double = Double(self.temperatureValue)
        let value: Int = Int((tempValue * 10) / 25)
        let temp: Double = (Double(value) / 2)  + 15
        return String(format: "%.01f", temp) + "°"
    }
    
}
