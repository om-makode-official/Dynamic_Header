//
//  TabView.swift
//  Dynamic_Header
//
//  Created by Sai Krishna on 2/12/26.
//

import SwiftUI

struct TabViewScreen: View {
    var body: some View {
        ContentView0()
    }
}

struct ContentView0: View {

    @State private var selectedIndex: Int = 0
    init() {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray
        }

    var body: some View {

        VStack {

            TabView(selection: $selectedIndex) {

                PageView(color: .red, title: "First Screen")
                    .tag(0)

                PageView(color: .blue, title: "Second Screen")
                    .tag(1)

                PageView(color: .green, title: "Third Screen")
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
        .ignoresSafeArea()
    }
}

struct PageView: View {

    var color: Color
    var title: String

    var body: some View {

        ZStack {
            color

            Text(title)
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}


struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewScreen()
    }
}
