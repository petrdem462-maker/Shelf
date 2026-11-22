import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @State private var viewModel: StatsViewModel

    init(library: LibraryRepository) {
        _viewModel = State(initialValue: StatsViewModel(library: library))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 12) {
                    StatTile(value: viewModel.stats.pagesThisMonth, label: "Pages this month")
                    StatTile(value: viewModel.stats.activeDaysThisMonth, label: "Reading days")
                    StatTile(value: viewModel.stats.finishedThisYear, label: "Finished this year")
                }
                
                if !viewModel.days.isEmpty {
                    Chart(viewModel.days, id: \.day) { item in
                        BarMark(x: .value("Day", item.day, unit: .day),
                                y: .value("Pages", item.pages))
                    }
                    .frame(height: 180)
                }

                Text("Top books this month")
                    .font(.headline)

                if viewModel.stats.topBooks.isEmpty {
                    Text("Log some reading to see your top books.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(viewModel.stats.topBooks.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Text("\(index + 1).")
                                .foregroundStyle(.secondary)
                            Text(item.title)
                                .lineLimit(1)
                            Spacer()
                            Text("\(item.pages) pages")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Stats")
        .onAppear { viewModel.load() }
    }
}

struct StatTile: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.largeTitle.bold())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let container = try! AppDatabase.makeContainer(inMemory: true)
    NavigationStack {
        StatsView(library: LibraryRepository(context: container.mainContext))
    }
    .modelContainer(container)
}
