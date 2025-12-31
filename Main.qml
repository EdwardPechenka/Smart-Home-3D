import QtQuick
import QtQuick.Window
import QtQuick3D
import QtQuick3D.AssetUtils
import QtQuick3D.Helpers
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.LocalStorage 2.0
import "ui/Database/Database.js" as DB
import "ui/BottomBar"
import "ui/MainBackground"
import "ui/LeftScreen"
import "ui/TopBar"
import "ui/SecurityBubble"
import "ui/Energy"
import "ui/NotificationToast"

Window
{
    id: mainWindow
    width: 1280
    height: 720
    visible: true
    title: qsTr("Smart Home")

    property bool isHoveringBubble: false

    function getDevicePowerLabel(type)
    {
        var val = 0.0;
        switch(type)
        {
            case "pc": val = appSettings.loadPc; break;
            case "tv": val = appSettings.loadTv; break;
            case "fridge": val = appSettings.loadFridge; break;
            case "kettle": val = appSettings.loadKettle; break;
            case "microwave": val = appSettings.loadMicrowave; break;
            default: return "";
        }

        if (val < 1.0) return (val * 1000).toFixed(0) + " W";
        else return val.toFixed(1) + " kW";
    }

    MainBackground { id: mainBackground }

    Component.onCompleted:
    {
        DB.initDatabase();
        DB.readHistory(historyModel);
    }
    ListModel { id: historyModel }

    Connections
    {
        target: systemHandler
        function onLightRoomChanged(val) { logToDB("Living Room Light", val ? "ON" : "OFF"); notification.show("Living Room Light", val ? "On" : "Off", val)}
        function onTvOnChanged(val) { logToDB("Smart TV", val ? "ON" : "OFF"); notification.show("Smart TV", val ? "On" : "Off", val)}
        function onClimateOnChanged(val) { logToDB("Climate Control", val ? "ON" : "OFF"); notification.show("Climate Control", val ? "System Started" : "System Stopped", false) }
        function onTargetTempChanged(val) { if (systemHandler.climateOn) notification.show("Climate Settings", "Target Temp: " + val + "°C", false) }
        function onFridgeOnChanged(val) { logToDB("Fridge", val ? "ON" : "OFF"); notification.show("Fridge", val ? "On" : "Off", val)}
        function onHomeLockedChanged(val) { logToDB("Front Door", val ? "LOCKED" : "UNLOCKED"); notification.show("Door locker", val ? "House Locked" : "House Unlocked", val)}

        function onHubOnlineChanged(val)
        {
            logToDB("Ajax Hub", val ? "ONLINE" : "OFFLINE")
            notification.show("Network", val ? "Hub Connection Restored" : "Hub Connection LOST!", !val)
            if (!val)
            {
                if (!systemHandler.homeLocked) systemHandler.setHomeLocked(true)
                if (systemHandler.motionDetected) systemHandler.setMotionDetected(false)
                if (systemHandler.frontdoorinicator) systemHandler.setFrontdoorinicator(false)
            }
        }
        function onMotionDetectedChanged(val) { if(val) logToDB("Entrance", "MOTION DETECTED!"); notification.show("Motion Detector", val ? "Entrance" : "MOTION DETECTED!", val)}
        function onFrontdoorinicatorChanged(val) { logToDB("Door Sensor", val ? "OPENED" : "CLOSED"); notification.show("Front door locker", val ? "House Locked" : "House Unlocked", val)}
        function onKettleChanged(val) { logToDB("Kettle", val ? "ON" : "OFF"); notification.show("Kettle", val ? "Kettle Boiling" : "Kettle Off", false) }
        function onMicroVaveChanged(val) { logToDB("Microwave", val ? "ON" : "OFF"); notification.show("Microwave", val ? "Running" : "Finished", false) }
        function onRobotVacuumChanged(val) { logToDB("Robot Vacuum", val ? "ON" : "OFF"); notification.show("Robot Vacuum", val ? "Running" : "Finished", false) }
        function onWashingMachineChanged(val) { logToDB("Washing Machine", val ? "ON" : "OFF"); notification.show("Laundry", val ? "Running" : "Finished", false) }
        function onBoiLerChanged(val) { logToDB("Boiler", val ? "ON" : "OFF"); notification.show("Boiler", val ? "Heating" : "Standby", false) }
        function onPcChanged(val) { logToDB("PC", val ? "ON" : "OFF"); notification.show("PC", val ? "PC Started" : "PC Turned off", false) }
        function onWifiOnChanged(val)
        {
            logToDB("Wi-Fi Router", val ? "Online" : "Offline");
            notification.show("Network Status", val ? "Wi-Fi Signal Restored" : "Wi-Fi Signal LOST", !val)
        }
        function logToDB(dev, st) { DB.addEvent(dev, st); DB.readHistory(historyModel); }
    }

    StackLayout
    {
        id: mainStack
        anchors.fill: parent
        anchors.leftMargin: 60
        currentIndex: 0

        Item
        {
            id: homeView
            View3D {
                id: view3D
                anchors.fill: parent

                PerspectiveCamera {
                    id: camera
                    position: Qt.vector3d(0, 200, 300)
                    Component.onCompleted: lookAt(Qt.vector3d(0, 0, 0))
                }

                DirectionalLight {
                    eulerRotation.x: -30
                    eulerRotation.y: -30
                }

                RuntimeLoader {
                    id: houseModel
                    source: "qrc:/ui/assets/home.glb"
                    scale: Qt.vector3d(20, 20, 20)
                    position: Qt.vector3d(20, 0, 0)
                }

                OrbitCameraController {
                    anchors.fill: parent
                    camera: camera
                    origin: houseModel
                    xSpeed: 1.0
                    ySpeed: 0.0
                    enabled: !mainWindow.isHoveringBubble
                }
            }

            ListModel
            {
                id: allDevices
                ListElement { group: 0; name: "Wi-Fi Router"; type: "wifi";    px: -50;  py: 20; pz: 50 }
                ListElement { group: 0; name: "Ajax Hub";     type: "hub";     px: 85;  py: 40; pz: 50 }
                ListElement { group: 0; name: "Front Door";   type: "lock";    px: -90;  py: 50; pz: 0 }
                ListElement { group: 0; name: "Door Sensor";  type: "contact"; px: -59; py: 1; pz: -73 }
                ListElement { group: 0; name: "Entr. Motion"; type: "motion";  px: -120; py: 60; pz: -20 }

                ListElement { group: 1; name: "Living Light"; type: "light";   px: 20;   py: 45; pz: 50 }
                ListElement { group: 1; name: "Boiler";       type: "boiler";  px: -220; py: 1; pz: 12 }
                ListElement { group: 1; name: "Washer";       type: "washer";  px: -130; py: 1; pz: -5 }

                ListElement { group: 2; name: "PC";              type: "pc";        px: -50; py: 1; pz: 90 }
                ListElement { group: 2; name: "Smart TV";        type: "tv";        px: 80; py: 1; pz: 90 }
                ListElement { group: 2; name: "Climate Control"; type: "climate";   px: -130; py: 1; pz: 43 }
                ListElement { group: 2; name: "Fridge";          type: "fridge";    px: 30; py: 1; pz: -50 }
                ListElement { group: 2; name: "Kettle";          type: "kettle";    px: -23; py: 1; pz: -44 }
                ListElement { group: 2; name: "Microwave";       type: "microwave"; px: -37; py: 1; pz: -8 }
                ListElement { group: 2; name: "Robot Vacuum";    type: "vacuum";    px: 80; py: 1; pz: 6 }
            }

            Repeater
            {
                model: allDevices
                delegate:
                Item
                {
                    id: wrapper
                    width: bubble.width
                    height: bubble.height + 40
                    visible: false

                    Rectangle
                    {
                        id: stick
                        width: 2
                        height: 40
                        color: "#808080"
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        opacity: 0.7
                    }

                    Rectangle
                    {
                        width: 6;
                        height: 6;
                        radius: 3;
                        color: "#808080"
                        anchors.horizontalCenter: stick.horizontalCenter
                        anchors.verticalCenter: stick.bottom
                    }

                    SecurityBubble
                    {
                        id: bubble
                        anchors.bottom: stick.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        deviceName: model.name

                        statusText:
                        {
                            if (!systemHandler.wifiOn && model.type !== "wifi") return "Offline";

                            if (model.group === 0 && model.type !== "hub" && model.type !== "wifi")
                            {
                                if (!systemHandler.hubOnline) return "No Signal";
                            }

                            switch(model.type)
                            {
                                case "wifi": return systemHandler.wifiOn ? "Online" : "Offline";
                                case "hub": return systemHandler.hubOnline ? "Online" : "Offline";
                                case "lock": return systemHandler.homeLocked ? "Locked" : "Open";
                                case "motion": return systemHandler.motionDetected ? "Motion!" : "Secure";
                                case "contact": return systemHandler.frontdoorinicator ? "Opened" : "Closed";
                                case "light": return systemHandler.lightRoom ? "On" : "Off";
                                case "boiler": return systemHandler.boiLer ? "Heating" : "Eco";
                                case "washer": return systemHandler.washingMachine ? "Running" : "Ready";
                                case "pc": return systemHandler.pc ? getDevicePowerLabel("pc") : "Sleep";
                                case "tv": return systemHandler.tvOn ? getDevicePowerLabel("tv") : "OFF";
                                case "climate": return !systemHandler.climateOn ? "Off ("+systemHandler.roomTemp+"°C)" : "Set: "+systemHandler.targetTemp+"°C";
                                case "fridge": return systemHandler.fridgeOn ? getDevicePowerLabel("fridge") : "OFF";
                                case "kettle": return systemHandler.kettle ? getDevicePowerLabel("kettle") : "OFF";
                                case "microwave": return systemHandler.microVave ? getDevicePowerLabel("microwave") : "OFF";
                                case "vacuum": return systemHandler.robotVacuum ? getDevicePowerLabel("vacuum") : "OFF";
                            }
                                return "";
                        }

                        isAlarm:
                        {
                            if (!systemHandler.wifiOn && model.type !== "wifi") return false;
                            if (model.group === 0 && model.type !== "hub" && model.type !== "wifi" && !systemHandler.hubOnline) return false;
                            switch(model.type)
                            {
                                case "wifi": return !systemHandler.wifiOn;
                                case "hub": return !systemHandler.hubOnline;
                                case "lock": return systemHandler.homeLocked;
                                case "motion": return systemHandler.motionDetected;
                                case "contact": return systemHandler.frontdoorinicator;
                                case "pc": return !systemHandler.pc;
                                case "tv": return !systemHandler.tvOn;
                                case "climate": return !systemHandler.climateOn;
                            }
                                return false;
                        }

                        onClicked:
                        {

                            if(model.type === "wifi")
                            {
                                systemHandler.setWifiOn(!systemHandler.wifiOn);
                            }

                            else if(systemHandler.wifiOn)
                            {
                                if(model.type === "hub")
                                {
                                    systemHandler.setHubOnline(!systemHandler.hubOnline);
                                }

                                else if (model.group === 0)
                                {
                                    if (systemHandler.hubOnline)
                                    {
                                        if(model.type==="lock") systemHandler.setHomeLocked(!systemHandler.homeLocked);
                                        else if(model.type==="motion") systemHandler.setMotionDetected(!systemHandler.motionDetected);
                                        else if(model.type==="contact") systemHandler.setFrontdoorinicator(!systemHandler.frontdoorinicator);
                                    }
                                    else
                                    {
                                        notification.show("Error", "Ajax Hub Offline", true);
                                    }
                                }

                                else
                                {
                                    if(model.type==="light") systemHandler.setLightRoom(!systemHandler.lightRoom);
                                    else if(model.type==="boiler") systemHandler.setBoiLer(!systemHandler.boiLer);
                                    else if(model.type==="washer") systemHandler.setWashingMachine(!systemHandler.washingMachine);
                                    else if(model.type==="pc") systemHandler.setPc(!systemHandler.pc);
                                    else if(model.type==="tv") systemHandler.setTvOn(!systemHandler.tvOn);
                                    else if(model.type==="climate") systemHandler.setClimateOn(!systemHandler.climateOn);
                                    else if(model.type==="fridge") systemHandler.setFridgeOn(!systemHandler.fridgeOn);
                                    else if(model.type==="kettle") systemHandler.setKettle(!systemHandler.kettle);
                                    else if(model.type==="microwave") systemHandler.setMicroVave(!systemHandler.microVave);
                                    else if(model.type==="vacuum") systemHandler.setRobotVacuum(!systemHandler.robotVacuum);
                                }
                            }
                            else
                            {
                                notification.show("Error", "No Wi-Fi Connection", true);
                            }
                        }
                    }

                    FrameAnimation
                    {
                        running: true
                        onTriggered:
                        {
                            if (!camera || !view3D || view3D.width === 0) return;
                            var houseScale = houseModel.scale.x;
                            var localPos = Qt.vector3d(
                            model.px / houseScale,
                            model.py / houseScale,
                            model.pz / houseScale
                            );
                            var worldPos = houseModel.mapPositionToScene(localPos);
                            var p = camera.mapToViewport(worldPos);
                            var isVisibleInCamera = (p.z > 0);
                            var isCorrectTab = (systemHandler.currentMode === model.group);
                            wrapper.visible = isVisibleInCamera && isCorrectTab;
                            if (wrapper.visible)
                            {
                                wrapper.x = (p.x * view3D.width) - (wrapper.width / 2);
                                wrapper.y = (p.y * view3D.height) - wrapper.height;
                                wrapper.z = 100000 - p.z;
                            }
                        }
                    }
                }
            }
        }

        Item
        {
            id: scenariOS
            property string activeScenario: "none"
            Rectangle { anchors.fill: parent; color: "#F0F2F5" }

            ColumnLayout
            {
                anchors.centerIn: parent
                spacing: 30

                Text
                {
                    text: "The weather scenarios"
                    font.pixelSize: 24; font.bold: true; color: "#333"
                }

                RowLayout
                {
                    spacing: 20
                    Rectangle
                    {
                        width: 200; height: 160
                        radius: 15
                        color: scenariOS.activeScenario === "morning" ? "#FFF3E0" : "#FAFAFA"
                        border.color: scenariOS.activeScenario === "morning" ? "#EF6C00" : "#E0E0E0"
                        border.width: scenariOS.activeScenario === "morning" ? 3 : 1
                        Column
                        {
                            anchors.centerIn: parent
                            spacing: 5
                            AnimatedImage
                            {
                            source: "ui/assets/morning.gif"
                            width: 50; height: 50
                            anchors.horizontalCenter: parent.horizontalCenter
                            fillMode: Image.PreserveAspectFit
                            playing: true
                            }
                            Text
                            {
                                text: "Day Mode"
                                font.bold: true; font.pixelSize: 18
                                color: "#EF6C00"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text
                            {
                                text: scenariOS.activeScenario === "morning" ? "ACTIVE" : "Ready"
                                font.bold: true
                                font.pixelSize: 14
                                color: scenariOS.activeScenario === "morning" ? "#4CAF50" : "#9E9E9E"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked: {
                                systemHandler.scenario = "morning";
                                notification.show("Scenario", "Morning Mode Activated", false)
                            }
                        }
                    }

                        Rectangle
                        {
                            width: 200; height: 160
                            radius: 15
                            color: scenariOS.activeScenario === "evening" ? "#E8EAF6" : "#FAFAFA"
                            border.color: scenariOS.activeScenario === "evening" ? "#283593" : "#E0E0E0"
                            border.width: scenariOS.activeScenario === "evening" ? 3 : 1

                            Column
                            {
                                anchors.centerIn: parent
                                spacing: 5

                                AnimatedImage
                                {
                                    source: "ui/assets/goodnight.gif"
                                    width: 50;
                                    height: 50
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    fillMode: Image.PreserveAspectFit
                                    playing: true
                                }

                                Text
                                {
                                    text: "Night Mode"
                                    font.bold: true; font.pixelSize: 18
                                    color: "#283593"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text
                                {
                                    text: scenariOS.activeScenario === "evening" ? "ACTIVE" : "Ready"
                                    font.bold: true
                                    font.pixelSize: 14
                                    color: scenariOS.activeScenario === "evening" ? "#4CAF50" : "#9E9E9E"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        systemHandler.scenario = "evening";
                                        notification.show("Scenario", "Evening Mode Activated", false)
                                    }
                                }
                            }
                        }
                    }
                }

        Item
        {
            id: historyView
            Rectangle { anchors.fill: parent; color: "white" }
            ColumnLayout
            {
                anchors.fill: parent; anchors.margins: 30
                RowLayout
                {
                    Layout.fillWidth: true;
                    Text{text:"Action History";font.pixelSize:22;font.bold:true;color:"#333"}
                    Item{Layout.fillWidth:true}

                    Rectangle
                    {
                        width: 90
                        height: 36
                        radius: 18

                        color: cleanMouse.containsMouse ? "#EEEEEE" : "transparent"
                        Row
                        {
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                text: "Clean"
                                color: "#616161"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea
                        {
                            id: cleanMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked:
                            {
                                DB.clearHistory(historyModel)
                            }
                        }
                    }

                }
                ListView
                {
                    Layout.fillWidth: true; Layout.fillHeight: true; clip: true; model: historyModel
                    delegate: Rectangle
                    {
                        width: parent.width;
                        height: 60
                        color: "transparent"

                        Rectangle
                        {
                            height: 1
                            color: "#eee"
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                        }

                            RowLayout
                            {
                                anchors.fill: parent; anchors.margins: 10
                                Text { text: model.time; color: "gray"; font.pixelSize: 14 }
                                Text { text: model.device; font.bold: true; font.pixelSize: 16; Layout.fillWidth: true }
                                Text { text: model.state; color: model.state.includes("ON")?"green":"red"; font.bold: true }
                            }
                    }

                }
            }
        }
    }

    LeftScreen
    {
        id: sideBar
        onMenuClicked: mainDrawer.open()
        onListClicked: { mainStack.currentIndex = 2; mainDrawer.close() }
    }

    Drawer {
            id: mainDrawer
            width: 300
            height: parent.height
            edge: Qt.LeftEdge
            interactive: true
            z: 200
            background: Rectangle { color: "#FFFFFF" }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 140
                    color: "#e9e9e9"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 15

                        Rectangle {
                            width: 60
                            height: 60
                            radius: 30
                            color: "white"
                            clip: true

                            Image {
                                anchors.fill: parent
                                anchors.margins: 5
                                source: "ui/assets/users.png"
                                fillMode: Image.PreserveAspectCrop
                                mipmap: true
                            }
                        }

                        ColumnLayout {
                            spacing: 0
                            TextField {
                                text: "Admin User"
                                font.bold: true
                                font.pixelSize: 18
                                color: "black"
                                background: null
                                padding: 0
                                selectByMouse: true
                                onEditingFinished: console.log("New Name:", text)
                            }
                            TextField {
                                text: "Kharkiv"
                                font.pixelSize: 14
                                color: "#555"
                                background: null
                                padding: 0
                                selectByMouse: true
                                onEditingFinished: console.log("New City:", text)
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true; Layout.preferredHeight: 20 }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 55
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        spacing: 20

                        Image {
                            id: homeButton
                            source: "ui/assets/gohome.png"
                            width: 5; height: 5

                        }
                        Text { text: "Home Page"; color: "black"; font.pixelSize: 16 }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: { mainStack.currentIndex = 0; mainDrawer.close() }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 55
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        spacing: 20

                        Image {
                            source: "ui/assets/cloud.png"
                            width: 10; height: 10
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                        }
                        Text { text: "Weather Scenarios"; color: "black"; font.pixelSize: 16 }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: { mainStack.currentIndex = 1; mainDrawer.close() }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 55
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        spacing: 20
                        Image {
                            source: "ui/assets/historybutton.png"
                            width: 10; height: 10
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                        }
                        Text { text: "History"; color: "black"; font.pixelSize: 16 }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: { mainStack.currentIndex = 2; mainDrawer.close() }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

    Rectangle
    {
        id: modeSwitcher
        width: 360;
        height: 44;
        radius: 22;
        color: "white";
        z: 100;

        visible: mainStack.currentIndex === 0
        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.topMargin: 20;
        border.color: "#E0E0E0";
        border.width: 1
        RowLayout
        {
            anchors.fill: parent;
            anchors.margins: 4;
            spacing: 4
            Rectangle
            {
                Layout.fillWidth: true;
                Layout.fillHeight: true;
                radius: 20;
                color: systemHandler.currentMode === 0 ? "#E8F5E9" : "transparent";
                Text
                {
                    anchors.centerIn: parent;
                    text: "Security";
                    color: systemHandler.currentMode === 0 ? "#2E7D32" : "#757575";
                    font.weight: Font.Bold
                }
                MouseArea
                {
                    anchors.fill: parent;
                    onClicked: systemHandler.setCurrentMode(0)
                }
            }
            Rectangle
            {
                Layout.fillWidth: true;
                Layout.fillHeight: true;
                radius: 20;
                color: systemHandler.currentMode === 1 ? "#E3F2FD" : "transparent";
                Text
                {
                    anchors.centerIn: parent;
                    text: "Energy";
                    color: systemHandler.currentMode === 1 ? "#1565C0" : "#757575";
                    font.weight: Font.Bold
                }
                MouseArea
                {
                    anchors.fill: parent;
                    onClicked: systemHandler.setCurrentMode(1)
                }
            }
            Rectangle
            {
                Layout.fillWidth: true;
                Layout.fillHeight: true;
                radius: 20; color: systemHandler.currentMode === 2 ? "#FFF3E0" : "transparent";
                Text
                {
                    anchors.centerIn: parent;
                    text: "Devices";
                    color: systemHandler.currentMode === 2 ? "#E65100" : "#757575";
                    font.weight: Font.Bold
                }
                MouseArea
                {
                    anchors.fill: parent;
                    onClicked: systemHandler.setCurrentMode(2)
                }
            }
        }
    }

    NotificationToast { id: notification; anchors.horizontalCenter: parent.horizontalCenter }
    TopBar { id: topBar; visible: mainStack.currentIndex === 0 }
    BottomBar { id: bottomBar; visible: mainStack.currentIndex === 0 }
}





