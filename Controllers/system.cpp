#include "system.h"
#include "settings.h"
#include <QDebug>
#include <cmath>

System::System(QObject *parent)
    : QObject(parent)
    , m_homeLocked(true)
    , m_motionDetected(false)
    , m_frontdoorinicator(false)
    , m_hubOnline(true)
    , m_currentMode(0)
    , m_currentPower(0)
    , m_dailySavings(0)
    , m_efficiency(0)
    , m_lightRoom(false)
    , m_tvOn(false)
    , m_fridgeOn(true)
    , m_kettle(false)
    , m_microVave(false)
    , m_washingMachine(false)
    , m_boiLer(true)
    , m_pc(false)
    , m_wifiOn(true)
    , m_climateOn(false)
    , m_roomTemp(24)
    , m_targetTemp(21)
    , m_scenario("none")
    , m_robotVacuum(false)
{
    if (!Settings::instance()) new Settings(this);
    recalculateEnergy();
}

void System::recalculateEnergy()
{
    Settings* s = Settings::instance();

    double totalLoad = s->baseLoad();

    if (m_hubOnline) totalLoad += s->loadHub();
    if (m_homeLocked) totalLoad += s->loadLock();
    if (m_frontdoorinicator) totalLoad += s->loadSensor();
    if (m_motionDetected) totalLoad += s->loadSensor();
    if (m_lightRoom) totalLoad += s->loadLightBulb();
    if (m_tvOn) totalLoad += s->loadTv();

    if (m_climateOn) {
        int diff = std::abs(m_roomTemp - m_targetTemp);
        totalLoad += s->loadClimateBase() + (diff * s->loadClimatePerDegree());
    }

    if (m_fridgeOn) totalLoad += s->loadFridge();
    if (m_kettle) totalLoad += s->loadKettle();
    if (m_microVave) totalLoad += s->loadMicrowave();
    if (m_washingMachine) totalLoad += s->loadWashingMachine();
    if (m_boiLer) totalLoad += s->loadBoiler();
    if (m_pc) totalLoad += s->loadPc();
    if (m_wifiOn) totalLoad += s->loadRouter();


    if (totalLoad > s->maxLoad()) {
        s->setMaxLoad(totalLoad * 1.2);
    }

    if (m_robotVacuum) totalLoad += s->loadRobotVacuum();

    m_currentPower = totalLoad;

    m_efficiency = 100 - (int)((m_currentPower / s->maxLoad()) * 100);
    if (m_efficiency < 0) m_efficiency = 0;

    double maxCost = s->maxLoad() * s->costPerKwh() * 24;
    double currentCost = m_currentPower * s->costPerKwh() * 24;
    m_dailySavings = maxCost - currentCost;

    emit powerStatsChanged();
}

bool System::homeLocked() const { return m_homeLocked; }
bool System::motionDetected() const { return m_motionDetected; }
bool System::frontdoorinicator() const { return m_frontdoorinicator; }
bool System::hubOnline() const { return m_hubOnline; }
int System::currentMode() const { return m_currentMode; }
bool System::lightRoom() const { return m_lightRoom; }
double System::currentPower() const { return m_currentPower; }
double System::dailySavings() const { return m_dailySavings; }
int System::efficiency() const { return m_efficiency; }
bool System::tvOn() const { return m_tvOn; }
bool System::fridgeOn() const { return m_fridgeOn; }
bool System::kettle() const { return m_kettle; }
bool System::microVave() const { return m_microVave; }
bool System::washingMachine() const { return m_washingMachine; }
bool System::boiLer() const { return m_boiLer; }
bool System::pc() const { return m_pc; }
bool System::wifiOn() const { return m_wifiOn; }
bool System::climateOn() const { return m_climateOn; }
int System::roomTemp() const { return m_roomTemp; }
int System::targetTemp() const { return m_targetTemp; }
bool System::robotVacuum() const { return m_robotVacuum; }
QString System::scenario() const { return m_scenario; }

void System::setHomeLocked(bool newHomeLocked) {
    if (m_homeLocked == newHomeLocked) return;
    m_homeLocked = newHomeLocked;
    emit homeLockedChanged(m_homeLocked);
    recalculateEnergy();
}

void System::setMotionDetected(bool newMotionDetected) {
    if (m_motionDetected == newMotionDetected) return;
    m_motionDetected = newMotionDetected;
    emit motionDetectedChanged(m_motionDetected);
    recalculateEnergy();
}

void System::setFrontdoorinicator(bool newFrontdoorinicator) {
    if (m_frontdoorinicator == newFrontdoorinicator) return;
    m_frontdoorinicator = newFrontdoorinicator;
    emit frontdoorinicatorChanged(m_frontdoorinicator);
    recalculateEnergy();
}

void System::setHubOnline(bool newHubOnline) {
    if (m_hubOnline == newHubOnline) return;
    m_hubOnline = newHubOnline;
    emit hubOnlineChanged(m_hubOnline);
    recalculateEnergy();
}

void System::setCurrentMode(int newCurrentMode) {
    if (m_currentMode == newCurrentMode) return;
    m_currentMode = newCurrentMode;
    emit currentModeChanged(m_currentMode);
}

void System::setLightRoom(bool newLightRoom) {
    if (m_lightRoom == newLightRoom) return;
    m_lightRoom = newLightRoom;
    emit lightRoomChanged(m_lightRoom);
    recalculateEnergy();
}

void System::setTvOn(bool newTvOn) {
    if (m_tvOn == newTvOn) return;
    m_tvOn = newTvOn;
    emit tvOnChanged(m_tvOn);
    recalculateEnergy();
}

void System::setFridgeOn(bool newFridgeOn) {
    if (m_fridgeOn == newFridgeOn) return;
    m_fridgeOn = newFridgeOn;
    emit fridgeOnChanged(m_fridgeOn);
    recalculateEnergy();
}

void System::setKettle(bool newKettle) {
    if (m_kettle == newKettle) return;
    m_kettle = newKettle;
    emit kettleChanged(m_kettle);
    recalculateEnergy();
}

void System::setMicroVave(bool newMicroVave) {
    if (m_microVave == newMicroVave) return;
    m_microVave = newMicroVave;
    emit microVaveChanged(m_microVave);
    recalculateEnergy();
}

void System::setWashingMachine(bool newWashingMachine) {
    if (m_washingMachine == newWashingMachine) return;
    m_washingMachine = newWashingMachine;
    emit washingMachineChanged(m_washingMachine);
    recalculateEnergy();
}

void System::setBoiLer(bool newBoiLer) {
    if (m_boiLer == newBoiLer) return;
    m_boiLer = newBoiLer;
    emit boiLerChanged(m_boiLer);
    recalculateEnergy();
}

void System::setPc(bool newPc) {
    if (m_pc == newPc) return;
    m_pc = newPc;
    emit pcChanged(m_pc);
    recalculateEnergy();
}

void System::setWifiOn(bool newWifiOn) {
    if (m_wifiOn == newWifiOn) return;
    m_wifiOn = newWifiOn;
    emit wifiOnChanged(m_wifiOn);

    if(!m_wifiOn) setHubOnline(false);
    else setHubOnline(true);

    recalculateEnergy();
}

void System::setClimateOn(bool on) {
    if (m_climateOn == on) return;
    m_climateOn = on;
    emit climateOnChanged(m_climateOn);
    recalculateEnergy();
}

void System::setRoomTemp(int temp) {
    if (m_roomTemp == temp) return;
    m_roomTemp = temp;
    emit roomTempChanged(m_roomTemp);
    recalculateEnergy();
}

void System::setTargetTemp(int temp) {
    if (m_targetTemp == temp) return;
    m_targetTemp = temp;
    emit targetTempChanged(m_targetTemp);
    recalculateEnergy();
}

void System::increaseTargetTemp() {
    m_targetTemp++;
    if (m_targetTemp > 30) m_targetTemp = 16;
    emit targetTempChanged(m_targetTemp);
    recalculateEnergy();
}

void System::setRobotVacuum(bool on) {
    if (m_robotVacuum == on) return;
    m_robotVacuum = on;
    emit robotVacuumChanged(m_robotVacuum);
    recalculateEnergy();
}

void System::setScenario(QString newScenario) {
    if (m_scenario == newScenario) return;

    m_scenario = newScenario;
    emit scenarioChanged(m_scenario);

    if (m_scenario == "morning")
    {
        setKettle(true);
        setClimateOn(true);
        setRobotVacuum(true);
    }
    else if (m_scenario == "evening")
    {
        setTargetTemp(24);
        setClimateOn(true);
        setRobotVacuum(false);
    }
}
