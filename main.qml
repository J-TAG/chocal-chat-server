import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtWebSockets 1.0

ApplicationWindow {
    id: main
    visible: true
    width: 600
    height: 400

    function gotoLast() {
        messageView.positionViewAtEnd()
    }

    function appendTextMessage(message) {
        messageModel.append(message)
        gotoLast()
    }

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
                text: "Send 1"
                onClicked: {
                    appendTextMessage({name: "Sam Wise",
                                          message: "Hey There"})
                }

            }
            ToolButton {
                text: "Send 2"
                onClicked: {
                    appendTextMessage({name: "John Brown",
                                          message: "This is a realy realy realy realy realy realy realy realy realy realy realy realy realy long message"})
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
        listen: true
        onClientConnected: {
            webSocket.onTextMessageReceived.connect(function(message) {
                appendTextMessage({name: "unknown", message: qsTr("Server received message: %1").arg(message)});
                webSocket.sendTextMessage({name: "server", message:qsTr("Hello Client!")});
            });
        }
        onErrorStringChanged: {
            appendMessage({name:"error", message:qsTr("Server error: %1").arg(errorString)});
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
        height: 60

        z: 2

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

    }
    // End header area


    // Chat area
    ListView {
        id: messageView
        anchors {
            top: rectHeader.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 40
        }

        spacing: 40

        model: messageModel

        delegate: MessageDelegate {}

    }
    // End chat area

}
