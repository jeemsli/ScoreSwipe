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
                Text("Note: For accurate results, swipe from the middle of the screen.")
                    .font(.headline)
            }
        }
    }
    
    private var legendSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            legendItem(color: .blue, text: "Your team's score is blue.")
            legendItem(color: .red, text: "Opponent team's score is red.")
            Text("Highlighted player will be serving.")
                .font(.headline)
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
