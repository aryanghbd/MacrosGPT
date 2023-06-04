//
//  ContentView.swift
//  MacrosGPT
//
//  Created by Aryan Ghobadi on 03/06/2023.
//

import SwiftUI
import Foundation
import ChatGPTSwift



struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SecondView()) {
                    Text("Input Macros")
                }
            }
        }
        .navigationBarTitle("ContentView")
    }
}

struct SecondView: View {
    
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fats = ""
    @State private var calories = ""
    @State private var mealCount = ""
    @State private var responseFetched = false
    @State private var apiResponse = ""
    
    let apiTok: String = "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"
    
    
    let api = ChatGPTAPI(apiKey: "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")
    
    func apiFetch(protein: Int, carbs: Int, fats: Int, calories: Int, meals: Int, completion: @escaping (String) -> Void) {
        Task {
            do {
                let response = try await api.sendMessage(text: "The user requires a meal plan that has total macros \(protein)g of protein, \(carbs)g of carbs and \(fats)g of fats. The total calories must be no more than \(calories) calories. The user would also like to split this into \(meals) different meals. Meet these specifications and do not deviate from the total macros or calories by more than 100 calories plus or minus. Do not give any commentary, as this is part of an app.")
                print(response)
                completion(response)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    var body: some View {
        VStack {
            Text("Input your macro requirements, and we will try to whip up a meal plan for you.")
            TextField("Enter your protein", text: $protein)
            
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter your carbs", text: $carbs)
            
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter your fats", text: $fats)
            
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter your daily Calorie Goal", text: $calories)
            
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Split into how many meals?", text: $mealCount)
            
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Text("Macros: \(protein)g P | \(carbs)g C | \(fats)g F")
                .font(.headline)
            NavigationLink(destination: ContentView()) {
                Text("Return to home")
            }
            Button(action: {
                apiFetch(protein: Int(protein) ?? 0, carbs: Int(carbs) ?? 0, fats: Int(fats) ?? 0, calories: Int(calories) ?? 0, meals: Int(mealCount) ?? 0) { response in
                    self.apiResponse = response
                    self.responseFetched = true
                }
            }) {
                Text("Load Data")
            }

            
        }
        .sheet(isPresented: self.$responseFetched) {
            MealPlanView(mealPlanText: $apiResponse)
        }
        .navigationBarTitle("Meal Plan Generator")
    }
}

struct MealPlanView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var mealPlanText: String
    var body: some View {
        
        ScrollView {
            Text(mealPlanText)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
