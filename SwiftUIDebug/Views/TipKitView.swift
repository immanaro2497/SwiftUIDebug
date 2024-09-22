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
    CustomText()
}

struct CustomText: View {
    var body: some View {
        LabelAlignment(text: "nfjkwen fjenwjkfn gjnwerkgn gklrmkgm gknlrekmf", textAlignmentStyle: .center, width: 300, fontName: "Times-New-Roman", fontSize: 16, fontColor: .black)
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
