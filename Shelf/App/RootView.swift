
import SwiftUI

struct RootView: View {
    let dependencies: AppDependencies
    
    var body: some View {
        TabView{
            NavigationStack {
                SearchView(api: dependencies.api, library: dependencies.library)
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            
            NavigationStack {
                LibraryView(api: dependencies.api, library: dependencies.library)
            }
            .tabItem {Label("Library", systemImage: "books.vertical")}
            
            NavigationStack {
                StatsView(library: dependencies.library)
            }
            .tabItem { Label("Stats", systemImage: "chart.bar") }
        }
    }
}

#Preview {
    RootView(dependencies: AppDependencies())
}
