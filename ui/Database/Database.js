.import QtQuick.LocalStorage 2.0 as Sql

function getDatabase()
{
    return Sql.LocalStorage.openDatabaseSync("SmartHomeDB", "1.0", "Event History", 1000000);
}

function initDatabase()
{
    var db = getDatabase();
    db.transaction(function(tx)
    {
        tx.executeSql('CREATE TABLE IF NOT EXISTS history(id INTEGER PRIMARY KEY AUTOINCREMENT, device TEXT, state TEXT, time TEXT)');
    });
}

function addEvent(device, state)
{
    var db = getDatabase();
    var now = new Date();
    var timeStr = now.toLocaleTimeString(Qt.locale(), "HH:mm:ss");

    db.transaction(function(tx) {
        tx.executeSql('INSERT INTO history(device, state, time) VALUES(?, ?, ?)', [device, state, timeStr]);
    });
}

function readHistory(model)
{
    var db = getDatabase();
    model.clear();

    db.transaction(function(tx)
    {
        var rs = tx.executeSql('SELECT * FROM history ORDER BY id DESC LIMIT 50');
        for (var i = 0; i < rs.rows.length; i++) {
            model.append({
                "device": rs.rows.item(i).device,
                "state": rs.rows.item(i).state,
                "time": rs.rows.item(i).time
            });
        }
    });
}

function clearHistory(model)
{
    var db = getDatabase();
    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM history');
    });
    model.clear();
}
