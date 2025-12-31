#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <Controllers/system.h>
#include <Controllers/settings.h>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Settings* settings = new Settings(&app);
    System* systemHandler = new System(&app);

    QQmlApplicationEngine engine;
    QQmlContext * context(engine.rootContext());
    engine.rootContext()->setContextProperty("systemHandler", systemHandler);
    engine.rootContext()->setContextProperty("appSettings", settings);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("SmartHome", "Main");

    return app.exec();
}
