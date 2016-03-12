import QtQuick 2.5
import QtQuick.Controls 1.4

ToolBar {
    Row {
        anchors.fill: parent

        // Start button
        ToolButton {
            text: qsTr("Start")
            tooltip: qsTr("Start Chocal Server")
            iconSource: "qrc:/img/img/toolbar-start.png"

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
            tooltip: qsTr("Stop Chocal Server")
            iconSource: "qrc:/img/img/toolbar-stop.png"

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
            tooltip: qsTr("Shutdown Chocal Server")
            iconSource: "qrc:/img/img/toolbar-shutdown.png"

            onClicked: {
                server.listen = false
                disconnecAllClients()
                Qt.quit()
            }
        }

        // Settings button
        ToolButton {
            text: qsTr("Settings")
            tooltip: qsTr("Server settings")
            iconSource: "qrc:/img/img/toolbar-settings.png"

            onClicked: {
                settingView.state = settingView.state === "show" ? "hide" : "show"
            }
        }

        // About button
        ToolButton {
            text: qsTr("About")
            tooltip: qsTr("About application")
            iconSource: "qrc:/img/img/toolbar-about.png"

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

