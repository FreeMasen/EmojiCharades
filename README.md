EmojiCharades
=============
This application facilitates a game between users
the concept is that user 1 creates a message that
consists of emoji, for example 😎💞🍕
the user 1 sends this to another user
when user 2 recieves this message he/she
will attempt to turn it into a sentence
in our example the answer would be 
"I love pizza"
user 2 would sent this text back to user 1
and user 1 would indicate if the the 
response was correct or not. 
User Interface
--------------
the user is first greeted with a login screen
the application utilized google signin to authenticate
its users.
![Login Screen](http://i.imgur.com/v723l8h.png)
Google re-directs the application into a webView
that will allow the user to authroize the app
to see his/her profile information
![Google Authorization](http://i.imgur.com/7rizjiT.png)
If the user has not used the app before
after he/she has authorized google
we need to create their profile, once
he/she clicks on the SignUp link 
this process is completed.
![Sign Up Message](http://i.imgur.com/VL3X68m.png)
The info button will take the user to 
a screen that will provide a bit of context 
for how the game works
![Info](http://i.imgur.com/cjcYo0P.png)
Once authenticated and logged in, the user
sees their list of messages. These are 
segrigated into ones that need a response,
ones that have been send by the user,
and ones that have been sent to the user.
the last tab is a profile page
![Messages](http://i.imgur.com/juEyIYY.png)
if the user selects a message he/she can
see all of the completed information, if there is
a response and if that response has been graded
![View Message](http://i.imgur.com/OsPTsri.png)
if the user wants to send a new message they
would need to enter a vaild email address
that ends with @gmail.com, then his/her
message would consist of only emoji
![New Message](http://i.imgur.com/tazcikG.png)
this profile should show the total score for the user
over all of the messages he/she has recieved
![Profile](http://i.imgur.com/HpFvCvo.png)

Code
----
#### Models
this application relies on two models, the 
first is the representation of a message, in
other words our user interaction
the message has a unique ID, a sender username
a reciever username, the emoji content, the text
response and an enum for if the message awards
a point to the sender or reciever
``` swift 
class Message : Equatable {
    let Id: UInt
    let Sender: String
    let Reciever: String
    let Content: String
    var Response: String = ""
    var PointTo: Score = .NotYetScored
    
    init(sender: String, reciever: String, content: String) {
        
        Id = UInt(NSDate().timeIntervalSince1970*1000000)
        Sender = sender
        Reciever = reciever
        Content = content
    }
    
    init(id: UInt, sender: String, reciever: String, content: String, response: String, pointTo: Score) {
        Id = id
        Sender = sender
        Reciever = reciever
        Content = content
        Response = response
        PointTo = pointTo
    }
    
    
    func scoreMessage(responseCorrect: Bool) {
        if responseCorrect {
            PointTo = .Reciever
        } else {
            PointTo = .Sender
        }
    }
    
    func asDictionary() -> AnyObject {
        let dictionary = ["sender":Sender, "reciever":Reciever, "content":Content, "response":Response, "pointTo":PointTo.rawValue]
        return dictionary
    }
    


}

func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.Id == rhs.Id
}

enum Score : Int{
    case NotYetScored
    case Sender
    case Reciever
}
```
the second  is the user model
this is a representation of our
user. 
``` swift 
class User {

    var Name: String
    var UserName: String
    var GlobalScore: Int
    var Messages: [Message]
    var messageCount: Int {
        return Messages.count
    }
    
    //for existing users
    init(name: String, userName: String, score: Int, messages: [Message]) {
        Name = name
        UserName = userName
        GlobalScore = score
        Messages = messages
    }
    
    //only for new users
    init(googleUser: GIDGoogleUser) {
        let email = googleUser.profile.email
        UserName = SignInHelper.removeSpecialChars(email)!
        Name = googleUser.profile.name
        GlobalScore = 0
        Messages = [Message]()
        Messages.append(Message(sender: "EmoJim", reciever: self.UserName, content: "😎👈💞🍕"))
    }
    ```
in addition to this it also is able to 
return a dictionary representation of
itself.  It also supplies a sublist
of messages based on the sender
and if the item qualifies as unread
``` swift 
func AsDictionary() -> AnyObject {
        let dictionary = ["name": Name, "globalScore": GlobalScore, "messages": messageArrayToDictionary()]
        return dictionary
    }
    
    //Converts the messages to dictionary to hand over to firebase
    func messageArrayToDictionary() -> [String: AnyObject] {
        var messages = [String: AnyObject]()
        for m in Messages {
            messages[String(m.Id)] = m.asDictionary()
        }
        return messages
    }
    
    func updateMessage(message: Message) {
        var oldMessage = Messages.filter { $0.Id == message.Id }[0]
        oldMessage = message
    }
    
    func removeMessage(messageID: UInt) {
        let shorterList = Messages.filter { $0.Id != messageID }
        self.Messages = shorterList
    }
    
    func sent() -> [Message]{
        return Messages.filter { $0.Sender == UserName }
    }
    
    func recieved() -> [Message] {
        return Messages.filter { $0.Reciever == UserName }
    }
    
    func unread() -> [Message] {
        let notYetGaded = Messages.filter { $0.PointTo == .NotYetScored }
        let needingResponse = notYetGaded.filter { $0.Sender != self.UserName && $0.Response == "" }
        let needingGrade = notYetGaded.filter { $0.Sender == self.UserName && $0.Response != "" }
        return needingGrade + needingResponse
    }
```

##### Static Classes
The data store for this application
is Google's flat-file storage system
called Firebase. One of the conditions
of this data store is that strings
stored cannot contain special characters
this means that we cannot use periods
or atmarks to stand as the username
the static class SignInHelper takes 
the gmail address and removes these
special characters.
``` swift
static func removeSpecialChars(email: String) -> String? {
        var beforeAt = String()
        var userName = String()
        for index in email.characters.indices {
            if email[index] == "@" {
                beforeAt = email.substringToIndex(index)
            }
        }
        for c in beforeAt.lowercaseString.characters {
            if c != "." {
            userName.append(c)
            }
        }
        if !userName.isEmpty {
            return userName
        }
        return nil
    }
```
The FirebaseHelper class is used
to interact with our data store.
Firebase system requres that
anyone looking to use their service
is to import their framework.
The Framework is built on a system
of subscriptions to a segment
of data.
there are a series of observers added
like the following.
``` swift 
let ref = FireBaseHelper.ConnectToFirebase().childByAppendingPath("users/\(user.UserName)/messages")
        ref.observeEventType(.ChildAdded, withBlock: { u in
            do {
            try FireBaseHelper.processMessageUpdate(u, user: self.user!)

            } catch {
                print("TVC.ChildAdded: \(error)")
            }
        })
```
the ref is our URL string, we then
add an observer that is alerted
whenever an event happens.
the above example happens
when a new message is added
to a user.
this static class also contains the methods
for parsing the response. For the
user:

``` swift 
static func parseUser(queryResponse: FDataSnapshot, userName: String) throws -> User {
        if let score = queryResponse.value["globalScore"] as? Int,
            name = queryResponse.value["name"] as? String,
            mResponse = queryResponse.value["messages"] as? [String : NSDictionary]  {
            do {
                let messages = try parseMessages(mResponse)
                return User(name: name, userName: userName, score: score, messages: messages)
            } catch {
                throw FBError.messgaeParseFail
            }
        } else {
            throw FBError.userParseFail
        }
    }
```
for the messages:
``` swift
static func parseMessages(messages: [String:NSDictionary]) throws -> [Message] {
        var messageArray = [Message]()

        for (key, value) in messages {
            if let id = key as? String,
                sender = value["sender"] as? String,
                reciever =  value["reciever"] as? String,
                content = value["content"] as? String,
                response = value["response"] as? String,
                pointTo = value["pointTo"] as? Int {
                let score = Score(rawValue: pointTo)!
                    let newMessage = Message(id: UInt(id)!, sender: sender, reciever: reciever, content: content, response: response, pointTo: score)
                    messageArray.append(newMessage)
            } else {
                throw FBError.messgaeParseFail
            }
        }
        return messageArray
    }
```
Outside of the subscriptions
we have the ability to add
new users and new messages 
to each user's profile.
``` swift 
static func insertNewUser(user: User) {
        let users = ConnectToFirebase().childByAppendingPath("/users/\(user.UserName)")
        users.setValue(user.AsDictionary())
    }
    
    static func insertNewMessage(message: Message) {
        let sender = message.Sender
        let reciever = message.Reciever
        let senderLocation = ConnectToFirebase().childByAppendingPath("/users/\(sender)/messages/\(message.Id)")
        senderLocation.setValue(message.asDictionary())
        let recieverLoction = ConnectToFirebase().childByAppendingPath("/users/\(reciever)/messages/\(message.Id)")
        recieverLoction.setValue(message.asDictionary())
    }
    
    static func getUser(email: String, completionHandler: (user: User)->()) throws  {
        var u: User?
        if let username = SignInHelper.removeSpecialChars(email) {
            let query = ConnectToFirebase().childByAppendingPath("/users/\(username)")
            do {
                query.observeSingleEventOfType(.Value, withBlock: { q in
 
                        u = try? parseUser(q, userName: username)
                    if u != nil {
                        completionHandler(user: u!)
                    }
                })
            }
        }
        if u == nil {
            throw FBError.generalError
        }
    }
```
##### Firebase Example
Below you will find an visual examble
of how our user and messages are stored
within Firebase.
![firebase example](http://i.imgur.com/78G3839.png)
