import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle {
    id: rectHeader

    anchors {
        top: parent.top
        right: parent.right
        left: parent.left
    }
    height: imgServer.height + txtStatus.height + 40

    z: 4

    color: "#eee"

    Image {
        id: imgServer
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        fillMode: Image.PreserveAspectFit
        source: "qrc:/img/img/server.png"
    }

    // Status text
    Text {
        id: txtStatus

        anchors {
            horizontalCenter: imgServer.horizontalCenter
            top: imgServer.bottom
            topMargin: 10
        }

        wrapMode: Text.WordWrap
        text: server.listen ? qsTr("Listening on: %1. Online users: %2").arg(server.url).arg(userModel.count) : qsTr("Chocal Server is ready to start.")
    }
    // End status text

    Button {
        anchors {
            bottom: parent.bottom
            right: parent.right

        }

        text: qsTr("Collapse")
    }

}

