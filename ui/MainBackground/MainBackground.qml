import QtQuick 2.15

Rectangle
{
    id: mainBackground
    anchors.fill: parent

    gradient: Gradient
    {
        GradientStop { position: 0.0; color: "#FFFFFF" }
        GradientStop { position: 1.0; color: "#EFF3F6" }
    }
}
