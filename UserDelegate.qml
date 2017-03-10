import QtQuick 2.5
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.0

// Container rectangle
Rectangle {
    id: rect

    height: layout.height
    width: userView.width

    color: Material.background


    Row {
        id: layout
        spacing: 20

        height: Math.max(itmText.height, itmImage.height, columnDel.height) + 20

        // Avatar item
        Item {
            id: itmImage

            height: 60
            width: 70

            anchors.verticalCenter: parent.verticalCenter

            // Avatar image
            Image {
                id: imgAvatar
                height: 60
                width: 60
                y: 0
                x: 10

                fillMode: Image.PreserveAspectCrop
                source: main.getAvatar(user_key)

                // Circle effect
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: imgAvatar.width
                        height: imgAvatar.height
                        Rectangle {
                            anchors.centerIn: parent
                            width: Math.min(imgAvatar.width, imgAvatar.height)
                            height: width
                            radius: Math.min(width, height)
                        }
                    }
                }
            }
            // End avatar image
        }
        // End avatar item

        // Text item
        Item {
            id: itmText

            height: txtName.height + txtStatus.height + 20
            width: txtName.width

            anchors.verticalCenter: parent.verticalCenter

            // User name
            Text {
                id: txtName
                y: 5
                width: userView.width - 90
                text: name
                color: "#ea8627"
                font.bold: true
                wrapMode: Text.Wrap
                horizontalAlignment:  Text.AlignLeft
            }

            // Status text
            Text {
                id: txtStatus

                anchors {
                    top: txtName.bottom
                    topMargin: 10
                }

                color: "teal"
                text: qsTr("Online")
            }

        }
        // End text item

    }
    // End row

    // Handle mouse click
    MouseArea {
        anchors.fill: layout
        onClicked: {
            rectDel.state = "show"
        }
    }
    // End handling mouse click

    // Delete question rectangle
    Rectangle {
        id: rectDel

        anchors.fill: parent

        state: "hide"
        color: Material.background

        // Delete question layout
        Column {
            id: columnDel
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            // Delete question text
            Text {
                anchors {
                    right: parent.right
                    left: parent.left
                }
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap

                text: qsTr("Are you sure? You are about to remove this user from chat")
            }

            // Buttons
            Row {

                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                // Remove button
                Button {
                    text: qsTr("Remove")
                    onClicked: {
                        forceCloseClient(user_key)
                    }
                }

                // No button
                Button {
                    text: qsTr("No")
                    onClicked: {
                        rectDel.state = "hide"
                    }
                }

            }
            // End buttons

        }
        // End delete question layout


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
            // For showing question
            State {
                name: "show"
                PropertyChanges {
                    target: rectDel
                    opacity: .8
                    enabled: true
                }
            },
            // For hiding question
            State {
                name: "hide"
                PropertyChanges {
                    target: rectDel
                    opacity: 0
                    enabled: false
                }
            }
        ]
    }
    // End delete question rectangle

}
// End container rectangle
