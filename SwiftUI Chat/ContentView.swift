//
//  ContentView.swift
//  SwiftUI Chat
//
//  Created by Nick Halavins on 6/7/19.
//  Copyright © 2019 AntiLand. All rights reserved.
//

import SwiftUI

// let's create a structure that will represent each message in chat
struct ChatMessage : Hashable {
    var message: String
    var avatar: String
    var color: Color
    // isMe will be true if We sent the message
    var isMe: Bool = false
}

struct ContentView : View {
    
    // @State here is necessary to make the composedMessage variable accessible from different views
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController: ChatController
    
    var messages = [
        ChatMessage(message: "Hello world", avatar: "A", color: .red),
        ChatMessage(message: "Hi", avatar: "B", color: .blue)
    ]
    
    var body: some View {
        
        // the VStack is a vertical stack where we place all our substacks like the List and the TextField
        VStack {
            // I've removed the Hello World text line from here and replaced it with a list
            // List is the way you should create any list in SwiftUI
            List {
                ForEach(chatController.messages.identified(by: \.self)) {
                    // we have several messages so we use the For Loop
                    ChatRow(chatMessage: $0)
                }
            }
            
            // TextField are aligned with the Send Button in the same line so we put them in HStack
            HStack {
                // this textField generates the value for the composedMessage @State var
                TextField($composedMessage, placeholder: Text("Message...")).frame(minHeight: 30)
                // the button triggers the sendMessage() function written in the end of current View
                Button(action: sendMessage) {
                    Text("Send")
                    
                }
                }.frame(minHeight: 50).padding()
                // that's the height of the HStack
            }
    }
    
    func sendMessage() {
        chatController.sendMessage(ChatMessage(message: composedMessage, avatar: "C", color: .green, isMe: true))
        composedMessage = ""
    }
    
}

// ChatRow will be a view similar to a Cell in standard Swift
struct ChatRow : View {
    var chatMessage: ChatMessage
    
    // body - is the body of the view, just like the body of the first view we created when opened the project
    var body: some View {
        Group {
            // if the message is sent by the user,
            // show it on the right side of the view
            if !chatMessage.isMe {
                // HStack - is a horizontal stack. We let the SwiftUI know that we need to place
                // all the following contents horizontally one after another
                HStack {
                    Text(chatMessage.avatar)
                    Text(chatMessage.message)
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(chatMessage.color, cornerRadius: 10)
                    // Spacer fills the gaps of the Horizontal stack between the content and the borders
                    Spacer()
                }
            } else {
                // else show the message on the left side
                HStack {
                    Spacer()
                    Text(chatMessage.message)
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(chatMessage.color, cornerRadius: 10)
                    Text(chatMessage.avatar)
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(ChatController())
    }
}
#endif
