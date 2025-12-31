import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item
{
    id: root
    width: 140
    height: 46

    property string deviceName: "Device"
    property string statusText: "OK"
    property bool isAlarm: false
    signal clicked()
    Rectangle
    {
        anchors.fill: bg
        anchors.topMargin: 3
        color: "#30000000"
        radius: 23
        z: -1
    }

    Rectangle
    {
        id: bg
        anchors.fill: parent
        color: "white"
        radius: 23

        border.color: root.isAlarm ? "#FFCDD2" : "#E8F5E9"
        border.width: 1

        RowLayout
        {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 15
            spacing: 8

            Rectangle
            {
                Layout.preferredWidth: 34
                Layout.preferredHeight: 34
                radius: 17

                color: root.isAlarm ? "#FFEBEE" : "#E8F5E9"

                Rectangle
                {
                    width: 10; height: 10
                    radius: 5
                    anchors.centerIn: parent
                    color: root.isAlarm ? "#F44336" : "#4CAF50"
                }
            }

            ColumnLayout
            {
                spacing: -2
                Layout.fillWidth: true

                Text
                {
                    text: root.deviceName
                    font.pixelSize: 10
                    color: "#9E9E9E"
                    font.weight: Font.DemiBold
                }

                Text
                {
                    text: root.statusText
                    font.pixelSize: 13
                    color: root.isAlarm ? "#F44336" : "#4CAF50"
                    font.bold: true
                }
            }
        }
    }

    Rectangle
    {
        width: 10
        height: 10
        color: "white"
        rotation: 45
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -4
        z: 1
    }

    MouseArea
    {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: mainWindow.isHoveringBubble = true
            onExited: mainWindow.isHoveringBubble = false

            onClicked:
            {
                console.log("Bubble clicked: " + root.deviceName)
                root.clicked()
            }
            onPressed: root.scale = 0.95
            onReleased: root.scale = 1.0
        }
}
