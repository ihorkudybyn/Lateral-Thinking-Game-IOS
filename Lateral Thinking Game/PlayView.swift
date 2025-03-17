//
//  PlayView.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 07/03/2025.
//

import SwiftUI
import UIKit


struct PlayView: View {
    @Environment(\.dismiss) var dismiss
    @State var isDarkModeOn: Bool = false
    @State var isScrolling: Bool = false
    @State private var stories: [Story] = []
    @State private var position: String? = "67897f78de168b6aaca00aa1"
    
    
    var body: some View {
        NavigationView {
            VStack {
                if !isScrolling{
                    HStack(alignment: .center) {
                        Button {
                            dismiss()
                        } label: {
                            BackButtonView(imageName: "backbutton")
                            
                        }
                        
                        Spacer()
                        
                        SubTitleView()
                        
                        Spacer()
                        
                        BackButtonView(imageName: "backbutton")
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 70)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(stories) { story in
                        StoryView(story: story, isDarkModeOn: $isDarkModeOn)
                    }.scrollTargetLayout()
                    .task {
                        do {
                            stories = try await loadStory()
                        } catch SError.invalidURL {
                            print("Invalid URL")
                        } catch SError.invalidResponse {
                            print("Invalid Response")
                        } catch SError.invalidData {
                            print("Invalid Data")
                        } catch {
                            print("unexpected error: \(error)")
                        }
                    }
                    .padding(.top, 3)
                }
                .scrollPosition(id: $position)
                .onScrollPhaseChange{ _, newPhase in
                    withAnimation(.default){
                        switch newPhase {
                        case .idle:
                            if position == "67897f78de168b6aaca00aa1" {
                                isScrolling = false
                            }
                        default:
                            isScrolling = true
                        }
                    }
                }
                
                
            }
            
            .background {
                MainBackgroundView()
                    .background(Color(.maincolor))
            }
            
        }
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden(true)
        .colorScheme(isDarkModeOn ? .dark : .light)
        
    }
    
    func loadStory() async throws -> [Story] {
        //        let endpoint = "http://localhost:8001/stories/"
        //
        //        guard let url = URL(string: endpoint) else {
        //            throw SError.invalidURL
        //        }
        //
        //        let (data, response) = try await URLSession.shared.data(from: url)
        //
        //        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        //            throw SError.invalidResponse
        //        }
        
        do {
            let decoder = JSONDecoder()
            
            let json =
"""
[
  {
    "_id": "67897f78de168b6aaca00aa1",
    "title": "The Silent Witness",
    "situation": "A man walks into a bank and asks the teller to give him all the money. The teller complies without saying a word, and the man leaves without anyone stopping him.",
    "solution": "The man is actually a technician, and he came to repair the ATM machine. The teller hands him a cash deposit box that was scheduled for maintenance, and the man leaves without issue.",
    "key_points": [
      {
        "key_point": "The man is a technician.",
        "hint": "He's not in the bank for a typical reason. His expertise is in something very different from what you might expect."
      },
      {
        "key_point": "He came to repair the ATM machine.",
        "hint": "What would someone be doing in a bank if they weren't there to take money? Think about a machine that might need maintenance."
      },
      {
        "key_point": "The teller gave the man a cash deposit box.",
        "hint": "The object given isn’t quite what you think it is. Consider what a bank might need to give out that isn't cash."
      }
    ]
  },
  {
    "_id": "67897f78de168b6aaca00aa2",
    "title": "The Locked Room Mystery",
    "situation": "A man is found unconscious in a locked room with no windows. The only other thing in the room is a gadget. What happened?",
    "solution": "The man was playing a virtual reality game in the VR headset. Thinking he was dodging an attack, he tripped over a chair, knocking himself out. The room was locked because he didn’t want anyone seeing him ‘fight for his life’ in virtual reality.",
    "key_points": [
      {
        "key_point": "The man was wearing a VR headset and playing a virtual reality game.",
        "hint": "He was engaged in an immersive experience that wasn't what it seemed."
      },
      {
        "key_point": "He thought he was dodging an attack.",
        "hint": "In his mind, he was reacting to something dangerous, but in reality, it was only a game."
      },
      {
        "key_point": "He fell and knocked himself out.",
        "hint": "His real-world environment caught him off guard while he was focused on the game."
      }
    ]
  },
  {
    "_id": "67897f78de168b6aaca00aa3",
    "title": "The Mystery of the Silent Employee",
    "situation": "A boss repeatedly calls an employee during work hours, but the employee never picks up. Frustrated, the boss storms to the employee's desk, only to find them diligently working and humming a tune. Why didn’t they answer?",
    "solution": "The employee works at a call center and has set their ringtone to silent because they can't risk their phone ringing while talking to customers all day. They assumed the boss would just walk over if it was urgent!",
    "key_points": [
      {
        "key_point": "The employee works at a call center.",
        "hint": "Think about an environment where phone calls are constant and need full attention."
      },
      {
        "key_point": "The employee set their ringtone to silent.",
        "hint": "It's a precaution to avoid distractions from the constant noise of phone calls."
      }
    ]
  },
  {
    "_id": "67897f78de168b6aaca00aa4",
    "title": "The Office Zombie",
    "situation": "A man arrives at the office every morning with pale skin, ragged clothes, and messy hair, but no one ever questions him. Why?",
    "solution": "The man works at a film production company and wears a zombie costume to test out new makeup and effects for an upcoming project. It’s part of his job to test out new outfits!",
    "key_points": [
      {
        "key_point": "The man works at a film production company.",
        "hint": "Think about a job where appearances can be part of the work itself."
      },
      {
        "key_point": "He wears a zombie costume for his job.",
        "hint": "The costume is part of a creative process rather than a personal choice."
      }
    ]
  },
  {
    "_id": "67897f78de168b6aaca00aa6",
    "title": "The Lucky Fall",
    "situation": "Sarah deliberately jumps from the 20th floor of a building. She doesn't use any safety equipment, yet she walks away completely unharmed.",
    "solution": "Sarah is a Hollywood stunt performer practicing her scene on a movie set. She jumped onto a large airbag that was positioned below, out of sight. The '20th floor' was actually just a prop built a safe distance from the ground on the movie set.",
    "key_points": [
      {
        "key_point": "She is a stunt performer",
        "hint": "Her job involves controlled dangerous activities for entertainment purposes."
      },
      {
        "key_point": "It was a movie set",
        "hint": "The location isn't what it appears to be - think about places where reality is often fabricated."
      },
      {
        "key_point": "The floor was a prop",
        "hint": "Numbers can be deceiving when everything is make-believe."
      }
    ]
  },
  {
    "_id": "67ced43062ea43b4f04b5a80",
    "title": "The Tech Paradox",
    "situation": "A tech expert is known for solving any tech-related problem, yet they never use smartphone or laptop. How do they manage to be so skilled?",
    "solution": "The person is a 'digital detox guru' who solves problems by teaching people to unplug and embrace the simple things in life, like pen and paper. Their expertise is in advising on how to avoid over-reliance on technology.",
    "key_points": [
      {
        "key_point": "The person is a 'digital detox guru'.",
        "hint": "Their work involves teaching people how to disconnect from modern technology."
      },
      {
        "key_point": "They advise on avoiding over-reliance on technology.",
        "hint": "They help others find balance by stepping away from constant screen use."
      }
    ]
  },
  {
    "_id": "67ced43062ea43b4f04b5a81",
    "title": "The Mysterious Illness",
    "situation": "A man visits a doctor, complaining of a strange illness. The doctor examines him, runs tests, and finds nothing wrong. The man insists he feels sick, but the doctor can't figure it out. What is the issue?",
    "solution": "The man was experiencing a placebo effect from reading too many medical articles online. He believed he was sick, but there was nothing actually wrong with him.",
    "key_points": [
      {
        "key_point": "He convinced himself he was sick",
        "hint": "Sometimes our minds can create physical symptoms."
      },
      {
        "key_point": "He read too many medical articles",
        "hint": "Knowledge isn't always helpful - sometimes it can lead us astray."
      }
    ]
  },
  {
    "_id": "67ced43062ea43b4f04b5a82",
    "title": "The Deadly Drink",
    "situation": "Every morning, John drinks a deadly poison. He never gets sick and lives a long life.",
    "solution": "John is a snake venom researcher who has been building up an immunity to various snake venoms by consuming tiny, gradually increasing doses over many years.",
    "key_points": [
      {
        "key_point": "He is a snake venom researcher",
        "hint": "His job involves working with natural toxins."
      },
      {
        "key_point": "He built up immunity gradually",
        "hint": "Think about how someone might safely handle dangerous substances over time."
      }
    ]
  },
  {
    "_id": "67ced43062ea43b4f04b5a83",
    "title": "The Cold Room",
    "situation": "Every time someone enters the room, they freeze.",
    "solution": "It's a photography studio where people come to get their pictures taken. To 'freeze' means to stand still and pose for the camera.",
    "key_points": [
      {
        "key_point": "It's a photo studio",
        "hint": "This room is meant to capture moments in time."
      },
      {
        "key_point": "Freeze means to pose",
        "hint": "The word has a different meaning in certain creative contexts."
      }
    ]
  },
  {
    "_id": "67ced43062ea43b4f04b5a84",
    "title": "The Morning Race",
    "situation": "Every morning, a professional runner deliberately loses a race to a group of amateurs. She's training for the Olympics.",
    "solution": "She's practicing with a team of visual effects artists who are developing new racing video games. By running at different speeds, she helps them capture realistic motion for various skill levels of game characters.",
    "key_points": [
      {
        "key_point": "She's not actually competing",
        "hint": "What looks like losing might serve a different purpose altogether."
      },
      {
        "key_point": "Her performance is being recorded",
        "hint": "Sometimes athletes work in industries beyond sports."
      },
      {
        "key_point": "They're recording her for video game development",
        "hint": "Why would someone want to study how an athlete moves?"
      }
    ]
  }
]
"""
            
            return try decoder.decode([Story].self, from: json.data(using: .utf8)!)
        } catch {
            throw SError.invalidData
        }
        
        
        
    }
}

#Preview {
    PlayView()
}

struct BackButtonView: View {
    var imageName: String
    
    var body: some View {
        ZStack{
            Circle().fill(.secondarymain)
                .shadow(radius: 3)
                .frame(height: 60)
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 40)
        }
        
    }
}


struct StoryView: View {
    var story: Story
    @Binding var isDarkModeOn: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.secondarymain)
                .opacity(0.9)
                .shadow(radius: 1)
            
            HStack(){
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(isDarkModeOn ? .black : .white )
                    .opacity(0.7)
                    .frame(maxWidth: 10)
                    .padding()
                
                VStack(){
                    Text(story.title)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .kerning(1)
                    Text(story.situation)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                    
                    
                }
                .multilineTextAlignment(.center)
                .padding(.trailing, 20)
                .lineLimit(4)
                
            }
        }
        .frame(height: 200)
        .padding(.horizontal, 15)
    }
}
