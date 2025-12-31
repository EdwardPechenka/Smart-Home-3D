import QtQuick 2.15

Rectangle
{
    id: indicatorFrontDoor
    width: 110
    height: 40
    radius: 20
    color: "white"

    property bool isLocked: true
    property string text: isLocked ? "Closed" : "Open"

    layer.enabled: true
    border.color: "#E0E0E0"
    border.width: 1

    Row
    {
        anchors.centerIn: parent
        spacing: 5

        Image
        {
            width: 20
            height: 20
            source: indicatorFrontDoor.isLocked ? "../assets/lock.png" : "../assets/unlock.png"
            fillMode: Image.PreserveAspectFit
        }

        Text
        {
            text: indicatorFrontDoor.text
            color: indicatorFrontDoor.isLocked ? "red" : "green"
            font.bold: true
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
