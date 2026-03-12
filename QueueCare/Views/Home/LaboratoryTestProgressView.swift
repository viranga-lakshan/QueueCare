import SwiftUI

struct LaboratoryTestProgressView: View {
    @ObservedObject var controller: QueueController
    @ObservedObject var laboratoryController: LaboratoryController
    
    @State private var animatedTests: [TestProgressItem] = []
    @State private var currentTestIndex = 0
    @State private var isCompleting = false
    
    private let backgroundColor = Color(red: 0.92, green: 0.95, blue: 0.95)
    private let brandColor = Color(red: 7 / 255, green: 169 / 255, blue: 150 / 255)
    private let textColor = Color(red: 0.14, green: 0.16, blue: 0.18)
    private let mutedTextColor = Color(red: 0.44, green: 0.47, blue: 0.5)
    private let iconBlue = Color(red: 45 / 255, green: 81 / 255, blue: 145 / 255)
    
    private var testProgress: LaboratoryTestProgress {
        laboratoryController.testProgress
    }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                    .padding(.top, 12)
                    .padding(.horizontal, 22)
                
                VStack(spacing: 5) {
                    Text(testProgress.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                    
                    Text("Step \(testProgress.currentStep) / \(testProgress.totalSteps)")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                }
                .padding(.top, 16)
                
                // Test Progress Header
                HStack(spacing: 10) {
                    Image(systemName: "clock")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(iconBlue)
                    
                    Text("Test Progress")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 22)
                .padding(.top, 20)
                
                // Test Progress Cards
                VStack(spacing: 10) {
                    ForEach(animatedTests) { test in
                        testProgressCard(test: test)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 14)
                
                // Ward Location Card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ward Location")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                    
                    Text(testProgress.wardLocation)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(textColor)
                    
                    Divider()
                        .padding(.vertical, 2)
                    
                    Text("Estimated Completion")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(mutedTextColor)
                    
                    Text(testProgress.estimatedCompletion)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(iconBlue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                )
                .padding(.horizontal, 22)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            startProgressSimulation()
        }
        .safeAreaInset(edge: .bottom) {
            AppBottomNavigationBar(selectedTab: controller.selectedDashboardTab, accentColor: brandColor) { tab in
                controller.selectDashboardTab(tab)
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 0)
            )
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: -4)
        }
    }
    
    private var topBar: some View {
        HStack {
            Button(action: controller.showLaboratoryInpatientStatus) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(textColor)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.96))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            }
            
            Spacer(minLength: 0)
            
            BundleResourceImage(name: controller.dashboard.avatarImageName, fallbackSystemName: "person.crop.circle.fill")
                .frame(width: 34, height: 34)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
    }
    
    private func testProgressCard(test: TestProgressItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(test.name)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)
                
                Spacer()
                
                HStack(spacing: 5) {
                    if test.status == .completed {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(red: test.status.color.red, green: test.status.color.green, blue: test.status.color.blue))
                    }
                    
                    Text(test.status.title)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(red: test.status.color.red, green: test.status.color.green, blue: test.status.color.blue))
                }
            }
            
            Text(test.detail)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(mutedTextColor)
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: test.status.color.red, green: test.status.color.green, blue: test.status.color.blue).opacity(0.2))
                        .frame(height: 5)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: test.status.color.red, green: test.status.color.green, blue: test.status.color.blue))
                        .frame(width: geometry.size.width * test.progress, height: 5)
                }
            }
            .frame(height: 5)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Progress Simulation
    
    private func startProgressSimulation() {
        // Initialize with pending tests
        animatedTests = testProgress.tests
        
        // Start completing tests one by one
        completeNextTest()
    }
    
    private func completeNextTest() {
        guard currentTestIndex < animatedTests.count else {
            // All tests completed - navigate to completion screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    controller.showLaboratoryTestCompletion()
                }
            }
            return
        }
        
        let delay: Double
        switch currentTestIndex {
        case 0: delay = 2.0  // First test completes after 2 seconds
        case 1: delay = 3.0  // Second test completes after 3 seconds
        default: delay = 2.5 // Remaining tests
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                // Update test to completed status
                if currentTestIndex < animatedTests.count {
                    animatedTests[currentTestIndex] = TestProgressItem(
                        name: animatedTests[currentTestIndex].name,
                        status: .completed,
                        detail: "Completed successfully",
                        progress: 1.0
                    )
                }
                currentTestIndex += 1
            }
            
            // Complete next test
            completeNextTest()
        }
    }
}

#Preview {
    LaboratoryTestProgressView(controller: QueueController(), laboratoryController: LaboratoryController())
}
