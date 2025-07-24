import Foundation
import Network

extension Data {
    init?(hex: String) {
        let len = hex.count / 2
        var data = Data(capacity: len)
        var index = hex.startIndex

        for _ in 0..<len {
            let nextIndex = hex.index(index, offsetBy: 2)
            guard nextIndex <= hex.endIndex else { return nil }

            let byteString = hex[index..<nextIndex]
            if let byte = UInt8(byteString, radix: 16) {
                data.append(byte)
            } else {
                return nil
            }
            index = nextIndex
        }

        self = data
    }
}


class UDPClient: ObservableObject {
    @Published var isConnected: Bool = false
    private var connection: NWConnection?
    private var settingsMode = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    private let host: NWEndpoint.Host = "192.168.42.1"
    private let port: NWEndpoint.Port = 1234

    init() {
        setupConnection()
        monitorNetwork()
        startHeartbeat()
    }

    private func setupConnection() {
        connection = NWConnection(host: host, port: port, using: .udp)
        connection?.start(queue: .main)
    }
    private func monitorNetwork() {
            monitor.pathUpdateHandler = { [weak self] path in
                DispatchQueue.main.async {
                    self?.isConnected = path.status == .satisfied
                }
            }
            monitor.start(queue: queue)
        }
    
    private func send(hex: String) {
        guard let data = Data(hex: hex) else { return }
        connection?.send(content: data, completion: .contentProcessed({ error in
            if let error = error {
                print("Send error: \(error)")
            }
        }))
    }

    func sendCommand(_ hex: String) {
        send(hex: hex)
    }

    func enterSettings() {
        settingsMode = true
        send(hex: "0104") // Enter settings

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.send(hex: "0108") // Exit settings
            self.settingsMode = false
        }
    }

    private func startHeartbeat() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if !self.settingsMode {
                self.send(hex: "0100")
            }
        }
    }
}
