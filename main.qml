import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtWebSockets 1.0

ApplicationWindow {
    id: main
    visible: true
    width: 900
    height: 500

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
                text: "Send 1"
                onClicked: {
                    appendTextMessage(0, {type: "plain",
                                                name: "Sam Wise",
                                                message: "Hey There",
                                                user_key: "key"})
                }

            }
            ToolButton {
                text: "Send 2"
                onClicked: {
                    appendTextMessage(0, {type: "plain",
                                                name: "John Brown",
                                                message: "Lorem ipsum dolor sit amet, ex vis vocent persius moderatius, est ne quando omnium invenire. Eius habeo disputationi quo ad. Ei nec modus eleifend. Laboramus maiestatis pro eu. An vel elitr scripta oblique, dicam aliquip mea ad, libris altera ad duo.

Et quo nisl tota, mei in eros mundi ludus, id omnis dicant intellegebat his. Ex reprimique honestatis est, quidam melius consequuntur eum at, nam no modo accusata invenire. Ex commodo eruditi moderatius vel. Ea brute congue complectitur has. Mea solum epicuri patrioque in, sea cu rebum viris gloriatur, in choro veniam scriptorem eum. Vel eu omnesque electram, no sit dolor patrioque.

Mel veri homero prodesset in, mel ne elit scripta consequuntur. Ex his suavitate reprimique reformidans. Has nusquam iudicabit ei. Doming omnesque cotidieque an sea, erat feugait euripidis id cum. Nec te dicit homero scripserit, ex his numquam docendi, no sint dicta everti pri. Ut adhuc civibus officiis vim. Vel in sanctus periculis, eu ullum torquatos sed.",
                                                user_key: "key"})
                }
            }

            ToolButton {
                text: "Send 3"
                onClicked: {
                    sendTextMessage(0, {type: "plain",
                                        name: "Sam Wise",
                                        message: "Hey There",
                                        user_key: "key"})
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
        host: "192.168.1.12"
        port: 36911

        onClientConnected: {

            console.warn("New client connected:", Qt.btoa(webSocket))

            webSocket.onTextMessageReceived.connect(function(message) {

                var json = JSON.parse(message)

                if(json.type === "register") {
                    // First message after socket connection
                    newClient(webSocket, json)
                    appendInfoMessage(qsTr("New client %1 now connected").arg(json.name))
                }

                if(json.type === "plain") {
                    sendTextMessage(webSocket, json)
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

    function gotoLast() {
        messageView.positionViewAtEnd()
    }

    function appendTextMessage(sender, json) {
        messageModel.append(json)
        gotoLast()
    }

    function appendInfoMessage(message) {
        messageModel.append({
                                type: "info",
                                name: "",
                                message: message,
                                user_key: "SYSTEM"
                            })
        gotoLast()
    }

    function newClient(socket, json) {
        var user_key = Qt.btoa(socket.toString())

        userModel.append({
                             socket: socket,
                             name: json.name,
                             user_key: user_key
                         })

        return true
    }

    function sendTextMessage(sender, json) {
        // Send message to all users
        appendTextMessage(sender, json)
        for(var i = 0; i < userModel.count; ++i) {
            userModel.get(i).socket.sendTextMessage(JSON.stringify(json));
        }
    }

    // Get avatar path by id
    function getAvatar(user_key) {

        if(user_key === undefined || user_key === null || !fileio.hasAvatar(user_key)) {
            return "qrc:/img/img/no-avatar.png"
        }

        return "file:///" + fileio.getAvatarPath(user_key);
    }

}
