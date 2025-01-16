//
//  StoryPlayerView.swift
//  storytime
//
//  Created by Amanda Peterson on 1/11/25.
//

import SwiftUI
import AVKit

struct StoryPlayerView: View {
    let imageName: String
    @State private var isPlaying = false
    @State private var videoPlayer: AVPlayer?
    @State private var videoUrl = "https://firebasestorage.googleapis.com/v0/b/axisai.appspot.com/o/videos%2Fstorytime%2Fjack%20wild%20things.mp4?alt=media&token=ea057728-b5e5-424d-8b25-391e22c9c927"
    @State private var status: [String: Any] = [:]
    
    var body: some View {
        VStack {
            if !isPlaying {
                // Show book cover when not playing
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                // Video player view
                VideoPlayer(player: videoPlayer)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16/9, contentMode: .fit)
            }
            
            // Playback controls
            HStack(spacing: 40) {
                Button(action: {
                    handlePlayPress()
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                }
                
                Button(action: {
                    videoPlayer?.seek(to: .zero)
                    videoPlayer?.pause()
                    isPlaying = false
                }) {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 44))
                }
            }
            .padding()
        }
        .onAppear {
            // Initialize video player with the corresponding video URL
            // You'll need to replace this with your actual video URL
            //if let url = Bundle.main.url(forResource: imageName, withExtension: "mp4") {
            if let url = URL(string: videoUrl) {
                videoPlayer = AVPlayer(url: url)
            }
        }
    }
    
    private func handlePlayPress() {
        if isPlaying {
            videoPlayer?.pause()
        } else {
            videoPlayer?.play()
        }
        isPlaying.toggle()
    }
}
