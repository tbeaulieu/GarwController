import SwiftUI
import AVFoundation

struct ControlButton: View {
    var imageName: String
    var soundName: String
    var action: () -> Void

    // Make the player persist
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        Button(action: {
            playSound(named: soundName)
            triggerHaptic()
            action()
        }) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }

    func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            print("❌ Sound file \(name).wav not found.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("❌ Failed to play sound: \(error)")
        }
    }

    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
}
