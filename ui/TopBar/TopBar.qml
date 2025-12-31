import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle
{
    id: topBar
    color: "#EEEEEE"
    height: parent.height / 20

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left

    anchors.leftMargin: 60

    property string weatherTemp: "--"
    property string weatherWind: "--"

    function fetchWeatherData()
    {
        var xhr = new XMLHttpRequest();
        var url = "https://api.open-meteo.com/v1/forecast?latitude=49.99&longitude=36.23&current_weather=true";

        xhr.onreadystatechange = function()
        {
            if (xhr.readyState === XMLHttpRequest.DONE)
            {
                if (xhr.status === 200)
                {
                    var response = JSON.parse(xhr.responseText);
                    var temp = response.current_weather.temperature;
                    var wind = response.current_weather.windspeed;

                    weatherTemp = temp > 0 ? "+" + temp : temp; // Добавляем плюсик
                    weatherWind = wind + " km/h";
                }
            }
        }
        xhr.open("GET", url, true);
        xhr.send();
    }

    Timer
    {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: topBar.fetchWeatherData()
    }

    Text
    {
        id: clockDisplay
        text: Qt.formatTime(new Date(), "hh:mm")

        font.pixelSize: 18
        font.bold: true
        color: "#555"
        anchors.right: lockIcon.left
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
    }

    Timer
    {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockDisplay.text = Qt.formatTime(new Date(), "hh:mm")
    }

    Image
    {
        id: lockIcon

        source: (systemHandler.homeLocked ? "../assets/lock.png" : "../assets/unlock.png")

        height: parent.height * 0.6
        fillMode: Image.PreserveAspectFit

        anchors.right: parent.left
        anchors.rightMargin: -200
        anchors.verticalCenter: parent.verticalCenter

        mipmap: true

        MouseArea
        {
            anchors.fill: parent
            onClicked: systemHandler.homeLocked = !systemHandler.homeLocked
        }
    }


    Rectangle
    {
        id: statusLight
        width: 15
        height: 15
        radius: width / 2


        anchors.left: lockIcon.right
        anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter


        color: systemHandler.homeLocked ? "#ff4d4d" : "#00e676"

        border.color: "grey"
        border.width: 1
    }

    RowLayout
    {
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Image
        {
            source: "../assets/weatherbutton.png"
            width: 25
            height: 25
            fillMode: Image.PreserveAspectFit
            mipmap: true
        }

        Column
        {
            spacing: -2
            Text
            {
                text: "Kharkiv: " + topBar.weatherTemp + "°C"
                font.bold: true
                font.pixelSize: 12
                color: "#333"
            }
            Text
            {
                text: "Wind: " + topBar.weatherWind
                font.pixelSize: 10
                color: "#757575"
            }
        }

        MouseArea
        {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked:
            {
                topBar.weatherTemp = ".."
                topBar.fetchWeatherData()
            }
        }
    }
}
