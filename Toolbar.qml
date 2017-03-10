import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

ToolBar {
    Material.primary: "white"
    Row {
        anchors.fill: parent

        // Start button
        ToolButton {
            text: qsTr("Start")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Start Chocal Server")
            contentItem: Image {
                source: "qrc:/img/img/toolbar-start.png"
            }


            onClicked: {
                var host = settings.getString("ip")
                var port = settings.getInt("port")

                if(host.trim() === "") {
                    appendInfoMessage(qsTr("IP address is invalid"))
                    return
                }

                if(port === "" || port <= 0 || port >= 65534) {
                    appendInfoMessage(qsTr("Port number must be in range of 1 and 65534"))
                    return
                }

                server.host = host
                server.port = port
                server.listen = true
                appendInfoMessage(qsTr("Chocal Server started on %1").arg(server.url))
            }
        }

        // Stop button
        ToolButton {
            text: qsTr("Stop")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Stop Chocal Server")
            contentItem: Image {
                source: "qrc:/img/img/toolbar-stop.png"
            }

            onClicked: {
                sendInfoMessage(qsTr("Server stoped by admin"))
                server.listen = false
                disconnecAllClients()
                appendInfoMessage(qsTr("Listening stoped, all connections are closed and Chocal Server is now stoped."))
            }
        }

        // Shutdown button
        ToolButton {
            text: qsTr("Shutdown")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Shutdown Chocal Server")
            contentItem: Image {
                source: "qrc:/img/img/toolbar-shutdown.png"
            }

            onClicked: {
                server.listen = false
                disconnecAllClients()
                Qt.quit()
            }
        }

        // Expand/Collapse button
        ToolButton {
            text: header.state === "show" ? qsTr("Collapse") : qsTr("Expand")
            ToolTip.visible: hovered
            ToolTip.text: header.state === "show" ? qsTr("Collapse header bar") : qsTr("Expand header bar")
            contentItem: Image {
                source: "qrc:/img/img/toolbar-collapse-expand.png"
            }


            onClicked: {
                header.state = header.state === "show" ? "hide" : "show"
            }
        }

        // Settings button
        ToolButton {
            text: qsTr("Settings")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Server settings")
            contentItem: Image {
                source: "qrc:/img/img/toolbar-settings.png"
            }

            onClicked: {
                settingView.state = settingView.state === "show" ? "hide" : "show"
            }
        }

        // About button
        ToolButton {
            text: qsTr("About")
            ToolTip.visible: hovered
            ToolTip.text: qsTr("About application")
            contentItem: Image {
                source: "qrc:/img/img/toolbar-about.png"
            }

            onClicked: {
                if(about.state === "show") {
                    flipable.flipped = true
                    about.state = "hide"
                } else {
                    flipable.flipped = false
                    about.state = "show"
                }
            }
        }

    }
    // End toolbar row
}

