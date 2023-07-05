
import Foundation


func getBotResponse(message: String) -> String {
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("remind") {
        return "Okay i will remind you!"
    } else if tempMessage.contains("ingatkan") {
        return "Okay saya akan mengingatkanmu!"
    }else {
        return "OKAY :)"
    }
}
