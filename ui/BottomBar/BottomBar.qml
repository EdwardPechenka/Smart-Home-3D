import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Rectangle
{
    id: bottomBar
    height: 100
    color: "white"

    radius: 20
    Rectangle
    {
        height: 20; width: parent.width
        anchors.bottom: parent.bottom; color: "white"
    }

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 60

    Rectangle
    {
        anchors.fill: parent; anchors.topMargin: -5
        z: -1; color: "#10000000"; radius: 20
    }

    RowLayout
    {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 30

        RowLayout
        {
            Layout.preferredWidth: 200
            spacing: 15

            Rectangle
            {
                width: 50; height: 50
                radius: 25

                Image
                {
                    source: "../assets/cc.png"
                    width: 24; height: 24
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    opacity: systemHandler.energyMode ? 1.0 : 0.4
                }
            }

            ColumnLayout
            {
                spacing: 0
                Text {
                    text: "Current Load"
                    font.pixelSize: 12; color: "#909090"; font.weight: Font.DemiBold
                }
                Text {
                    text: systemHandler.currentPower.toFixed(3) + " kW"
                    font.pixelSize: 24; font.bold: true; color: "#212121"
                }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true; Layout.fillHeight: true
            color: "transparent"

            Canvas
            {
                id: graphCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    var gradient = ctx.createLinearGradient(0, 0, width, height);
                    gradient.addColorStop(0, "#402979FF");
                    gradient.addColorStop(1, "#002979FF");
                    var strokeColor = "#2979FF";

                    var max = appSettings.maxLoad > 0 ? appSettings.maxLoad : 1.0;
                    var powerFactor = systemHandler.currentPower / max;

                    if (powerFactor > 1.0) powerFactor = 1.0;
                    var peakY = height - (height * powerFactor);

                    ctx.beginPath();
                    ctx.moveTo(0, height);
                    ctx.lineTo(0, height - 10);
                    ctx.bezierCurveTo(width * 0.3, peakY, width * 0.7, height + 10, width, height - 20);
                    ctx.lineTo(width, height);
                    ctx.closePath();
                    ctx.fillStyle = gradient;
                    ctx.fill();

                    ctx.beginPath();
                    ctx.moveTo(0, height - 10);
                    ctx.bezierCurveTo(width * 0.3, peakY, width * 0.7, height + 10, width, height - 20);
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = strokeColor;
                    ctx.stroke();
                }
                Connections
                {
                    target: systemHandler
                    function onCurrentPowerChanged() { graphCanvas.requestPaint() }
                }

                Connections
                {
                    target: appSettings
                    function onMaxLoadChanged() { graphCanvas.requestPaint() }
                }
            }

            Text
            {
                text: "Real-time Monitoring"
                anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 10; color: "#BDBDBD"
            }
        }

        RowLayout
        {
            Layout.preferredWidth: 250
            spacing: 20

            ColumnLayout
            {
                spacing: 2
                Text { text: "Daily Savings"; color: "#909090"; font.pixelSize: 11 }
                Text {
                    text: "$" + systemHandler.dailySavings.toFixed(2)
                    color: "#4CAF50"; font.bold: true; font.pixelSize: 18
                }
            }

            Rectangle { width: 1; height: 30; color: "#E0E0E0" }

            ColumnLayout
            {
                spacing: 2
                Text { text: "Efficiency"; color: "#909090"; font.pixelSize: 11 }
                Text {
                    text: systemHandler.efficiency + "%"
                    color: systemHandler.efficiency > 80 ? "#4CAF50" : "#FF9800"
                    font.bold: true; font.pixelSize: 18
                }
            }
        }
    }
}
