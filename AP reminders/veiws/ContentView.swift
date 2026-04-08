import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            Messages()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            Acorn()
                .tabItem {
                    Image(systemName: "book")
                    Text("Classes")
                }
            
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            Calender()
                .tabItem {
                    Image(systemName: "calender")
                    Text("Settings")
                }
        }
    }
}
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

