//
//  ContentView.swift
//  Dynamic_Header
//
//  Created by Sai Krishna on 2/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var pullDistance: CGFloat = 0
    @State private var isRefreshing = false
    @State private var isSpinning = false
    @State private var selectedTab: TopSectionEnum = .first
    @State private var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var showAnnouncementPopView = false
    let refreshHeight: CGFloat = 100
    
    var heroOpacity: Double {
        let startFade: CGFloat = 0
        let endFade: CGFloat = -120
        if scrollOffset >= startFade { return 1 }
        if scrollOffset <= endFade { return 0 }
        let progress = (scrollOffset - endFade) / (startFade - endFade)
        return Double(progress)
    }
    
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        GeometryReader{ geo in
            let topInset = geo.safeAreaInsets.top
            let screenWidth = geo.size.width
            ZStack(alignment: .top) {
                
                Color(hex: "#F2F2F2").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        GeometryReader { geo -> Color in
                            let minY = geo.frame(in: .global).minY
                            DispatchQueue.main.async {
                                self.scrollOffset = minY
                                
                                if minY > 0 {
                                    self.pullDistance = minY - 60
                                } else {
                                    self.pullDistance = 0
                                }
                                if pullDistance > refreshHeight && !isRefreshing {
                                    startRefresh()
                                }
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
                .zIndex(1)
                loaderView(pullDistance: pullDistance,
                           isRefreshing: isRefreshing,
                           topInset: topInset)
                .zIndex(2)
                
                CustomHeader(scrollOffset: scrollOffset,
                             heroHeight: 276,
                             selectedTab: selectedTab,
                             showAnnouncementPopView: $showAnnouncementPopView,
                             isPad: isPad,
                             topInset: topInset
                )
                .ignoresSafeArea()
                .zIndex(3)
                
                if showAnnouncementPopView && !isPad {
                    ZStack(alignment: .topLeading) {
                        
                        Color.black
                            .ignoresSafeArea()
                            .opacity(0.001)
                            .onTapGesture {
                                withAnimation {
                                    showAnnouncementPopView = false
                                }
                            }
                            AnnouncementPopoverView()
                                .offset(
                                    x: topInset < 25 ? (screenWidth - (min(340, screenWidth - 32) / 2) - 180) : screenWidth - 360,
                                    y: topInset < 25 ? ((topInset + 5) + 20) : topInset - 5
                                )
                                .transition(.scale.combined(with: .opacity))
                                .frame(width: min(340, screenWidth - 32), height: 250)
                        
                    }
                    .zIndex(5)
                }
                
            }
            .onChange(of: scrollOffset) { newValue in
                if newValue < -146 {
                    stopTimer()
                } else {
                    startTimer()
                }
                
            }
        }
        
    }
    
    func startRefresh() {
        isRefreshing = true
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                isRefreshing = false
                pullDistance = 0
            }
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
                .onChange(of: selectedTab) { _ in
                    stopTimer()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        startTimer()
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
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    func startTimer() {
        timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
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
    
    func loaderView(pullDistance: CGFloat, isRefreshing: Bool, topInset: CGFloat) -> some View {
        
        let hiddenPosition: CGFloat = -120
        let fixedPosition: CGFloat = topInset + 2
        let currentY: CGFloat = isRefreshing ? fixedPosition : hiddenPosition
        
        let shouldShow = pullDistance > 10 || isRefreshing
        
        
        return Image(systemName: "arrow.clockwise.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(Color.white)
            .rotationEffect(.degrees(isSpinning ? 360 : 0))
            .animation(
                isSpinning
                ? .linear(duration: 0.5)
                    .repeatForever(autoreverses: false)
                : .easeOut(duration: 0.2),
                value: isSpinning
            )
            .onChange(of: isRefreshing) { refreshing in
                isSpinning = refreshing
            }
            .onAppear {
                if isRefreshing {
                    isSpinning = true
                }
            }
            .offset(y: currentY)
            .opacity(shouldShow ? 1 : 0)
            .animation(.interactiveSpring(response: 0.8, dampingFraction: 0.8), value: isRefreshing)
    }
}



struct CustomHeader: View {
    var scrollOffset: CGFloat
    var heroHeight: CGFloat
    var selectedTab: TopSectionEnum
    @Binding var showAnnouncementPopView: Bool
    var isPad: Bool
    var topInset: CGFloat
    var name: String = "Vemalla Srinivas Reddy"
    
    
    var isScrolled: Bool {
        let base: CGFloat = 146
        let inset: CGFloat = 44
        let result = base + (inset - topInset)
        return scrollOffset < -result
    }
    
    var body: some View {
        HStack(spacing: 0){
            VStack(alignment: .leading, spacing: 2) {
                Text("Hey, \(name)!")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isScrolled ? Color(hex: "#205188") : .white)
                
                Text("Welcome, we’re happy to have you here!")
                    .font(.system(size: 10))
                    .foregroundColor(isScrolled ? Color(hex: "#205188") : .white)
                
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                headerIconBtn(icon: "megaphone.fill", isScrolled: isScrolled){
                    showAnnouncementPopView.toggle()
                }
                .popover(
                    isPresented: Binding(
                        get: { showAnnouncementPopView && isPad },
                        set: { showAnnouncementPopView = $0 }
                    )
                ){
                    AnnouncementPopoverView()
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
        .padding(.top, topInset + 5)
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

struct AnnouncementPopoverView: View{
    @State private var announcementList:[String] = ["hello", "123","hello","hellohellohellohellohellohellohellohellohellohello","hello","hello","hellohellohellohellohellohellohellohellohellohellohellohellohellohello"]
    var body: some View{
        VStack(alignment: .leading, spacing: 0) {
            HStack{
                Text("Announcements")
                    .font(.headline)
                    
                Text("(\(announcementList.count))")
                    .font(.headline)
            }
            .padding(.bottom, 10)

            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .opacity(0.5)
            ZStack{
                if announcementList == []{
                    Text("No Announcements to show")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Color.gray)
                    
                }else{
                    ScrollView{
                        VStack{
                            ForEach(announcementList, id: \.self){ text in
                                Text(text)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 5)
                                Divider()
                            }
                        }.padding(.top, 15)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
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
