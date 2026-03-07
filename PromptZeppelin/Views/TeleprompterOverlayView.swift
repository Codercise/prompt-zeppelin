import SwiftUI

struct TeleprompterOverlayView: View {
    @ObservedObject var viewModel: TeleprompterViewModel

    var body: some View {
        ZStack {
            Color.clear

            HStack(spacing: 14) {
                ForEach(viewModel.displayWords) { item in
                    Text(item.word)
                        .font(.system(
                            size: viewModel.fontSize,
                            weight: item.isCurrent ? .bold : .regular,
                            design: .rounded
                        ))
                        .foregroundStyle(item.isCurrent ? .white : .white.opacity(0.45))
                        .lineLimit(1)
                        .fixedSize()
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 20)
            .background(.ultraThinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: 16))
        }
        .environment(\.colorScheme, .dark)
        .animation(.easeInOut(duration: 0.2), value: viewModel.currentWordIndex)
    }
}
