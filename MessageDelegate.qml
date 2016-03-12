import QtQuick 2.5
import QtGraphicalEffects 1.0

Item {
    id: itm

    height: itmPlainMessage.height
    width: itmPlainMessage.width

    // Plain message
    Item {
        id: itmPlainMessage

        height: plainLayout.height
        width: plainLayout.width

        visible: type === "plain" || type === "image"

        Row {
            id: plainLayout
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
                    target:plainLayout;
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
                    source: getAvatar(name)

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

                // Image
                Image {
                    id: img
                    fillMode: Image.PreserveAspectFit
                    visible: type === "image"
                    source: type === "image" ? fileio.decodeImage(image) : ""

                    anchors {
                        top: txtName.bottom
                        topMargin: 10
                        right: parent.right
                        rightMargin: 20
                        left: parent.left
                    }
                }

                // Message content
                Text {
                    id: txtMessage

                    anchors {
                        top: img.bottom
                        topMargin: 10
                    }
                    width: messageView.width - 150

                    wrapMode: Text.Wrap
                    onLinkActivated: Qt.openUrlExternally(link)
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
    // End plain message

    // Info message
    Item {
        id: itmInfoMessage

        x: (messageView.width - width) / 2
        height: txtInfo.height
        width: txtInfo.width

        visible: type === "info"

        // NOTE: In this case, row just used for populate transition
        Row {
            id: infoLayout

            anchors {
                fill: parent
            }

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
                    easing.overshoot: 3
                    easing.type: Easing.OutBack
                    from:0; to:1;
                    target: infoLayout;
                    duration: 600
                }
            }
            // End populate transitions

            // Info message content
            Text {
                id: txtInfo

                width: messageView.width - 150

                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                text: message
                color: "#eee"
                font.bold: true

                // Container rectangle
                Rectangle {
                    id: rectInfo

                    anchors {
                        fill: txtInfo
                        margins: -10
                    }

                    z: -1
                    color: "#333"
                    radius: 10
                    opacity: .7
                }
                // End container rectangle

            }
            // End info text

        }
        // End row

    }
    // End info message

}
// End item
