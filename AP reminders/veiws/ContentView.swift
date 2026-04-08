import SwiftUI

struct ContentView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() // makes it solid
        appearance.backgroundColor = UIColor.gray // your color
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            
            Messages()
                .tabItem {
                    Image(systemName:"envelope.fill")
                }
            
            Acorn()
                .tabItem {
                    Image(systemName: "book")
                }
            
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                }
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                }
        }
    }
}
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

