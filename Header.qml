import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle {
    id: rect

    anchors {
        top: parent.top
        right: parent.right
        left: parent.left
    }
    height: imgServer.height + txtStatus.height + 40

    z: 4

    color: "#eee"
    state: "show"

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

    // Transitions
    transitions: Transition {
        // smoothly reanchor settings panel and move into new position
        AnchorAnimation {
            easing.type: Easing.OutExpo
            duration: 600
        }
    }

    // States
    states: [
        // For showing panel
        State {
            name: "show"
            AnchorChanges {
                target: rect
                anchors.top: parent.top
            }
//            AnchorChanges {
//                target: btnCollapseExpand
//                anchors.top: rect.bottom
//            }
        },
        // For hiding panel
        State {
            name: "hide"
            AnchorChanges {
                target: rect
                anchors.top: undefined
                anchors.bottom: parent.top
            }
//            AnchorChanges {
//                target: btnCollapseExpand
//                anchors.top: undefined
//                anchors.bottom: rect.bottom
//                anchors.right: rect.right
//            }
        }
    ]

}

