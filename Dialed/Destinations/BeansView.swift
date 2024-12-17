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
                    BeanRow(bean: bean)
                    .contentShape(.rect)
                    // Add swipe actions here
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            // Delete the bean from the context
                            deleteBean(bean)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .listRowBackground(Color.inverseText.opacity(0.5))

                }
                .foregroundStyle(.primaryText)
                    .tint(.primaryBackground)
                    .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("My Beans")
        .navigationBarTitleDisplayMode(.large)
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
struct BeanRow: View {
    var bean : CoffeeBean
    @State var showDetails: Bool = false
    var body: some View {
        Button{
            showDetails = true
        }label:{
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
                            .foregroundStyle(.secondaryForeground)
                        Text("-")
                            .customFont(type: .light, size: .caption)
                            .foregroundStyle(.primaryText)
                            .padding(.horizontal, 5)
                        Text("roasted \(daysAgo(from: bean.roastedOn))").customFont(type: .regular, size: .caption).foregroundStyle(.primaryText)
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .contentShape(.rect)
        .sheet(isPresented: $showDetails, content: {
            BeanView(bean:bean, showDetails: $showDetails)
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.4), .medium])
                .presentationBackground(.ultraThinMaterial)
                .presentationCornerRadius(50)
        })
        // Add swipe actions here
    }
}
#Preview {
    ContentView()
}
