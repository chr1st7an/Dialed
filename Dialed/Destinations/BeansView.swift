import SwiftUI
import CarBode
import SwiftData

struct BeansView: View {
    @EnvironmentObject var navigation: Navigation
    @Environment(\.modelContext) private var context
    @Query(sort: \CoffeeBean.name, order: .forward) var coffeeBeans: [CoffeeBean]
    @State private var animateGradient = true

    var body: some View {
        ZStack {
            LinearGradient(colors: animateGradient ? [.primaryBackground, .primaryForeground] : [.primaryForeground, .primaryBackground], startPoint: .top, endPoint: animateGradient ? .bottom : . bottomTrailing).edgesIgnoringSafeArea(.all)
                .onAppear {
                                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                                    animateGradient.toggle()
                                }
                }.ignoresSafeArea()
            VStack {
                List(coffeeBeans) { bean in
                    HStack(spacing: 15) {
                        VStack(alignment: .leading, spacing: 2) {
                            VStack(alignment: .leading) {
                                Text(bean.name)
                                    .customFont(type: .regular, size: .body)
                                    .foregroundStyle(.primaryText)
                                Text(bean.roaster)
                                    .customFont(type: .regular, size: .caption)
                                    .foregroundStyle(.primaryText)
                            }
                            HStack(spacing: 0) {
                                Text(bean.roast)
                                    .customFont(type: .bold, size: .caption)
                                    .foregroundStyle(.secondaryText)
                                Text("-")
                                    .customFont(type: .light, size: .caption)
                                    .foregroundStyle(.primaryText)
                                    .padding(.horizontal, 5)
                                Text("roasted 12 days ago")
                                    .customFont(type: .regular, size: .caption)
                                    .foregroundStyle(.primaryText)
                                
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .contentShape(.rect)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.primaryForeground))
                    .padding(.horizontal)
                    // Add swipe actions here
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            // Delete the bean from the context
                            deleteBean(bean)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .foregroundStyle(.primaryText)
                    .tint(.primaryBackground)
                    .scrollContentBackground(.hidden)
            }
        }
    }

    private func deleteBean(_ bean: CoffeeBean) {
        // Delete the bean from the context
        context.delete(bean)
        
        // Save the changes to the model context
        do {
            try context.save()
        } catch {
            print("Failed to save context after deleting: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
