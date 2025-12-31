#ifndef SYSTEM_H
#define SYSTEM_H

#include <QObject>

class System : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool homeLocked READ homeLocked WRITE setHomeLocked NOTIFY homeLockedChanged FINAL)
    Q_PROPERTY(bool motionDetected READ motionDetected WRITE setMotionDetected NOTIFY motionDetectedChanged FINAL)
    Q_PROPERTY(bool frontdoorinicator READ frontdoorinicator WRITE setFrontdoorinicator NOTIFY frontdoorinicatorChanged FINAL)
    Q_PROPERTY(bool hubOnline READ hubOnline WRITE setHubOnline NOTIFY hubOnlineChanged FINAL)
    Q_PROPERTY(bool kettle READ kettle WRITE setKettle NOTIFY kettleChanged FINAL)
    Q_PROPERTY(bool microVave READ microVave WRITE setMicroVave NOTIFY microVaveChanged FINAL)
    Q_PROPERTY(bool washingMachine READ washingMachine WRITE setWashingMachine NOTIFY washingMachineChanged FINAL)
    Q_PROPERTY(bool boiLer READ boiLer WRITE setBoiLer NOTIFY boiLerChanged FINAL)
    Q_PROPERTY(bool pc READ pc WRITE setPc NOTIFY pcChanged FINAL)
    Q_PROPERTY(bool wifiOn READ wifiOn WRITE setWifiOn NOTIFY wifiOnChanged FINAL)

    Q_PROPERTY(int currentMode READ currentMode WRITE setCurrentMode NOTIFY currentModeChanged FINAL)

    Q_PROPERTY(double currentPower READ currentPower NOTIFY powerStatsChanged FINAL)
    Q_PROPERTY(double dailySavings READ dailySavings NOTIFY powerStatsChanged FINAL)
    Q_PROPERTY(int efficiency READ efficiency NOTIFY powerStatsChanged FINAL)

    Q_PROPERTY(bool lightRoom READ lightRoom WRITE setLightRoom NOTIFY lightRoomChanged FINAL)
    Q_PROPERTY(bool tvOn READ tvOn WRITE setTvOn NOTIFY tvOnChanged FINAL)
    Q_PROPERTY(bool fridgeOn READ fridgeOn WRITE setFridgeOn NOTIFY fridgeOnChanged FINAL)
    Q_PROPERTY(bool climateOn READ climateOn WRITE setClimateOn NOTIFY climateOnChanged FINAL)
    Q_PROPERTY(int roomTemp READ roomTemp WRITE setRoomTemp NOTIFY roomTempChanged FINAL)
    Q_PROPERTY(int targetTemp READ targetTemp WRITE setTargetTemp NOTIFY targetTempChanged FINAL)
    Q_PROPERTY(QString scenario READ scenario WRITE setScenario NOTIFY scenarioChanged FINAL)
    Q_PROPERTY(bool robotVacuum READ robotVacuum WRITE setRobotVacuum NOTIFY robotVacuumChanged FINAL)



public:
    explicit System(QObject *parent = nullptr);

    bool homeLocked() const;
    bool motionDetected() const;
    bool frontdoorinicator() const;
    bool hubOnline() const;
    int currentMode() const;
    double currentPower() const;
    double dailySavings() const;
    int efficiency() const;
    bool lightRoom() const;
    bool fridgeOn() const;
    bool kettle() const;
    bool microVave() const;
    bool washingMachine() const;
    bool boiLer() const;
    bool pc() const;
    bool wifiOn() const;
    bool climateOn() const;
    int roomTemp() const;
    int targetTemp() const;
    bool tvOn() const;
    QString scenario() const;
    bool robotVacuum() const;

public slots:
    void setHomeLocked(bool homeLocked);
    void setMotionDetected(bool motionDetected);
    void setFrontdoorinicator(bool newFrontdoorinicator);
    void setHubOnline(bool newHubOnline);
    void setCurrentMode(int newCurrentMode);
    void setLightRoom(bool newLightRoom);
    void setTvOn(bool newTvOn);
    void setFridgeOn(bool newFridgeOn);
    void setKettle(bool newKettle);
    void setMicroVave(bool newMicroVave);
    void setWashingMachine(bool newWashingMachine);
    void setBoiLer(bool newBoiLer);
    void setPc(bool newPc);
    void setWifiOn(bool newWifiOn);
    void setClimateOn(bool newClimateOn);
    void setRoomTemp(int newRoomTemp);
    void setTargetTemp(int newTargetTemp);
    void increaseTargetTemp();
    void setScenario(QString newScenario);
    void setRobotVacuum(bool newRobotVacuum);

signals:
    void homeLockedChanged(bool homeLocked);
    void motionDetectedChanged(bool motionDetected);
    void frontdoorinicatorChanged(bool frontdoorinicator);
    void hubOnlineChanged(bool hubOnline);

    void currentModeChanged(int currentMode);

    void powerStatsChanged();
    void lightRoomChanged(bool lightsLivingRoom);
    void tvOnChanged(bool tvOn);
    void fridgeOnChanged(bool fridgeOn);
    void kettleChanged(bool kettle);
    void microVaveChanged(bool microVave);

    void washingMachineChanged(bool washingMachine);

    void boiLerChanged(bool boiLer);

    void pcChanged(bool pc);

    void wifiOnChanged(bool wifiOn);
    void climateOnChanged(bool climateOn);
    void roomTempChanged(int roomTemp);
    void targetTempChanged(int targetTemp);
    void scenarioChanged(QString scenario);
    void robotVacuumChanged(bool robotVacuum);

private:
    void recalculateEnergy();

    bool m_homeLocked;
    bool m_motionDetected;
    bool m_frontdoorinicator;
    bool m_hubOnline;

    int m_currentMode;

    double m_currentPower;
    double m_dailySavings;
    int m_efficiency;
    bool m_lightRoom;
    bool m_tvOn;
    bool m_fridgeOn;
    bool m_kettle;
    bool m_microVave;
    bool m_washingMachine;
    bool m_boiLer;
    bool m_pc;
    bool m_wifiOn;
    bool m_climateOn;
    int m_roomTemp;
    int m_targetTemp;
    QString m_scenario;
    bool m_robotVacuum;
};

#endif // SYSTEM_H
