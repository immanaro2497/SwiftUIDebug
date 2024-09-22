//
//  Timeline.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 21/09/24.
//

import SwiftUI

struct SampleTimeline: View {
 
 let viewWidth:CGFloat = 340 //Width of HStack container for Timeline

 @State var frameWidth:CGFloat = 280 //Width of trimmer
 
 var minWidth: CGFloat {
     2*chevronWidth + 10
 } //min Width of trimmer
 
 @State private var leftViewWidth:CGFloat = 20
 @State private var rightViewWidth:CGFloat = 20
 
 var chevronWidth:CGFloat {
     return 24
 }
 
 var body: some View {
     
     HStack(spacing:0) {
         Color.black
             .frame(width: leftViewWidth)
             .frame(height: 70)
         
         HStack(spacing: 0) {
         
             Image(systemName: "chevron.compact.left")
                 .frame(width: chevronWidth, height: 70)
                 .background(Color.blue)
                 .gesture(
                     DragGesture(minimumDistance: 0)
                         .onChanged({ value in
                             leftViewWidth = max(leftViewWidth + value.translation.width, 0)
                             
                             if leftViewWidth > viewWidth - minWidth - rightViewWidth {
                                 leftViewWidth = viewWidth - minWidth - rightViewWidth
                             }
                                
                             frameWidth = max(viewWidth - leftViewWidth - rightViewWidth, minWidth)
                             
                         })
                         .onEnded { value in
                            
                         }
                 )
     
             Spacer()
             
             Image(systemName: "chevron.compact.right")
                 .frame(width: chevronWidth, height: 70)
                 .background(Color.blue)
                 .gesture(
                     DragGesture(minimumDistance: 0)
                         .onChanged({ value in
                             rightViewWidth = max(rightViewWidth - value.translation.width, 0)
                             
                             if rightViewWidth > viewWidth - minWidth - leftViewWidth {
                                 rightViewWidth = viewWidth - minWidth - leftViewWidth
                             }
                             
                             frameWidth = max(viewWidth - leftViewWidth - rightViewWidth, minWidth)
                         })
                         .onEnded { value in
                           
                         }
                 )
              
         }
         .foregroundColor(.black)
         .font(.title3.weight(.semibold))
       
         .background {
             
             HStack(spacing:0) {
                 Rectangle().fill(Color.red)
                     .frame(width: 70, height: 60)
                 Rectangle().fill(Color.cyan)
                     .frame(width: 70, height: 60)
                 Rectangle().fill(Color.orange)
                     .frame(width: 70, height: 60)
                 Rectangle().fill(Color.brown)
                     .frame(width: 70, height: 60)
                 Rectangle().fill(Color.purple)
                     .frame(width: 70, height: 60)
             }
             
         }
         .frame(width: frameWidth)
         .clipped()
         
         Color.black
             .frame(width: rightViewWidth)
             .frame(height: 70)
     }
     .frame(width: viewWidth, alignment: .leading)
 }
}

struct TestTimeline: View {
    let viewWidth: CGFloat = 340 //Width of HStack container for Timeline
    let chevronWidth: CGFloat = 24
    let minWidth: CGFloat = 10

    @State private var leftOffset: CGFloat = 0
    @State private var rightOffset: CGFloat = 0
    @GestureState private var leftDragOffset: CGFloat = 0
    @GestureState private var rightDragOffset: CGFloat = 0

    private func leftAdjustment(dragOffset: CGFloat) -> CGFloat {
        let maxAdjustment = viewWidth - rightOffset - (2 * chevronWidth) - minWidth
        return max(0, min(leftOffset + dragOffset, maxAdjustment))
    }

    private func rightAdjustment(dragOffset: CGFloat) -> CGFloat {
        let maxAdjustment = viewWidth - leftOffset - (2 * chevronWidth) - minWidth
        return max(0, min(rightOffset - dragOffset, maxAdjustment))
    }

//    private var frameWidth: CGFloat {
//        viewWidth
//        - (2 * chevronWidth)
//        - leftAdjustment(dragOffset: leftDragOffset)
//        - rightAdjustment(dragOffset: rightDragOffset)
//    }

    var body: some View {
        HStack(spacing: 0) {

            Image(systemName: "chevron.compact.left")
                .frame(width: chevronWidth, height: 70)
                .background(Color.blue)
                .offset(x: leftAdjustment(dragOffset: leftDragOffset))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating($leftDragOffset) { value, state, trans in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            leftOffset = leftAdjustment(dragOffset: value.translation.width)
                        }
                )

            Spacer()

            Image(systemName: "chevron.compact.right")
                .frame(width: chevronWidth, height: 70)
                .background(Color.blue)
                .offset(x: -rightAdjustment(dragOffset: rightDragOffset))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating($rightDragOffset) { value, state, trans in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            rightOffset = rightAdjustment(dragOffset: value.translation.width)
                        }
                )

        }
        .foregroundColor(.black)
        .font(.title3.weight(.semibold))
        .background {
            HStack(spacing: 0) {
                Color.red
                Color.cyan
                Color.orange
                Color.brown
                Color.purple
            }
            .padding(.vertical, 5)
            .padding(.horizontal, chevronWidth)
            .background(.background)
            .mask {
                Rectangle()
                    .padding(.leading, leftAdjustment(dragOffset: leftDragOffset))
                    .padding(.trailing, rightAdjustment(dragOffset: rightDragOffset))
            }
        }
        .frame(width: viewWidth)
        .background(.black)
    }
}

#Preview {
    VStack {
        SampleTimeline()
        Spacer()
        TestTimeline()
    }
}
