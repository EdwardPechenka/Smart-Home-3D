import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle
{
    id: root
    property string titleText: "System"
    property string messageText: "Event occurred"
    property bool isWarning: false

    width: 350
    height: 60
    radius: 30
    color: "white"

    y: -100
    opacity: 0
    z: 1000

    layer.enabled: true

    Behavior on y { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
    Behavior on opacity { NumberAnimation { duration: 300 } }

    border.width: 2
    border.color: isWarning ? "#FF5252" : "#2196F3"

    RowLayout
    {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        Rectangle
        {
            width: 36; height: 36; radius: 18
            color: root.isWarning ? "#FFEBEE" : "#E3F2FD"

            Image
            {
                anchors.centerIn: parent
                width: 24
                height: 24
                source: root.isWarning ? "../assets/warning.png" : "../assets/information.png"
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
        }

        ColumnLayout
        {
            Layout.fillWidth: true
            spacing: 0

            Text
            {
                text: root.titleText
                font.bold: true
                font.pixelSize: 14
                color: "#333"
            }
            Text
            {
                text: root.messageText
                font.pixelSize: 12
                color: "#666"
                elide: Text.ElideRight
            }
        }
    }

    Timer
    {
        id: hideTimer
        interval: 3000
        onTriggered:
        {
            root.y = -100
            root.opacity = 0
        }
    }

    function show(title, msg, warning)
    {
        titleText = title
        messageText = msg
        isWarning = warning
        root.opacity = 1
        root.y = 30
        hideTimer.restart()
    }
}
