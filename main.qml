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

            ToolButton {
                text: qsTr("Start")
                onClicked: {
                    server.listen = true
                }
            }

            ToolButton {
                text: qsTr("Stop")
                onClicked: {
                    server.listen = false
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
        host: "192.168.1.12"
        port: 36911

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

                        // Name has not taken yet
                        console.warn("New client connected:", user_key)

                        sendInfoMessage(qsTr("New user %1 now joined to chat").arg(json.name))

                        webSocket.onStatusChanged.connect(function() {
                            console.warn("Client status changed:", user_key, "Status:", webSocket.status)
                            var user = getUserByKey(user_key)

                            if (webSocket.status === WebSocket.Error) {
                                // Only show errors to server
                                appendInfoMessage(qsTr("Client %1 has an error: %2 ").arg(user.name).arg(webSocket.errorString));
                            } else if (webSocket.status === WebSocket.Closed) {
                                var name = user.name
                                if(removeClient(user.user_key)) {
                                    sendInfoMessage(qsTr("%1 left the chat").arg(name));
                                }
                            }
                        });

                    } else {
                        // Name is duplicate
                        webSocket.sendTextMessage(JSON.stringify({
                                                                     type:"error",
                                                                     name: qsTr("Server"),
                                                                     message: qsTr("Name is duplicate"),
                                                                     image: "",
                                                                     user_key: "SYSTEM"
                                                                 }))
                        removeClient(user_key)
                        webSocket.active = false
                    }
                }

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

            text: qsTr("Listening on: %1").arg(server.url)
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

    }
    // End users area

    // Chat area
    ListView {
        id: messageView

        anchors {
            top: rectHeader.bottom
            bottom: parent.bottom
            left: userView.right
            right: rectSettings.left
            topMargin: 40
        }
        z: 3

        spacing: 40

        model: messageModel

        delegate: MessageDelegate{}

    }
    // End chat area

    // Settings area
    Rectangle {
        id: rectSettings

        anchors {
            top: rectHeader.bottom
            bottom: parent.bottom
            right: parent.right
        }
        z: 2
        width: main.width / 4

        color: "blue"
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
                                image: "",
                                user_key: "SYSTEM"
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

        // Everything is ok, so add user
        userModel.append({
                             socket: socket,
                             name: json.name,
                             user_key: user_key
                         })

        updateUserKeysIndex()

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
                                                            image: "",
                                                            user_key: "SYSTEM"
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
        var json_string = JSON.stringify(json)
        for(var i = 0; i < userModel.count; ++i) {
            userModel.get(i).socket.sendTextMessage(json_string);
        }
    }

    // Add user name to json object
    function addUserName(user_key, json) {
        json.name = getUserName(user_key)
    }

    // Check to see recieved json object from client is valid or not
    function validateRecievedMessage(socket, json) {
        // Check to see user key is valid or not
        if(json.user_key === "SYSTEM") {
            return false
        }

        return true
    }

    // Get avatar path by id
    function getAvatar(user_key) {

        if(user_key === undefined || user_key === null || !fileio.hasAvatar(user_key)) {
            return "qrc:/img/img/no-avatar.png"
        }

        return "file://" + fileio.getAvatarPath(user_key);
    }

    // Get user name by its user key
    function getUserName(user_key) {
        if(user_key === "SYSTEM") {
            return qsTr("Server")
        }

        return userModel.get(user_keys_index[user_key]).name
    }

}
