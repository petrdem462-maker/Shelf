
import SwiftUI

struct RootView: View {
    var body: some View {
        TabView{
            NavigationStack {
                Text("Search goes here")
                    .navigationTitle("Search")
            }
            .tabItem {Label("Search", systemImage: "magnifyingglass")}
            
            NavigationStack {
                Text("Here are your books")
                    .navigationTitle("Library")
            }
            .tabItem {Label("Library", systemImage: "books.vertical")}
            
            NavigationStack {
                Text("Here are your stats")
                    .navigationTitle("Stats")
            }
            .tabItem {Label("Stats", systemImage: "chart.bar")}
        }
    }
}

#Preview {
    RootView()
}
