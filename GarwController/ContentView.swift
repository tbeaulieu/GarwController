//
//  ContentView.swift
//  GarwController
//
//  Created by Tristan Beaulieu on 7/15/25.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    let udp = UDPClient()

    var body: some View {
        ZStack{
            Image("bkg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {                
                ControlButton(imageName: "up", soundName: "click", action: {
                    udp.sendCommand("0101")
                }).frame(width: 60, height: 121)
                HStack(spacing:0) {
                    ControlButton(imageName: "left", soundName: "click", action: {
                        udp.sendCommand("0104")
                    }).frame(width: 90, height: 60)
                    Spacer().frame(width: 40)
                    ControlButton(imageName: "right", soundName: "click", action: {
                        udp.sendCommand("0108")
                    }).frame(width: 90, height: 60)
                }
                ControlButton(imageName: "down", soundName: "click", action: {
                    udp.sendCommand("0102")
                }).frame(width: 60, height: 90)
                Spacer()
                       .frame(height: 100)
                
                ControlButton(imageName: "settingsButton", soundName: "settings", action: { udp.enterSettings()}).frame(width: 300, height: 87)
            }
            .padding()
        }
    }
}
