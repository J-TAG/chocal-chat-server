import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

ApplicationWindow {
    id: main
    visible: true
    width: 900
    height: 600

    property var user_keys_index: []

    // Timer for splash screen
    Timer {
        interval:2000; running: true; repeat: false
        onTriggered: flipable.flipped = true
    }

    // User model
    ListModel {
        id: userModel
    }
    // End user model

    // Message model
    ListModel {
        id: messageModel
    }
    // End message model

    // Application toolbar
    toolBar: Toolbar { id: toolbar }
    // End toolbar

    // Background tile picture
    Image {
        id: imgBackTile
        anchors.fill: parent
        fillMode: Image.Tile
        source: "qrc:/img/img/back-tile.jpg"
    }

    // Web socket server
    Server { id: server }
    // End web socket server

    // Flipable
    Flipable {
        id: flipable

        property bool flipped: false

        anchors.fill: parent

        // Main item
        back: Item {
            id: front
            anchors.fill: parent

            // Background picture
            Image {
                id: imgBackground
                source: "qrc:/img/img/background.jpg"
            }

            // Header area
            Header { id: header }
            // End header area

            // Users area
            ListView {
                id: userView

                anchors {
                    top: header.bottom
                    bottom: parent.bottom
                    left: parent.left
                }
                z: 2
                width: main.width / 4

                model: userModel

                delegate: UserDelegate{}

                // Add transitions
                add: Transition {
                    // Fade in animation
                    NumberAnimation {
                        property: "opacity";
                        from: 0; to: 1.0;
                        duration: 400
                    }
                    // Coming animation
                    NumberAnimation {
                        property: "scale";
                        easing.amplitude: 0.3;
                        easing.type: Easing.OutExpo
                        from:0; to:1;
                        duration: 600
                    }
                }
                // End add transitions

                // remove transitions
                remove: Transition {
                    // Fade in animation
                    NumberAnimation {
                        property: "opacity";
                        from: 1.0; to: 0;
                        duration: 400
                    }
                    // Coming animation
                    NumberAnimation {
                        property: "scale";
                        easing.amplitude: 0.3;
                        easing.type: Easing.OutExpo
                        from:1; to:0;
                        duration: 600
                    }
                }
                // End remove transitions

                // Displaced transitions
                displaced: Transition {
                    // Fade in animation
                    NumberAnimation {
                        property: "y";
                        easing.type: Easing.InOutBack
                        duration: 600
                    }
                }
                // End displaced transitions

            }
            // End users area



            // Chat area
            ListView {
                id: messageView

                anchors {
                    top: header.bottom
                    bottom: parent.bottom
                    left: userView.right
                    right: settingView.left
                    topMargin: 40
                }
                z: 3

                spacing: 40

                model: messageModel

                delegate: MessageDelegate{}

            }
            // End chat area

            // Settings area
            Settings {
                id: settingView

                anchors {
                    top: header.bottom
                    bottom: parent.bottom
                    right: parent.right
                }
                z: 2
                width: main.width / 4

                state: "hide"
                color: "#eee"

            }
            // End settings area
        }
        // End main item

        // Splash item
        front: Item {
            id: back
            anchors.fill: parent
            Rectangle {
                anchors.fill: parent
                color: "purple"

                // Title label
                Label {
                    anchors.centerIn: parent
                    color: "#eee"
                    font.pointSize: 72
                    text: qsTr("Chocal Server")
                }
                // End title label
            }
        }
        // End splash item

        // Transforms
        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            // set axis.x to 1 to rotate around x-axis
            axis.x: 1; axis.y: 0; axis.z: 0
            angle: 0    // the default angle
        }

        // States
        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: -180 }
            when: flipable.flipped
        }

        // Transitions
        transitions: Transition {
            NumberAnimation {
                target: rotation
                property: "angle"
                easing.type: Easing.OutQuint
                duration: 2000
            }
        }
    }
    // End flipabel

    // About box
    About {
        id: about

        anchors.fill: parent

        state: "hide"
    }

    // Functions

    // Goes to last message on the list
    function gotoLast() {
        messageView.currentIndex = messageModel.count - 1
    }

    // Show a plain text message in the message list
    function appendTextMessage(sender, json) {
        messageModel.append(json)
        gotoLast()
    }

    // Show an info message in the message list
    function appendInfoMessage(message) {
        messageModel.append({
                                type: "info",
                                name: "",
                                message: message,
                                image: ""
                            })
        gotoLast()
    }

    // Show an image message in the message list
    function appendImageMessage(sender, json) {
        messageModel.append(json)
        gotoLast()
    }

    // Add new client to server
    function newClient(socket, json) {
        var user_key = fileio.getNewUserKey()

        if(isUserNameDuplicate(json.name)) {
            // User name is taken before
            return false
        }

        // Empty name is not valid
        if(json.name.trim() === "") {
            return false
        }

        // Everything is ok, so add user
        userModel.append({
                             socket: socket,
                             name: json.name,
                             user_key: user_key
                         })

        updateUserKeysIndex()

        // Navigate to newly added user
        userView.currentIndex = user_keys_index[user_key]

        return user_key
    }

    // Remove an existing client from server
    function removeClient(user_key) {
        if(isValidUserKey(user_key)) {
            userModel.remove(user_keys_index[user_key])
            updateUserKeysIndex()
            return true
        }

        return false
    }

    // Close connection from a client and remove it from server
    function closeClient(user_key) {
        userModel.get(user_keys_index[user_key]).socket.active = false
    }

    // This function will exactly did what closeClient() does but also show a message that indicate admin is forcly closed client
    function forceCloseClient(user_key) {
        sendInfoMessage(qsTr("Server admin removed %1 from chat").arg(getUserName(user_key)))
        closeClient(user_key)
    }

    // Sync user_keys_index array
    function updateUserKeysIndex() {
        // Map user keys to their indices in user model
        for(var i = 0; i < userModel.count; ++i) {
            user_keys_index[userModel.get(i).user_key] = i;
        }
    }

    // Returns user object of requested user key
    function getUserByKey(user_key) {
        return userModel.get(user_keys_index[user_key])
    }

    // Returns true if user name is taken before
    function isUserNameDuplicate(user_name) {
        // Check to see if name is taken before or not
        for(var i = 0; i < userModel.count; ++i) {
            if(userModel.get(i).name === user_name) {
                return true
            }
        }
        return false
    }

    // Sends a text message to all clients
    function sendTextMessage(sender, json) {
        // Send message to all users
        addUserName(json.user_key, json)
        appendTextMessage(sender, json)
        removeUserKey(json)
        var json_string = JSON.stringify(json)
        for(var i = 0; i < userModel.count; ++i) {
            userModel.get(i).socket.sendTextMessage(json_string);
        }
    }

    // Sends and info message to all clients
    function sendInfoMessage(message) {
        // Send message to all users
        appendInfoMessage(message)
        var json_string = JSON.stringify(JSON.stringify({
                                                            type: "info",
                                                            name: getUserName("SYSTEM"),
                                                            message: message,
                                                            image: ""
                                                        }))

        for(var i = 0; i < userModel.count; ++i) {
            userModel.get(i).socket.sendTextMessage(json_string);
        }
    }

    // Sends an image message to all clients
    function sendImageMessage(sender, json) {
        // Send message to all users
        addUserName(json.user_key, json)
        appendImageMessage(sender, json)
        removeUserKey(json)
        var json_string = JSON.stringify(json)
        for(var i = 0; i < userModel.count; ++i) {
            userModel.get(i).socket.sendTextMessage(json_string);
        }
    }

    // Sends an accepted message to client to approve that client is successfuly registered in the system
    function sendAcceptMessage(user_key) {
        // Send message only to accepted client
        var json = {
            type: "accepted",
            name: getUserName("SYSTEM"),
            message: qsTr("You are joined to chat successfully."),
            user_key: user_key
        }

        var json_string = JSON.stringify(json)

        userModel.get(user_keys_index[user_key]).socket.sendTextMessage(json_string);
    }

    // Send an error message to a single client
    function sendSingleErrorMessage(socket, message) {
        var json_string = JSON.stringify({
                                             type:"error",
                                             name: qsTr("Server"),
                                             message: message,
                                             image: ""
                                         })

        socket.sendTextMessage(json_string)
    }

    // Add user name to json object
    function addUserName(user_key, json) {
        json.name = getUserName(user_key)
    }

    // Remove user key from json object
    function removeUserKey(json) {
        delete json.user_key
    }

    // Check to see recieved json object from client is valid or not
    function validateRecievedMessage(socket, json) {
        // Check to see user key is valid or not
        if(json.user_key === "SYSTEM" || !isValidUserKey(json.user_key)) {
            return false
        }

        return true
    }

    // Get avatar path by user name
    function getAvatar(name) {

        if(name === undefined || name === null || name === ""
                || name === getUserName("SYSTEM") || !fileio.hasAvatar(name)) {
            return "qrc:/img/img/no-avatar.png"
        }

        return "file://" + fileio.getAvatarPath(name);
    }

    // Get user name by its user key
    function getUserName(user_key) {
        if(user_key === "SYSTEM") {
            return qsTr("Server")
        }

        return userModel.get(user_keys_index[user_key]).name
    }

    // Check to see if user key is valid or not
    function isValidUserKey(user_key) {
        return typeof user_keys_index[user_key] !== 'undefined'
    }

    // Disconnect all clients
    function disconnecAllClients() {
        var count = userModel.count
        for(var i = 0; i < count; ++i) {
            userModel.get(0).socket.active = false
        }
        updateUserKeysIndex()
    }

}
