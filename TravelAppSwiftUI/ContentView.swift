//
//  ContentView.swift
//  TravelAppSwiftUI
//
//  Created by Keto Nioradze on 14.12.23.
//

import SwiftUI

struct ContentView: View {
    @State var destin = [Destination]()
    @State private var showAlert = false
    @State private var travelTips = [
        "Always keep a copy of your important documents.",
        "Try local cuisine to experience the culture.",
        "Pack light and smart!",
        "Learn some basic phrases of the local language.",
    ]
    
    var body: some View {
        
        NavigationView {
            List(destin, id: \.id) { user in
                NavigationLink(destination: DestinationDetailScreen(destination: user)) {
                    VStack(alignment: .center, spacing: 5){
                        Image(user.cityName)
                            .resizable()
                            .frame(width: 200, height: 100)
                        Text(user.cityName)
                    }
                }
                .frame(height: 150)
            }
            .frame(width: 450)
            .navigationTitle("Destinations")
            .onAppear {
                fetchData()
            }
            .navigationTitle("Destinations")
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showAlert = true
            }) {
                Text("Travel Tips")
            })
            .alert(isPresented: $showAlert) {
                let randomTip = travelTips.randomElement() ?? ""
                return Alert(title: Text("Travel Tip"), message: Text(randomTip), dismissButton: .default(Text("Got it!")))
            }
        }
    }
    
    
    struct DestinationDetailScreen: View {
        let destination: Destination
        
        var body: some View {
            VStack {
                Text(destination.cityName)
                Image(destination.cityName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)
                
                Text(destination.description)
                
                NavigationLink(destination: Transport(transportInfo: destination.transport.map { $0.description })) {
                    Text("Transport")
                }
                
                NavigationLink(destination: MustSee(mustSeeInfo: destination.mustSee.map { $0.description })) {
                    Text("Must See")
                }
                
                NavigationLink(destination: Hotels(hotelsInfo: destination.hotels.map { $0.description })) {
                    Text("Hotels")
                }
            }
            .padding()
            .navigationTitle("Details")
        }
    }
    
    struct Transport: View {
        let transportInfo: [String]
        
        var body: some View {
            VStack {
                Text("Transport Information")
                ForEach(transportInfo, id: \.self) { info in
                    Text(info)
                }
                NavigationLink(destination: ContentView()) {
                    Text("Go to Main Screen")
                }
                .navigationBarHidden(true)
            }
            .padding()
        }
    }
    
    struct MustSee: View {
        let mustSeeInfo: [String]
        
        var body: some View {
            VStack {
                Text("Must See Information")
                
                ForEach(mustSeeInfo, id: \.self) { info in
                    Text(info)
                }
                NavigationLink(destination: ContentView()) {
                    Text("Go to Main Screen")
                }
                .navigationBarHidden(true)
            }
            .padding()
        }
    }
    
    struct Hotels: View {
        let hotelsInfo: [String]
        
        var body: some View {
            VStack {
                Text("Hotels Information")
                ForEach(hotelsInfo, id: \.self) { info in
                    Text(info)
                }
                NavigationLink(destination: ContentView()) {
                    Text("Go to Main Screen")
                }
                .navigationBarHidden(true)
            }
            .padding()
        }
    }
    
    
    // MARK: - Network Service and Model
    
    func fetchData() {
        let url = URL(string: "https://mocki.io/v1/fffc1897-2f53-46ad-917b-c1926e2470e1")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode(DestinationsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.destin = decodedData.destinations
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    struct DestinationsResponse: Decodable {
        let destinations: [Destination]
    }
    
    struct Destination: Decodable, Identifiable {
        let id = UUID()
        let cityName, mainImage, description: String
        let generalImages: [GeneralImage]
        let transport, mustSee, hotels: [Hotel]
    }
    
    enum GeneralImage: String, Codable {
        case image1 = "image1"
        case image2 = "image2"
        case image3 = "image3"
    }
    
    struct Hotel: Decodable {
        let image, name, description: String
    }
}


#Preview {
    ContentView()
}

