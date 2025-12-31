#include "settings.h"

Settings* Settings::m_instance = nullptr;

Settings::Settings(QObject *parent)
    : QObject(parent)
    , m_maxLoad(5.0)
{
    m_instance = this;
}

Settings *Settings::instance()
{
    if (!m_instance) {
        m_instance = new Settings();
    }
    return m_instance;
}

double Settings::baseLoad() const { return 0.300; }
double Settings::loadHub() const { return 0.020; }
double Settings::loadLock() const { return 0.010; }
double Settings::loadSensor() const { return 0.002; }
double Settings::loadLightBulb() const { return 0.015; }
double Settings::loadTv() const { return 0.120; }
double Settings::loadClimateBase() const { return 0.500; }
double Settings::loadClimatePerDegree() const { return 0.150; }
double Settings::loadFridge() const { return 0.150; }
double Settings::loadKettle() const { return 2.000; }
double Settings::loadMicrowave() const { return 0.800; }
double Settings::loadWashingMachine() const { return 1.700; }
double Settings::loadBoiler() const { return 2.000; }
double Settings::loadPc() const { return 0.450; }
double Settings::loadRouter() const { return 0.015; }
double Settings::costPerKwh() const { return 0.10; }
double Settings::loadRobotVacuum() const { return 0.050; }

double Settings::maxLoad() const
{
    return m_maxLoad;
}

void Settings::setMaxLoad(double val)
{
    if (m_maxLoad == val) return;
    m_maxLoad = val;
    emit maxLoadChanged();
}
