import QtQuick 2.5
import QtQuick.Layouts 1.2

Item {
    id: itm

    height: layout.height
    width: layout.width

    Row {
        id: layout
        spacing: 40

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

        // Avatar image
        Item {
            id: itmImage

            height: 40
            width: 40
            // TODO : Place avatar image here
            Text {
                text: "IMG"
            }

        }
        // End avatar image

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
                    topMargin: -20
                    bottom: txtMessage.bottom
                    bottomMargin: -20
                    right: txtMessage.right
                    rightMargin: -20
                    left: txtName.left
                    leftMargin: -20
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
