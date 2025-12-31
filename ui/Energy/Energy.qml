import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item
{
    id: root
    width: 150
    height: 55

    property string deviceName: "Device"
    property string usage: "0 kWh"
    property string cost: "$0.00"

    Rectangle
    {
        anchors.fill: bg; anchors.topMargin: 3
        color: "#30000000"; radius: 12; z: -1
    }

    Rectangle
    {
        id: bg
        anchors.fill: parent
        color: "white"
        radius: 12
        border.color: "#E0E0E0"
        border.width: 1

        RowLayout
        {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            ColumnLayout
            {
                spacing: 0
                Text
                {
                    text: root.deviceName
                    font.pixelSize: 10; color: "#909090"; font.weight: Font.DemiBold
                }
                Text
                {
                    text: root.usage
                    font.pixelSize: 13; color: "#1976D2"; font.bold: true // Синий цвет
                }
            }
        }

        Rectangle
        {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 4
            width: 40; height: 16
            radius: 8
            color: "#E8F5E9"
            Text {
                anchors.centerIn: parent
                text: root.cost
                font.pixelSize: 9
                color: "#2E7D32"
                font.bold: true
            }
        }
    }

    Rectangle
    {
        width: 10; height: 10
        color: "white"
        rotation: 45
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom; anchors.bottomMargin: -4
        z: 1
    }
}
