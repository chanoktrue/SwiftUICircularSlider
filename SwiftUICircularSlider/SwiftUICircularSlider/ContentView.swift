//
//  ContentView.swift
//  SwiftUICircularSlider
//
//  Created by Thongchai Subsaidee on 5/8/2564 BE.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.init(red: 34/255, green: 30/255, blue: 47/255))
                .edgesIgnoringSafeArea(.all)
            
            TemperatureControlView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Config {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    let totalValue: CGFloat
    let knobRadius: CGFloat
    let radius: CGFloat
}

struct TemperatureControlView: View {
    
    @State var temperatureValue: CGFloat = 0.0
    @State var angleValue: CGFloat = 0.0
    
    let config = Config(
        minimumValue: 0.0,
        maximumValue: 40.0,
        totalValue: 40.0,
        knobRadius: 15.0,
        radius: 125.0)
    
    var body: some View {
        ZStack {
            
            //Background
            Circle()
                .frame(width: config.radius * 2, height: config.radius * 2)
                .scaleEffect(1.2)
            
            // Dash
            Circle()
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [3, 23.18]))
                .frame(width: config.radius * 2, height: config.radius * 2)
            
            // progress
            Circle()
                .trim(from: 0.0, to: temperatureValue / config.totalValue)
                .stroke(temperatureValue < config.maximumValue / 2 ? Color.blue : Color.red, lineWidth: 4)
                .frame(width: config.radius * 2, height: config.radius * 2)
                .rotationEffect(.degrees(-90))
            
            // Knob
            Circle()
                .fill(temperatureValue < config.maximumValue / 2 ? Color.blue : Color.red)
                .frame(width: config.knobRadius * 2, height: config.knobRadius * 2)
                .padding(10)
                .offset(y: -config.radius)
                .rotationEffect(Angle.degrees(Double(angleValue)))
                .gesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged({ value in
                            chage(location: value.location)
                        })
                )
            
            // Display
            Text("\(String.init(format: "%.0f", temperatureValue)) °")
                .font(.system(size: 60))
                .foregroundColor(.white)
        }
    }
    
    private func chage(location: CGPoint) {
        // createing vector from location point
        let vector = CGVector(dx: location.x, dy: location.y)
        
        // geting angle in radian need to substract the khob radius and pidding
        let angle = atan2(vector.dy - (config.knobRadius + 10), vector.dx - (config.knobRadius + 10)) + .pi / 2.0
        
        // convert angle range from (-pi to pi) to (0 to 2pi)
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        
        // convert angle value to temperature value
        let value = fixedAngle / (2.0 * .pi) * config.totalValue
        
        if value >= config.minimumValue && value <= config.maximumValue {
            self.temperatureValue = value
            self.angleValue = fixedAngle * 180 / .pi // converting to degrees
        }
    }
    
    
}
