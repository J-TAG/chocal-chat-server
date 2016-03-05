import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtWebSockets 1.0

ApplicationWindow {
    id: main
    visible: true
    width: 600
    height: 400

    property var user_keys: []
    property var sockets: []

    function gotoLast() {
        messageView.positionViewAtEnd()
    }

    function appendStaticTextMessage(json) {
        messageModel.append(json)
        gotoLast()
    }

    function appendTextMessage(sender, message) {
        messageModel.append({
                                type: "plain",
                                name: qsTr("Unknown"),
                                message: message,
                                avatar: getAvatar(Qt.btoa(sender))
                            })
        gotoLast()
    }

    function appendInfoMessage(message) {
        messageModel.append({
                                type: "info",
                                name: "",
                                message: message,
                                avatar: ""
                            })
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
                    appendStaticTextMessage({type: "plain",
                                                name: "Sam Wise",
                                                message: "Hey There", avatar: getAvatar()})
                }

            }
            ToolButton {
                text: "Send 2"
                onClicked: {
                    appendStaticTextMessage({type: "plain",
                                                name: "John Brown",
                                                message: "Lorem ipsum dolor sit amet, ex vis vocent persius moderatius, est ne quando omnium invenire. Eius habeo disputationi quo ad. Ei nec modus eleifend. Laboramus maiestatis pro eu. An vel elitr scripta oblique, dicam aliquip mea ad, libris altera ad duo.

Et quo nisl tota, mei in eros mundi ludus, id omnis dicant intellegebat his. Ex reprimique honestatis est, quidam melius consequuntur eum at, nam no modo accusata invenire. Ex commodo eruditi moderatius vel. Ea brute congue complectitur has. Mea solum epicuri patrioque in, sea cu rebum viris gloriatur, in choro veniam scriptorem eum. Vel eu omnesque electram, no sit dolor patrioque.

Mel veri homero prodesset in, mel ne elit scripta consequuntur. Ex his suavitate reprimique reformidans. Has nusquam iudicabit ei. Doming omnesque cotidieque an sea, erat feugait euripidis id cum. Nec te dicit homero scripserit, ex his numquam docendi, no sint dicta everti pri. Ut adhuc civibus officiis vim. Vel in sanctus periculis, eu ullum torquatos sed.", avatar: getAvatar()})
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

            var user_key = Qt.btoa(webSocket.toString())

            user_keys.push(user_key)
            sockets[user_key] = webSocket

            console.warn("New client connected:", user_key)
            appendInfoMessage(qsTr("New client %1 now connected").arg(user_key))

            webSocket.onTextMessageReceived.connect(function(message) {

                console.warn("Client", Qt.btoa(webSocket.toString()), "said:", message);

                appendTextMessage(webSocket, message);

                webSocket.sendTextMessage(JSON.stringify({
                                                             name: qsTr("Server"),
                                                             message:qsTr("Hello Client!")
                                                         }));
            });
        }

        onErrorStringChanged: {
            appendStaticTextMessage({
                                        name:qsTr("Error"),
                                        message:qsTr("Server error: %1").arg(errorString)
                                    });
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

        delegate: MessageDelegate{}

    }

    // End chat area

    // Functions

    // Get avatar path by id
    function getAvatar(user_key) {

        if(user_key === undefined || user_key === null || !fileio.hasAvatar(user_key)) {
            return "qrc:/img/img/no-avatar.png"
        }

        return "file:///" + fileio.getAvatarPath(user_key);
    }

}
