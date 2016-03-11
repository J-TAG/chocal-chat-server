import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle {

    Column {
        id: colTitles
        anchors {
            fill: parent
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
        }
        spacing: 20

        Label {
            text: qsTr("Settings")
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            width: parent.width

            Text{
                text:qsTr("Chocal Server IP address:")
                width: parent.width / 2
                wrapMode: Text.WordWrap
            }
            TextField {
                id: txtIp
                width: parent.width / 2
                placeholderText: qsTr("i.e. 192.168.1.2")
            }
        }

        Row {
            width: parent.width

            Text{
                text:qsTr("Port number:")
                width: parent.width / 2
                wrapMode: Text.WordWrap
            }
            TextField{
                id: txtPort
                width: parent.width / 2
                placeholderText: qsTr("i.e. 36911")
                text: "36911"
            }
        }

        // Save button
        Button {
            text: qsTr("Save")
        }


    }

}
