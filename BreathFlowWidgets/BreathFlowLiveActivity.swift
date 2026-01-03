import ActivityKit
import SwiftUI
import WidgetKit

struct BreathFlowLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BreathingActivityAttributes.self) { context in
            LockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        Image(systemName: "wind")
                            .font(.title2)
                            .foregroundColor(.cyan)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(context.state.phase.capitalized)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("\(context.state.phaseSecondsRemaining)s")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(context.state.breathsRemaining)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                        Text("breaths left")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 8) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 8)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(
                                            colors: [.cyan, .teal],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * context.state.progressPercentage, height: 8)
                            }
                        }
                        .frame(height: 8)

                        Text(context.attributes.exercisePattern)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 4)
                }
            } compactLeading: {
                Image(systemName: context.state.phase == "inhale" ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .foregroundColor(.cyan)
            } compactTrailing: {
                Text("\(context.state.breathsRemaining)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
            } minimal: {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    Circle()
                        .trim(from: 0, to: context.state.progressPercentage)
                        .stroke(Color.cyan, lineWidth: 2)
                        .rotationEffect(.degrees(-90))
                }
                .padding(2)
            }
        }
    }
}

struct LockScreenView: View {
    let context: ActivityViewContext<BreathingActivityAttributes>

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "wind")
                    .font(.title2)
                    .foregroundColor(.cyan)

                VStack(alignment: .leading) {
                    Text(context.attributes.exerciseName)
                        .font(.headline)
                    Text(context.attributes.exercisePattern)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("\(context.state.breathsRemaining)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                    Text("breaths left")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [.cyan, .teal],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * context.state.progressPercentage, height: 12)
                }
            }
            .frame(height: 12)

            HStack {
                Text(context.state.phase.capitalized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(context.state.phase == "inhale" ? .cyan : .teal)

                Spacer()

                Text("\(context.state.phaseSecondsRemaining)s remaining")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
    }
}
