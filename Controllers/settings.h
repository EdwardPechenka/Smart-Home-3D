#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>

class Settings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double baseLoad READ baseLoad CONSTANT)
    Q_PROPERTY(double loadHub READ loadHub CONSTANT)
    Q_PROPERTY(double loadLock READ loadLock CONSTANT)
    Q_PROPERTY(double loadSensor READ loadSensor CONSTANT)
    Q_PROPERTY(double loadLightBulb READ loadLightBulb CONSTANT)
    Q_PROPERTY(double loadTv READ loadTv CONSTANT)
    Q_PROPERTY(double loadClimateBase READ loadClimateBase CONSTANT)
    Q_PROPERTY(double loadClimatePerDegree READ loadClimatePerDegree CONSTANT)
    Q_PROPERTY(double loadFridge READ loadFridge CONSTANT)
    Q_PROPERTY(double loadKettle READ loadKettle CONSTANT)
    Q_PROPERTY(double loadMicrowave READ loadMicrowave CONSTANT)
    Q_PROPERTY(double loadWashingMachine READ loadWashingMachine CONSTANT)
    Q_PROPERTY(double loadBoiler READ loadBoiler CONSTANT)
    Q_PROPERTY(double loadPc READ loadPc CONSTANT)
    Q_PROPERTY(double loadRouter READ loadRouter CONSTANT)
    Q_PROPERTY(double costPerKwh READ costPerKwh CONSTANT)
    Q_PROPERTY(double loadRobotVacuum READ loadRobotVacuum CONSTANT)
    Q_PROPERTY(double maxLoad READ maxLoad WRITE setMaxLoad NOTIFY maxLoadChanged)


public:
    explicit Settings(QObject *parent = nullptr);
    static Settings* instance();

    double baseLoad() const;
    double loadHub() const;
    double loadLock() const;
    double loadSensor() const;
    double loadLightBulb() const;
    double loadTv() const;
    double loadClimateBase() const;
    double loadClimatePerDegree() const;
    double loadFridge() const;
    double loadKettle() const;
    double loadMicrowave() const;
    double loadWashingMachine() const;
    double loadBoiler() const;
    double loadPc() const;
    double loadRouter() const;
    double costPerKwh() const;
    double loadRobotVacuum() const;

    double maxLoad() const;
    void setMaxLoad(double val);

signals:
    void maxLoadChanged();

private:
    static Settings* m_instance;
    double m_maxLoad;
};

#endif // SETTINGS_H
