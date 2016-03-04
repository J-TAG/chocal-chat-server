import QtQuick 2.5
import QtGraphicalEffects 1.0

Item {
    id: itm

    height: layout.height
    width: layout.width

    Row {
        id: layout
        spacing: 20

        populate:Transition {
            // Fade in animation
            NumberAnimation {
                property: "opacity";
                from: 0; to: 1.0;
                duration: 400
            }
            // Coming animation
            NumberAnimation {
                property: "scale";
                easing.amplitude: 0.3;
                easing.type: Easing.OutExpo
                from:0; to:1;
                target:layout;
                duration: 600
            }
        }
        // End populate transitions

        // Avatar item
        Item {
            id: itmImage

            height: 60
            width: 70

            // Avatar image
            Image {
                id: imgAvatar
                height: 60
                width: 60
                y: -10
                x: 10

                fillMode: Image.PreserveAspectCrop
                source: avatar

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

            height: rectText.height
            width: rectText.width

            // Sender name
            Text {
                id: txtName
                text: name
                color: "#ea8627"
                font.bold: true
            }

            // Message content
            Text {
                id: txtMessage

                anchors {
                    top: txtName.bottom
                    topMargin: 10
                }
                width: main.width - 200

                wrapMode: Text.Wrap
                text: message
            }

            // Container rectangle
            Rectangle {
                id: rectText

                anchors {
                    top: txtName.top
                    topMargin: -10
                    bottom: txtMessage.bottom
                    bottomMargin: -10
                    right: txtMessage.right
                    rightMargin: -10
                    left: txtName.left
                    leftMargin: -10
                }

                z: -1
                color: "#eee"
                radius: 10
            }
            // End container rectangle

        }
        // End text item

    }
    // End row

}
// End item
