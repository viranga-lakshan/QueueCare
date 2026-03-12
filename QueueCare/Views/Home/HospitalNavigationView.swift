 import SwiftUI

struct HospitalNavigationView: View {
    
    @ObservedObject var controller: QueueController
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var isImageLoaded = false
    @State private var mapImage: UIImage?
    
    private let brandColor = Color(red: 54/255, green: 180/255, blue: 165/255)
    private let backgroundColor = Color(red: 248/255, green: 250/255, blue: 252/255)
    private let textColor = Color(red: 30/255, green: 41/255, blue: 59/255)
    private let mutedTextColor = Color(red: 100/255, green: 116/255, blue: 139/255)
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                
                ZStack {
                    if isImageLoaded {
                        hospitalMapView
                        
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                zoomControls
                                    .padding(.trailing, 20)
                                    .padding(.bottom, 20)
                            }
                        }
                    } else {
                        loadingView
                    }
                }
            }
        }
        .onAppear {
            loadMapImage()
        }
        .safeAreaInset(edge: .bottom) {
            AppBottomNavigationBar(
                selectedTab: controller.selectedDashboardTab,
                accentColor: brandColor
            ) { tab in
                controller.selectDashboardTab(tab)
            }
        }
    }
    
    // MARK: - TOP BAR
    
    private var topBar: some View {
        HStack {
            Button(action: controller.showDashboard) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(textColor)
                    .frame(width: 40, height: 40)
                    .background(.white)
                    .clipShape(Circle())
            }
            
            VStack(spacing: 2) {
                Text("Hospital Navigation")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(textColor)
                
                Text("Interactive Floor Map")
                    .font(.system(size: 13))
                    .foregroundStyle(mutedTextColor)
            }
            
            Spacer()
            
            Button(action: resetZoom) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(brandColor)
                    .frame(width: 40, height: 40)
                    .background(.white)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(.white)
    }
    
    // MARK: - LOADING VIEW
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(brandColor)
            
            Text("Loading Hospital Map...")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(mutedTextColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - MAP VIEW
    
    private var hospitalMapView: some View {
        GeometryReader { geometry in
            if let mapImage = mapImage {
                Image(uiImage: mapImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScale
                                lastScale = value
                                scale = min(max(scale * delta, 1.0), 5.0)
                            }
                            .onEnded { _ in
                                lastScale = 1.0
                            }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if scale > 1 {
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(mutedTextColor.opacity(0.5))
                    
                    Text("Map not available")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(mutedTextColor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    // MARK: - ZOOM CONTROLS
    
    private var zoomControls: some View {
        VStack(spacing: 12) {
            Button(action: zoomIn) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(brandColor)
                    .clipShape(Circle())
            }
            .disabled(scale >= 5)
            
            Button(action: zoomOut) {
                Image(systemName: "minus")
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(brandColor)
                    .clipShape(Circle())
            }
            .disabled(scale <= 1)
            
            Text("\(Int(scale * 100))%")
                .font(.system(size: 12, weight: .bold))
                .frame(width: 50)
                .padding(.vertical, 6)
                .background(.white)
                .cornerRadius(8)
        }
    }
    
    // MARK: - FUNCTIONS
    
    private func zoomIn() {
        withAnimation {
            scale = min(scale + 0.5, 5)
        }
    }
    
    private func zoomOut() {
        withAnimation {
            scale = max(scale - 0.5, 1)
            
            if scale == 1 {
                offset = .zero
                lastOffset = .zero
            }
        }
    }
    
    private func resetZoom() {
        withAnimation {
            scale = 1
            lastScale = 1
            offset = .zero
            lastOffset = .zero
        }
    }
    
    private func loadMapImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Load from Assets catalog
            let image = UIImage(named: "hospital_map")
            
            DispatchQueue.main.async {
                if let loadedImage = image {
                    self.mapImage = loadedImage
                    withAnimation(.easeIn(duration: 0.3)) {
                        self.isImageLoaded = true
                    }
                } else {
                    // Show error state
                    withAnimation {
                        self.isImageLoaded = true
                    }
                }
            }
        }
    }
}

#Preview {
    HospitalNavigationView(controller: QueueController())
}