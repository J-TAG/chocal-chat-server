import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    id: itm
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "purple"

        Image {
            id: logo
            anchors.centerIn: parent
            width: 512
            height: 512
            source: "qrc:/img/img/chocal-logo-512.png"
        }

    }
}

