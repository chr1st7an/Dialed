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
    case small = 12
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

func daysAgo(from date: Date) -> String {
    let calendar = Calendar.current
    let currentDate = Date()
    
    if let days = calendar.dateComponents([.day], from: date, to: currentDate).day {
        switch days {
        case 0:
            return "today"
        case 1:
            return "yesterday"
        default:
            return "\(days) days ago"
        }
    }
    return "Invalid date"
}

import Foundation

/// - Enabling Popover for iOS
extension View{
    @available(iOS 14,*)
    @ViewBuilder
    func iOSPopover<Content: View>(isPresented: Binding<Bool>,arrowDirection: UIPopoverArrowDirection,@ViewBuilder content: @escaping ()->Content)->some View{
        self
            .background {
                PopOverController(isPresented: isPresented, arrowDirection: arrowDirection, content: content())
            }
    }
}

/// - Popover Helper
fileprivate struct PopOverController<Content: View>: UIViewControllerRepresentable{
    @Binding var isPresented: Bool
    var arrowDirection: UIPopoverArrowDirection
    var content: Content
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let hostingController = uiViewController.presentedViewController as? CustomHostingView<Content>{
            /// - Close View, if it's toggled Back
            if !isPresented {
                /// - Closing Popover
                uiViewController.dismiss(animated: true)
            } else {
                hostingController.rootView = content
                /// - Updating View Size when it's Update
                /// - Or You can define your own size in SwiftUI View
                hostingController.preferredContentSize = hostingController.view.intrinsicContentSize
                /// - If you don't want animation
                // UIView.animate(withDuration: 0) {
                //    hostingController.preferredContentSize = hostingController.view.intrinsicContentSize
                // }
            }
        }else{
            if isPresented{
                /// - Presenting Popover
                let controller = CustomHostingView(rootView: content)
                controller.view.backgroundColor = UIColor(Color.primaryBackground)
                controller.modalPresentationStyle = .popover
                controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
                /// - Connecting Delegate
                controller.presentationController?.delegate = context.coordinator
                /// - We Need to Attach the Source View So that it will show Arrow At Correct Position
                controller.popoverPresentationController?.sourceView = uiViewController.view
                /// - Simply Presenting PopOver Controller
                uiViewController.present(controller, animated: true)
            }
        }
    }
    
    /// - Forcing it to show Popover using PresentationDelegate
    class Coordinator: NSObject,UIPopoverPresentationControllerDelegate{
        var parent: PopOverController
        init(parent: PopOverController) {
            self.parent = parent
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
        
        /// - Observing The status of the Popover
        /// - When it's dismissed updating the isPresented State
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
    }
}

/// - Custom Hosting Controller for Wrapping to it's SwiftUI View Size
fileprivate class CustomHostingView<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = view.intrinsicContentSize
    }
}
// MARK: Popover Arrow Direction
enum ArrowDirection: String,CaseIterable{
    case up = "Up"
    case down = "Down"
    case left = "Left"
    case right = "Right"
    
    var direction: UIPopoverArrowDirection{
        switch self {
        case .up:
            return .up
        case .down:
            return .down
        case .left:
            return .left
        case .right:
            return .right
        }
    }
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
}

func formatDateNumber(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM.dd.yyyy" // Set the desired format
    return dateFormatter.string(from: date)
}

extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) {
            $0.next
        }.first { $0 is UIViewController } as? UIViewController
    }
}
private struct NavigationPopGestureDisabler: UIViewRepresentable {
    let disabled: Bool
    
    func makeUIView(context: Context) -> some UIView { UIView() }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            uiView
                .parentViewController?
                .navigationController?
                .interactivePopGestureRecognizer?.isEnabled = !disabled
        }
    }
}
public extension View {
    @ViewBuilder
    func navigationPopGestureDisabled(_ disabled: Bool) -> some View {
        background {
            NavigationPopGestureDisabler(disabled: disabled)
        }
    }
}
