import SwiftUI

struct ContentView: View {
    @AppStorage("darkMode") var darkMode = false

    var body: some View {
        TabView {
            Messages()
                .tabItem { Image(systemName: "envelope.fill") }

            Acorn()
                .tabItem { Image(systemName: "book") }

            SettingsView()
                .tabItem { Image(systemName: "gear") }

            CalendarView()
                .tabItem { Image(systemName: "calendar") }
        }
        .preferredColorScheme(darkMode ? .dark : .light)
        .onAppear { applyTabBarAppearance() }
        .onChange(of: darkMode) { applyTabBarAppearance() } // ✅ Re-applies when mode changes
    }
    
    private func applyTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray // ✅ systemGray adapts to dark/light mode
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
