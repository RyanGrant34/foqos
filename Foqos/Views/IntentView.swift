import SwiftUI

struct IntentView: View {
  @EnvironmentObject var themeManager: ThemeManager
  let profile: BlockedProfiles
  let onConfirm: (String) -> Void
  let onDismiss: () -> Void

  @State private var intentText = ""
  @FocusState private var isFocused: Bool

  private let placeholder = "What are you working on?"

  var body: some View {
    VStack(spacing: 0) {
      // Handle bar
      Capsule()
        .fill(Color.secondary.opacity(0.3))
        .frame(width: 36, height: 4)
        .padding(.top, 12)
        .padding(.bottom, 24)

      VStack(alignment: .leading, spacing: 20) {
        // Header
        VStack(alignment: .leading, spacing: 6) {
          Text("SET YOUR INTENT")
            .font(.system(.caption, design: .monospaced))
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .kerning(1.5)

          Text("What's the one thing\nyou're locking in on?")
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(.primary)
            .lineSpacing(2)
        }

        // Profile badge
        HStack(spacing: 8) {
          Circle()
            .fill(themeManager.themeColor)
            .frame(width: 8, height: 8)
          Text(profile.name)
            .font(.system(.subheadline, design: .monospaced))
            .foregroundStyle(.secondary)
        }

        // Text input
        ZStack(alignment: .topLeading) {
          RoundedRectangle(cornerRadius: 14)
            .fill(Color(UIColor.secondarySystemBackground))
            .frame(minHeight: 90)

          if intentText.isEmpty {
            Text(placeholder)
              .font(.system(.body))
              .foregroundStyle(Color.secondary.opacity(0.5))
              .padding(.horizontal, 14)
              .padding(.vertical, 12)
          }

          TextEditor(text: $intentText)
            .font(.system(.body))
            .scrollContentBackground(.hidden)
            .background(.clear)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .frame(minHeight: 90)
            .focused($isFocused)
        }
        .frame(minHeight: 90)

        // Character hint
        HStack {
          Spacer()
          Text("\(intentText.count)/120")
            .font(.system(.caption2, design: .monospaced))
            .foregroundStyle(.tertiary)
        }

        Spacer().frame(height: 4)

        // Buttons
        VStack(spacing: 10) {
          Button {
            let trimmed = intentText.trimmingCharacters(in: .whitespacesAndNewlines)
            onConfirm(trimmed.isEmpty ? "" : trimmed)
          } label: {
            HStack(spacing: 8) {
              Image(systemName: "lock.fill")
                .font(.system(size: 14, weight: .semibold))
              Text("Lock In")
                .font(.system(.body, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(themeManager.themeColor)
            .foregroundStyle(contrastColor(for: themeManager.themeColor))
            .clipShape(RoundedRectangle(cornerRadius: 14))
          }

          Button {
            onDismiss()
          } label: {
            Text("Skip")
              .font(.system(.subheadline))
              .foregroundStyle(.secondary)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 12)
          }
        }
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 32)
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        isFocused = true
      }
    }
    .onChange(of: intentText) { _, new in
      if new.count > 120 {
        intentText = String(new.prefix(120))
      }
    }
  }

  // Pick black or white text depending on background brightness
  private func contrastColor(for color: Color) -> Color {
    let uiColor = UIColor(color)
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
    let luminance = 0.299 * r + 0.587 * g + 0.114 * b
    return luminance > 0.6 ? .black : .white
  }
}
