//
//  Config.swift
//  Dialed
//
//  Created by Christian Rodriguez on 11/25/24.
//
import SwiftUI

extension Text {
    func customFont(type: FontType, size: FontSize) -> Text {
        return self.font(Font.custom(type.rawValue, fixedSize: size.rawValue))
    }
}

enum FontType: String {
    case regular = "Parkinsans-Regular"
    case light = "Parkinsans-Light"
    case bold = "Parkinsans-Bold"
}

enum FontSize: CGFloat {
    case subheader = 22
    case header = 35
    case button = 30
    case body = 18
    case caption = 15
}

struct CircularTextView: View {
    @State var letterWidths: [Int:Double] = [:]
    
    @State var title: String
    
    var lettersOffset: [(offset: Int, element: Character)] {
        return Array(title.enumerated())
    }
    var radius: Double
    
    var body: some View {
        ZStack {
            ForEach(lettersOffset, id: \.offset) { index, letter in // Mark 1
                VStack {
                    Text(String(letter))
                        .font(.system(size: 14.5, design: .monospaced))
                        .foregroundColor(.primaryText)
                        .kerning(5)
                        .background(LetterWidthSize()) // Mark 2
                        .onPreferenceChange(WidthLetterPreferenceKey.self, perform: { width in  // Mark 2
                            letterWidths[index] = width
                        })
                    Spacer() // Mark 1
                }
                .rotationEffect(fetchAngle(at: index)) // Mark 3
            }
        }
        .frame(width: 200, height: 200)
        .rotationEffect(.degrees(214))
    }
    
    func fetchAngle(at letterPosition: Int) -> Angle {
        let times2pi: (Double) -> Double = { $0 * 2 * .pi }
        
        let circumference = times2pi(radius)
                        
        let finalAngle = times2pi(letterWidths.filter{$0.key <= letterPosition}.map(\.value).reduce(0, +) / circumference)
        
        return .radians(finalAngle)
    }
}

struct WidthLetterPreferenceKey: PreferenceKey {
    static var defaultValue: Double = 0
    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
}

struct LetterWidthSize: View {
    var body: some View {
        GeometryReader { geometry in // using this to get the width of EACH letter
            Color
                .clear
                .preference(key: WidthLetterPreferenceKey.self,
                            value: geometry.size.width)
        }
    }
}


func timeOfDayGreeting() -> String {
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: Date())
    switch hour {
    case 6..<12:
        return "Good morning"
    case 12..<18:
        return "Good afternoon"
    default:
        return "Good evening"
    }
}

/// For Reading the Source and Destination View Bounds for our Custom Matched Geometry Effect
struct MAnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    func underlineTextField(color: Color) -> some View {
        self
            .padding(.vertical, 10)
            .overlay(RoundedRectangle(cornerRadius: 25).frame(height: 2).padding(.top, 35))
            .foregroundColor(color)
            .padding(10)
    }
}
