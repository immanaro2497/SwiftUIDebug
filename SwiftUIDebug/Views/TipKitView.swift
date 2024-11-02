//
//  TipKitView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 22/09/24.
//

import SwiftUI
import TipKit

struct PopoverTip: Tip {
    var title: Text {
        Text("Write what you want")
            .foregroundStyle(.white)
    }
    var message: Text? {
        Text("And our AI will create an unique image for you")
            .foregroundStyle(.white)
    }
    var image: Image? {
        Image(systemName: "wand.and.stars")
    }
}

struct CustomTipViewStyle: TipViewStyle {
    func makeBody(configuration: TipViewStyle.Configuration) -> some View {
        VStack {
            HStack(alignment: .top) {
                configuration.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40.0, height: 40.0)
                    .foregroundStyle(.gray)


                VStack(alignment: .leading, spacing: 8.0) {
                    configuration.title?
                        .font(.headline)
                    configuration.message?
                        .font(.subheadline)

                    ForEach(configuration.actions) { action in
                        Button(action: action.handler) {
                            action.label().foregroundStyle(.blue)
                        }
                    }
                }
                
                Button(action: { configuration.tip.invalidate(reason: .tipClosed) }) {
                    Image(systemName: "xmark").scaledToFit()
                        .foregroundStyle(.white)
                }
            }
        }
        .padding()
        .background(.indigo)
    }
}

struct TipKitView: View {
    let popoverTip = PopoverTip()
    @State private var text: String = ""

    var body: some View {
        VStack {
            TextField("Enter your name", text: $text)
                .textFieldStyle(.roundedBorder)
                .popoverTip(popoverTip)
                .onTapGesture {
                    popoverTip.invalidate(reason: .actionPerformed)
                }
                .tipViewStyle(CustomTipViewStyle())
            Spacer()
        }
        .padding()
    }
}

#Preview {
    BusView()
}

struct BusView: View {
    var body: some View {
        BusStopsViewControllerRepresentable()
    }
}

struct BusStopsViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let controller = BusStopsController()
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

class BusStopsController: UIViewController {
    
    override func viewDidLoad() {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.setTitle("tap me", for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.annotationViewDidTap()
        }, for: .touchUpInside)
        button.backgroundColor = .red
        view.addSubview(button)
    }
    
    func annotationViewDidTap() {
        print("annotation tapped")
        let detailView = BusStopDetailView()
        let controller = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(controller, animated: true)
    }
}

struct BusStopDetailView: View {
    var body: some View {
        BusStopDetailViewControllerRepresentable()
            .navigationBarTitleDisplayMode(.large)
            .ignoresSafeArea()
            .toolbar {
                //These ToolbarItems don't show up on iOS18, but does show up in iOS17
                ToolbarItem(placement: .principal) {
                    Text("11197")
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        print("toolbar star")
                    } label: {
                        Image(systemName: "star")
                    }
                }
            }
            .toolbarRole(.browser)
    }
}

struct BusStopDetailViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let controller = UIViewController()
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ImageCustomBackground: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
//                .frame(width: 120, height: 120)
                .foregroundStyle(.red)
                .background(.red)
            Image(systemName: "teddybear.fill")
                .resizable()
        }
        .aspectRatio(contentMode: .fit)
        .frame(width: 500, height: 100)
        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)
            let global = geometry.frame(in: .global)
            Rectangle()
                .frame(width: frame.width * 0.8, height: frame.height * 0.6)
                .foregroundStyle(.red)
                .background(.red)
                .padding(.leading, 16)
                .cornerRadius(16)
                .padding(.leading, -16)
//                .offset(y: 120)
                .position(x: frame.minX + 200, y: frame.maxY - 100)
            Image(systemName: "teddybear.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: frame.width * 0.7, height: frame.height * 0.8)
                .border(.black, width: 2)
                .offset(y: 30)
        }
//        .aspectRatio(contentMode: .fit)
        .frame(width: 400, height: 300)
        .border(.black, width: 2)
    }
}

struct LabelAlignment: UIViewRepresentable {
    var text: String
    var textAlignmentStyle : TextAlignmentStyle
    var width: CGFloat
    var fontName: String
    var fontSize: CGFloat
    var fontColor: UIColor

    func makeUIView(context: Context) -> UILabel {
        let font = UIFont(name: fontName, size: fontSize)
        let label = UILabel()
        label.textAlignment = NSTextAlignment(rawValue: textAlignmentStyle.rawValue)!
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = width
        label.font = font
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = fontColor
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.red
        shadow.shadowOffset = CGSize(width: 5, height: 5)
        shadow.shadowBlurRadius = 5
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        paragraphStyle.alignment = NSTextAlignment(rawValue: textAlignmentStyle.rawValue)!
        let attributedText = NSMutableAttributedString(
            string: "This is a quote from my favorite book. I will put many more of these quotes on this list. Enjoy for now thank you",
            attributes: [
                .font: UIFont.systemFont(ofSize: 21, weight: .bold),
//                .strokeColor: UIColor.red,
//                .strokeWidth: 5,
                .backgroundColor: UIColor.yellow,
                .paragraphStyle: paragraphStyle,
                .baselineOffset: 15,
//                .underlineStyle: 7,
//                .shadow: shadow,
            ])
        label.attributedText = attributedText

        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
    }
}

enum TextAlignmentStyle : Int{
     case left = 0 ,center = 1 , right = 2 ,justified = 3 ,natural = 4
}
