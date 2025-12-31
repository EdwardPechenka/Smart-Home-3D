import QtQuick 2.15

Rectangle
{
    id: leftSidebar
    width: 60
    height: parent.height

    anchors.left: parent.left
    anchors.top: parent.top
    z: 300

    color: "#EEEEEE"

    signal menuClicked()
    signal listClicked()

    Image
    {
        id: menuBurgerIcon
        source: "../assets/menu-burger.png"

        width: 20
        height: 20

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 45

        mipmap: true
        fillMode: Image.PreserveAspectFit

        MouseArea
        {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked:
            {
                leftSidebar.menuClicked()
            }
        }
    }

    Image
    {
        id: listViewIcon
        source: "../assets/list.png"

        width: 20
        height: 20

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 300

        mipmap: true
        fillMode: Image.PreserveAspectFit

        MouseArea
        {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked:
            {
                leftSidebar.listClicked()
            }
        }
    }
}
