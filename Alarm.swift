import SwiftUI
import Foundation
import Combine

/*
 This SwiftUI component is a simple alarm setter. It includes a DatePicker for setting the alarm time and a Button to activate the alarm. The alarm time is displayed in a Text view.
*/

struct ContentView: View {
    @State private var alarmTime = Date()
    @State private var alarmSet = false
    @State private var image: UIImage? = nil
    @State private var cancellable: AnyCancellable? = nil
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Text("Loading...")
            }
            
            Text("Set Alarm")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            DatePicker("Select Time", selection: $alarmTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            
            Button(action: {
                self.alarmSet.toggle()
            }) {
                Text(alarmSet ? "Alarm Set for \(alarmTime)" : "Set Alarm")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            self.loadImage()
        }
    }
    
    func loadImage() {
        guard let url = URL(string: "https://source.unsplash.com/random") else {
            return
        }
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { self.image = $0 }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
