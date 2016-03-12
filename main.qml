import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtWebSockets 1.0

ApplicationWindow {
    id: main
    visible: true
    width: 900
    height: 500

    property var user_keys_index: []

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
    toolBar: ToolBar {
        Row {
            anchors.fill: parent

            // Start button
            ToolButton {
                text: qsTr("Start")
                onClicked: {
                    var host = settings.getString("ip")
                    var port = settings.getInt("port")

                    if(host.trim() === "") {
                        appendInfoMessage(qsTr("IP address is invalid"))
                        return
                    }

                    if(port === "" || port <= 0 || port >= 65534) {
                        appendInfoMessage(qsTr("Port number must be in range of 1 and 65534"))
                        return
                    }

                    server.host = host
                    server.port = port
                    server.listen = true
                    appendInfoMessage(qsTr("Chocal Server started on %1").arg(server.url))
                }
            }

            // Stop button
            ToolButton {
                text: qsTr("Stop")
                onClicked: {
                    server.listen = false
                    disconnecAllClients()
                    appendInfoMessage(qsTr("Listening stoped, all connections are closed and Chocal Server is now stoped."))
                }
            }

            // Settings button
            ToolButton {
                text: qsTr("Settings")
                onClicked: {
                    settingView.state = settingView.state === "show" ? "hide" : "show"
                }
            }

            // Shutdown button
            ToolButton {
                text: qsTr("Shutdown")
                onClicked: {
                    server.listen = false
                    disconnecAllClients()
                    Qt.quit()
                }
            }

        }
    }
    // End toolbar

    // Background picture
    Image {
        id: imgBackground
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/img/img/background.jpg"
    }

    // Web socket server
    WebSocketServer {
        id: server

        onClientConnected: {

            webSocket.onTextMessageReceived.connect(function(message) {

                var json = JSON.parse(message)

                // Check valid data
                validateRecievedMessage(webSocket, json)

                // Normal message
                if(json.type === "plain") {
                    sendTextMessage(webSocket, json)
                }

                // Image message
                if(json.type === "image") {
                    sendImageMessage(webSocket, json)
                }

                // Register message
                if(json.type === "register") {
                    // First message after socket connection

                    // If name is duplicate don't add new user
                    var user_key = newClient(webSocket, json)

                    if(user_key !== false) {

                        // Name is valid and is not taken yet
                        console.warn("New client connected:", user_key)

                        // Send accept message
                        sendAcceptMessage(user_key)

                        sendInfoMessage(qsTr("New user %1 now joined to chat").arg(json.name))

                        webSocket.onStatusChanged.connect(function() {
                            console.warn("Client status changed:", user_key, "Status:", webSocket.status)


                            if (webSocket.status === WebSocket.Error) {
                                // Only show errors to server
                                appendInfoMessage(qsTr("Error: %1 ").arg(webSocket.errorString));
                            } else if (webSocket.status === WebSocket.Closed) {
                                var user = getUserByKey(user_key)
                                var name = user.name
                                if(removeClient(user_key)) {
                                    sendInfoMessage(qsTr("%1 left the chat").arg(name));
                                }
                            }
                        });

                    } else {
                        // Name is duplicate or invalid
                        if(isUserNameDuplicate(json.name)) {
                            // Name is duplicate
                            sendSingleErrorMessage(webSocket, qsTr("Name is duplicate"))
                        } else {
                            // Name is not duplicate but Invalid
                            sendSingleErrorMessage(webSocket, qsTr("Name is invalid"))
                        }

                        // Close web socket due to error
                        webSocket.active = false
                    }
                }
                // End register type message

            });


        }

        onErrorStringChanged: {
            appendInfoMessage(qsTr("Server error: %1").arg(errorString))
        }

    }
    // End web socket server

    // Header area
    Rectangle {
        id: rectHeader

        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }
        height: 80

        z: 4

        color: "#eee"

        // Title label
        Label {
            id: lblTitle
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 20
            }

            text: qsTr("Chocal Server")
        }
        // End title label

        // Status text
        Text {
            id: txtStatus

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: lblTitle.bottom
                topMargin: 10
            }

            text: server.listen ? qsTr("Listening on: %1. Online users: %2").arg(server.url).arg(userModel.count) : qsTr("Chocal Server is ready to start.")
        }
        // End status text


    }
    // End header area

    // Users area
    ListView {
        id: userView

        anchors {
            top: rectHeader.bottom
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
            top: rectHeader.bottom
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
            top: rectHeader.bottom
            bottom: parent.bottom
            right: parent.right
        }
        z: 2
        width: main.width / 4

        state: "hide"
        color: "#eee"
        border.color: "#333"

    }
    // End settings area

    // Functions

    // Goes to last message on the list
    function gotoLast() {
        messageView.positionViewAtEnd()
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
        userModel.remove(user_keys_index[user_key])
        updateUserKeysIndex()
        return true
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
