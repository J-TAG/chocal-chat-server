import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle {
    id: rect

    color: "#eee"



    // Information text
    Text {
        id: txtInfo
        anchors {
            top: parent.top
            topMargin: 40
            right: parent.right
            rightMargin: 40
            left: parent.left
            leftMargin: 40
            bottomMargin: 40
        }

        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        onLinkActivated: Qt.openUrlExternally(link)
        text: qsTr("Chocal Chat is a free software that will run in your local network to provide a cross platform solution for communicating between each other.<br/><br/>This program is the server application.<br/><br/>Developer: Hesam Gholami<br/><br/>This project is available <a href=\"https://github.com/J-TAG/chocal-chat-server\">on github</a>")
    }

    // Pure Soft logo
    Image {
        id: imgPure
        source: "qrc:/img/img/puresoft-logo.png"
        anchors {
            top: txtInfo.bottom
            horizontalCenter: txtInfo.horizontalCenter
        }
    }

    // Copyright text
    Text {
        id: txtCopyright
        anchors {
            top: imgPure.bottom
            horizontalCenter: txtInfo.horizontalCenter
        }

        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        onLinkActivated: Qt.openUrlExternally(link)
        text: qsTr('All rights reserved. 2012 - 2016 by <a href="https://puresoftware.org">Pure Soft</a>')
    }

    // Close button
    Button {
        anchors {
            top: txtCopyright.bottom
            topMargin: 10
            horizontalCenter: txtCopyright.horizontalCenter
        }

        text: qsTr("OK")
        onClicked: {
            rect.state = "hide"
            flipable.flipped = true
        }
    }

    // Transitions
    transitions: Transition {
        // smoothly fade question
        PropertyAnimation{
            property: "opacity"
            easing.type: Easing.OutExpo
            duration: 1000
        }
    }

    // States
    states: [
        // For showing about box
        State {
            name: "show"
            PropertyChanges {
                target: rect
                opacity: .8
                enabled: true
            }
        },
        // For hiding about box
        State {
            name: "hide"
            PropertyChanges {
                target: rect
                opacity: 0
                enabled: false
            }
        }
    ]
}
