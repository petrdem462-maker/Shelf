
import SwiftUI

struct RootView: View {
    var body: some View {
        TabView{
            NavigationStack {
                Text("Search goes here")
                    .navigationTitle("Search")
                    .task {
                        do {
                            let response: SearchResponse = try await HTTPClient().get(.search(query: "dune", page: 1))
                            print("✅ Found \(response.numFound) books. First: \(response.docs.first?.title ?? "none")")
                        } catch {
                            print("❌ \(error.localizedDescription)")
                        }
                    }
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
