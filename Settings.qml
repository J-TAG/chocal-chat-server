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
                text: settings.getString("ip")
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
                validator: IntValidator {
                    top: 65534
                    bottom: 1
                }
                placeholderText: qsTr("i.e. 36911")
                text: settings.getInt("port", "36911")
            }
        }

        // Save button
        Button {
            text: qsTr("Save")

            onClicked: {
                if(!txtPort.acceptableInput) {
                    appendInfoMessage(qsTr("Please enter a port number between 1 and 65534"))
                    return
                }

                settings.setValue("ip", txtIp.text)
                settings.setValue("port", txtPort.text)
                appendInfoMessage(qsTr("Settings are successfuly saved. You must restart Chocal Server for settings to take effect"))
            }
        }


    }

}
