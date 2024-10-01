import SwiftUI

struct UserGuideView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                legendSection
                Divider()
                guideItem(image: "arrow.up", color: .red, text: "Swipe Up: Opponent team wins the rally.")
                Divider()
                guideItem(image: "arrow.down", color: .blue, text: "Swipe Down: Your team wins the rally.")
                Divider()
                guideItem(image: "arrow.left", color: .white, text: "Swipe Left: Undo the rally.")
                Text("For accurate results, swipe from the middle of the screen.")
                    .italic()
            }
        }
    }
    
    private var legendSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            legendItem(color: .blue, text: "Your team consists of you and your partner (P).")
            Text("Score is displayed in blue.")
                .foregroundStyle(.blue)
                .font(.headline)
            legendItem(color: .red, text: "Opponent team consists of opponent one (1) and opponent two (2).")
            Text("Score is displayed in red.")
                .foregroundStyle(.red)
                .font(.headline)
            Text("Server number is displayed in white.")
                .font(.headline)
            Text("Highlighted player represents the current server.")
                .italic()
        }
    }
    
    private func legendItem(color: Color, text: String) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
                .padding(.trailing)
            Text(text)
        }
    }
    
    private func guideItem(image: String, color: Color, text: String) -> some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(color)
                .padding(.trailing)
            Text(text)
                .font(.headline)
        }
    }
}

#Preview {
    UserGuideView()
}
