//
//  ContentView.swift
//  Dynamic_Header
//
//  Created by Sai Krishna on 2/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var isRefreshing: Bool = false
    @State private var selectedTab: TopSectionEnum = .first
    @State private var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    init() {
        UIRefreshControl.appearance().tintColor = .clear
    }
    
    var heroOpacity: Double {

        let startFade: CGFloat = 0
        let endFade: CGFloat = -120

        if scrollOffset >= startFade {
            return 1
        }
        if scrollOffset <= endFade {
            return 0
        }
        let progress = (scrollOffset - endFade) / (startFade - endFade)
        return Double(progress)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            if #available(iOS 15.0, *) {
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
                        
                        topSection()
                        
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
                .refreshable {
                    withAnimation { isRefreshing = true }
                    try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                    
                    withAnimation { isRefreshing = false }
                }
            } else {
                // Fallback on earlier versions
            }
            if isRefreshing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .scaleEffect(1.5)
                    .padding(.top, 70)
                    .zIndex(2)
                    .transition(.opacity)
            }
            
            CustomHeader(scrollOffset: scrollOffset,
                         heroHeight: 276,selectedTab: selectedTab)
            
            .ignoresSafeArea()
        }
    }
    
    func topSection() -> some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            let size = geo.size
            let height = size.height + (minY > 0 ? minY : 0)
            
            ZStack(alignment: .topLeading){
                Rectangle()
                    .fill(selectedTab.gradient)
                    .animation(.easeInOut(duration: 0.35), value: selectedTab)
                
                
                TabView(selection: $selectedTab) {
                    
                    ForEach(TopSectionEnum.allCases, id: \.self) { tab in
                        
                        heroPage(title: tab.title, image: tab.image)
                            .tag(tab)
                    }
                }
                .opacity(heroOpacity)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .onReceive(timer) { _ in
                    moveToNextTab()
                }
                
                
            }
            .frame(width: size.width, height: height)
            .offset(y: minY > 0 ? -minY : 0)
        }
        .frame(height: 236)
    }
    
    func moveToNextTab() {
        let allTabs = TopSectionEnum.allCases
        if let currentIndex = allTabs.firstIndex(of: selectedTab) {
            let nextIndex = (currentIndex + 1) % allTabs.count
            withAnimation {
                selectedTab = allTabs[nextIndex]
            }
        }
    }

    func heroPage(title: String, image: String) -> some View {
        
        ZStack(alignment: .topLeading) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("One Qualification.")
                        Text("Endless Global Opportunities")
                    }
                    .padding(.top, 7)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#C4D8ED"))
                }
                Spacer()
            }
            .padding(.leading, 30)
            .padding(.top, 108)
            
            Image(image)
                .frame(width: 111, height: 132)
                .frame(maxWidth: .infinity, alignment: .topTrailing)
                .padding(.top, 72)
                .padding(.trailing, 29)
        }
    }
}

struct CustomHeader: View {
    var scrollOffset: CGFloat
    var heroHeight: CGFloat
    var selectedTab: TopSectionEnum
    
    var isScrolled: Bool {
        return scrollOffset < -146
    }
    
    var body: some View {
        HStack(spacing: 0){
            VStack(alignment: .leading, spacing: 2) {
                Text("Hey, Vemalla Srinivas Reddy!")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isScrolled ? Color(hex: "#205188") : .white)
                
                Text("Welcome, we’re happy to have you here!")
                    .font(.system(size: 10))
                    .foregroundColor(isScrolled ? Color(hex: "#205188") : .white)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                headerIconBtn(icon: "megaphone.fill", isScrolled: isScrolled){
                    print("")
                }
                headerIconBtn(icon: "bell.fill", isScrolled: isScrolled){
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
        .shadow(radius: 0.5)
    }
    func headerIconBtn(icon: String, isScrolled: Bool, action: @escaping() -> Void) -> some View {
        
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
