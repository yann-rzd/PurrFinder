//
//  UserView.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

//import SwiftUI
//
//struct UserView: View {
//    @State private var currentTab: Tab = .profile
//
//    var body: some View {
//        VStack {
//            SegmentedController()
//                .padding(.horizontal, 40)
//                .padding(.top, 15)
//
//            TabView(selection: $currentTab) {
//                UserProfileView()
//                    .tag(Tab.profile)
//                    .toolbar(.hidden, for: .tabBar)
//
//                UserAlertView()
//                    .tag(Tab.settings)
//                    .toolbar(.hidden, for: .tabBar)
//            }
//        }
//    }
//
//    /// - Custom segmented control
//    @ViewBuilder
//    func SegmentedController() -> some View {
//        HStack(spacing: 0) {
//            TapableText(.profile)
//                .foregroundColor(Color("BluePurr"))
//                .overlay {
//                    /// - Current tab highlight with 3D animation
//                    CustomCorner(corners: [.topLeft, .bottomLeft], radius: 50)
//                        .fill(Color("BluePurr"))
//                        .overlay {
//                            TapableText(.settings)
//                                .foregroundColor(currentTab == .settings ? .white : .clear)
//                            /// - Since the 3D rotation is applied the view is rotated, with the help of scale fliping the next view
//                                .scaleEffect(x: -1)
//                        }
//
//                        /// - Flipping highlight hrizontally using 3D rotation
//                        .rotation3DEffect(.init(degrees: currentTab == .profile ? 0 : 180),
//                                          axis: (x: 0, y: 1, z: 0),
//                                          anchor: .trailing,
//                                          perspective: 0.4)
//                        .overlay {
//                            TapableText(.profile)
//                                .foregroundColor(currentTab == .settings ? .clear : .white)
//                        }
//                }
//                .zIndex(1)
//
//            /// - Put the view above the next view
//            TapableText(.settings)
//                .foregroundColor(Color("BluePurr"))
//                .zIndex(0)
//        }
//        .background {
//            ZStack {
//                Capsule()
//                    .fill(.white)
//
//                Capsule()
//                    .stroke(Color("BluePurr"), lineWidth: 2)
//            }
//        }
//    }
//
//    @ViewBuilder
//    func TapableText(_ tab: Tab) -> some View {
//        Text(tab.rawValue)
////            .frame(maxWidth: .infinity)
//            .font(.title3)
//            .fontWeight(.semibold)
//            .contentTransition(.interpolate)
//            .padding(.vertical, 12)
//            .padding(.horizontal, 40)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
//                    currentTab = tab
//                }
//            }
//    }
//}
//
//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView()
//    }
//}
//
///// - Custom corners
//struct CustomCorner: Shape {
//    var corners: UIRectCorner
//    var radius: CGFloat
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}
