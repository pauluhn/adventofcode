import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Run Tests")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
