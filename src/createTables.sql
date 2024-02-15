USE cmpe172project;
-- Create the tables and views
CREATE TABLE IF NOT EXISTS Developer(
    devName VARCHAR(32) NOT NULL,
    devID INTEGER NOT NULL PRIMARY KEY,
    web_address VARCHAR(64),
    devCountry VARCHAR(4),
    filename_prefix VARCHAR(8) NOT NULL
);
CREATE TABLE IF NOT EXISTS Plugin(
    pluginID INTEGER NOT NULL PRIMARY KEY,
    Name VARCHAR(32) NOT NULL,
    devID INTEGER NOT NULL,
    pluginType VARCHAR(16) NOT NULL,
    pluginSubType VARCHAR(16) NOT NULL,
    isFree BOOLEAN NOT NULL,
    hasLicense BOOLEAN NOT NULL,
    -- constraints
    FOREIGN KEY (devID) REFERENCES Developer(devID)
);
CREATE TABLE IF NOT EXISTS Installation(
    pluginID INTEGER NOT NULL,
    pluginFormat VARCHAR(4) NOT NULL,
    last_updated DATE NOT NULL,
    -- constraints
    FOREIGN KEY (pluginID) REFERENCES Plugin(pluginID)
);
CREATE TABLE IF NOT EXISTS DAW(
    dawName VARCHAR(16) NOT NULL PRIMARY KEY,
    devID INTEGER NOT NULL,
    dawVersion VARCHAR(16) NOT NULL,
    last_updated DATE NOT NULL,
    -- constraints
    FOREIGN KEY (devID) REFERENCES Developer(devID)
);
CREATE TABLE IF NOT EXISTS SearchPath(
    pluginFormat VARCHAR(4) NOT NULL,
    filepath VARCHAR(64) NOT NULL PRIMARY KEY,
    sys_disk CHAR(1) NOT NULL,
    bits INTEGER NOT NULL
);
-- FX View
CREATE VIEW fx_plugins AS
SELECT DISTINCT plugin.Name,
    developer.devName,
    plugin.pluginSubType,
    installation.last_updated
FROM plugin
    INNER JOIN installation ON plugin.pluginID = installation.pluginID
    INNER JOIN developer ON plugin.devID = developer.devID
WHERE plugin.pluginType = 'FX'
ORDER BY developer.devName ASC;
-- Generator View
CREATE VIEW generator_plugins AS
SELECT DISTINCT plugin.Name,
    developer.devName,
    plugin.pluginSubType,
    installation.last_updated
FROM plugin
    INNER JOIN installation ON plugin.pluginID = installation.pluginID
    INNER JOIN developer ON plugin.devID = developer.devID
WHERE plugin.pluginType = 'Generator'
ORDER BY developer.devName ASC;