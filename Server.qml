import QtQuick 2.5
import QtWebSockets 1.0

WebSocketServer {
    id: server

    onClientConnected: {

        webSocket.onTextMessageReceived.connect(function(message) {

            var json = JSON.parse(message)

            // Normal message
            if(json.type === "plain") {
                // Check valid data
                if(validateRecievedMessage(webSocket, json)) {
                    // Message is valid
                    sendTextMessage(webSocket, json)
                }
            }

            // Image message
            if(json.type === "image") {
                // Check valid data
                if(validateRecievedMessage(webSocket, json)) {
                    // Message is valid
                    sendImageMessage(webSocket, json)
                }
            }

            // Register message
            if(json.type === "register") {
                // First message after socket connection
                // Note that we can't validate register message because user has not any user_key yet

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

                            if(isValidUserKey(user_key)) {
                                var name = getUserName(user_key)
                                if(removeClient(user_key)) {
                                    sendInfoMessage(qsTr("%1 left the chat").arg(name));
                                }
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
        if(errorString !== "") {
            appendInfoMessage(qsTr("Server error: %1").arg(errorString))
        }
    }

}

