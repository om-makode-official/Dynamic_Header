//
//  ContentView.swift
//  Dynamic_Header
//
//  Created by Sai Krishna on 2/11/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StretchyHeaderDashboard()
    }
}

struct StretchyHeaderDashboard: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var navController: UINavigationController?
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
  
        
        firstView()
    }
    
    func firstView() -> some View{
        ZStack(alignment: .top) {
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    GeometryReader { geo -> Color in
                        let minY = geo.frame(in: .global).minY
                        DispatchQueue.main.async {
                            self.scrollOffset = minY
                        }
                        return Color.clear
                    }
                    .frame(height: 0)
                    
                    HeroContent()
                    
                    ForEach(1...20, id: \.self) { i in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(i)")
                                    .frame(width: 300)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                    .padding()
                    
                }
            }

            CustomHeader(scrollOffset: scrollOffset,
                         heroHeight: 276)

                    .ignoresSafeArea()
        }
    }
    
}

struct CustomHeader: View {
    var scrollOffset: CGFloat
    var heroHeight: CGFloat
    
    var isScrolled: Bool {
        return scrollOffset < -146
    }
    
    var body: some View {
        HStack(spacing: 0){
            VStack(alignment: .leading, spacing: 2) {
                Text("Hey, Vemalla Srinivas Reddy!")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isScrolled ? Color(hex: "#205188") : .white)
                
                Text("Welcome, we’re happy to have you here!")
                    .font(.system(size: 10))
                    .foregroundColor(isScrolled ? Color(hex: "#205188") : .white.opacity(0.9))
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                
                HeaderIconBtn(icon: "megaphone.fill", isScrolled: isScrolled){
                    print("")
                }
                HeaderIconBtn(icon: "bell.fill", isScrolled: isScrolled){
                    print("")
                }
                
                
                Image("pic1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(isScrolled ? Color.gray.opacity(0.18) : Color.white.opacity(0.18), lineWidth: 2)
                    )
            }
        }

        .padding(.horizontal, 16)
        .padding(.bottom, 10)
        .padding(.top, 50)
        .background(isScrolled ? Color.white : Color.clear)
        .animation(.easeInOut(duration: 0.25), value: isScrolled)
        .shadow(radius: 20)
    }
}

struct HeaderIconBtn: View {
    let icon: String
    let isScrolled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            ZStack {
                Circle()
                    .fill(isScrolled ? Color.gray.opacity(0.12) : Color(hex: "F2F2F2").opacity(0.12))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(isScrolled ? Color(hex: "274B7E") : .white)
                    .frame(width: 20, height: 15)
                
            }
        }
        
        
    }
}

struct HeroContent: View {
    
    var body: some View {
        
        GeometryReader { geo in
            
            let minY = geo.frame(in: .global).minY
            let size = geo.size
            
            let height = size.height + (minY > 0 ? minY : 0)
            
            ZStack{
                
                LinearGradient(
                    colors: [
                        Color(hex: "#205188"),
                        Color(hex: "#64AEDE")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: size.width, height: height)
                .offset(y: minY > 0 ? -minY : 0)
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Dip IFR")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("One Qualification.")
                            Text("Endless Global Opportunities")
                        }
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 53)
                .padding(.top, 108)
            }
            
        }
        .frame(height: 236)
    }
}



extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
