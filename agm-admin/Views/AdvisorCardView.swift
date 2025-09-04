import SwiftUI

struct AdvisorCardView: View {
    let advisor: Advisor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Basic Information")
                .font(.headline)
            infoRow("Name", advisor.name)
            infoRow("Code", advisor.code)
            infoRow("Agency", advisor.agency)
            infoRow("Hierarchy1", advisor.hierarchy1)
            infoRow("Hierarchy2", advisor.hierarchy2)
            infoRow("Context", advisor.contextID)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder
    private func infoRow(_ label: String, _ value: String?) -> some View {
        HStack {
            Text(label)
                .font(.caption.bold())
            Spacer()
            Text(value ?? "-")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
