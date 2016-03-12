import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle {
    id: rect

    // Main Layout
    Column {
        id: colTitles
        anchors {
            fill: parent
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
        }
        spacing: 20

        // Title label
        Label {
            text: qsTr("Settings")
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Server IP field
        Row {
            width: parent.width

            // Description text
            Text{
                text:qsTr("Chocal Server IP address:")
                width: parent.width / 2
                wrapMode: Text.WordWrap
            }

            // Input field
            TextField {
                id: txtIp
                width: parent.width / 2
                placeholderText: qsTr("i.e. 192.168.1.2")
                text: settings.getString("ip")
            }
        }
        // End server IP field

        // Port number field
        Row {
            width: parent.width

            // Description text
            Text{
                text:qsTr("Port number:")
                width: parent.width / 2
                wrapMode: Text.WordWrap
            }

            // Input field
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
        // End port number field

        // New message notification field
        Row {
            width: parent.width

            // Description text
            Text{
                text:qsTr("Play new message sounds:")
                width: parent.width / 2
                wrapMode: Text.WordWrap
            }

            // Input switch
            Switch {
                id: switchMessageNotification
                checked: settings.getBool("newMessageSound", true)
            }
        }
        // End message notification field

        // Info notification field
        Row {
            width: parent.width

            // Description text
            Text{
                text:qsTr("Play info sounds:")
                width: parent.width / 2
                wrapMode: Text.WordWrap
            }

            // Input switch
            Switch {
                id: switchInfoNotification
                checked: settings.getBool("infoSound", true)
            }
        }
        // End info notification field


        // Bottom buttons
        Row {
            spacing: 10

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
                    settings.setValue("newMessageSound", switchMessageNotification.checked)
                    settings.setValue("infoSound", switchInfoNotification.checked)
                    appendInfoMessage(qsTr("Settings are successfuly saved. You must restart Chocal Server for settings to take effect"))
                    rect.state = "hide"
                }
            }

            // Cancel button
            Button {
                text: qsTr("Cancel")

                onClicked: {
                    rect.state = "hide"
                }
            }

        }
        // End bottom buttons


    }
    // End main layout


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
                anchors.right: rect.parent.right
                anchors.left: undefined
            }
        },
        // For hiding panel
        State {
            name: "hide"
            AnchorChanges {
                target: rect
                anchors.right: undefined
                anchors.left: rect.parent.right
            }
        }
    ]

}
