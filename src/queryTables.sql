USE cmpe172project;
-- Schema Queries
SELECT *
FROM DAW;
SELECT *
FROM Installation;
SELECT *
FROM Plugin;
SELECT *
FROM SearchPath;
SELECT *
FROM Developer;
SELECT *
FROM fx_plugins;
SELECT *
FROM generator_plugins;
-- BO1 and BO2 are both create and insert queries, respectively
-- B03: Select plugins from developer 12 AKA FabFilter
Select *
FROM Plugin
WHERE devID = 12;
-- B04: Add new attribute to Developer table and display the table after all is said and done
ALTER TABLE Developer
ADD taxID Varchar(15);
SELECT *
FROM Developer;
-- B05: Update Developer Table to add one tuple after taxID attribute was newly added
UPDATE Developer
SET taxID = '123-45-6789'
WHERE devID = 1;
Select *
From Developer;
-- I01: 3-way Join to get certain views
SELECT *
FROM fx_plugins;
SELECT *
FROM generator_plugins;
-- I02: Cross Join - Retrieve all filepaths that DAWs use to find plugins
SELECT devName,
    dawName,
    filepath,
    pluginFormat
FROM developer
    INNER JOIN(
        SearchPath
        CROSS JOIN DAW
    ) ON DAW.devID = developer.devID
ORDER BY devName ASC;
-- I03: Left Join - Retrieve the total number of plugins that each developer makes
SELECT devName,
    COUNT(*) AS num_of_plugins
FROM plugin
    LEFT OUTER JOIN developer ON plugin.devID = developer.devID
GROUP BY devName;
-- I04: Natural Join - Retrieve the total number of plugins that correspond to each type of fx
SELECT pluginSubType,
    COUNT(*) AS num_of_plugins
FROM plugin
    NATURAL JOIN developer
WHERE pluginType = 'FX'
GROUP BY pluginSubType
ORDER BY pluginSubType ASC;
-- I05: Full Outer Join - Retrieve filepaths that plugins of different formats could be located in
SELECT DISTINCT pluginID,
    filepath,
    bits
FROM SearchPath
    LEFT JOIN Installation ON SearchPath.pluginFormat = Installation.pluginFormat
UNION
SELECT pluginID,
    filepath,
    bits
FROM Installation
    RIGHT JOIN SearchPath ON SearchPath.pluginFormat = Installation.pluginFormat;
-- A01: Subquery - Retrieve the possible filepaths that correspond to all generator plugins 
SELECT Name,
    generator_plugins_subquery.devName,
    filepath,
    filename_prefix,
    bits
FROM (
        SELECT DISTINCT plugin.Name,
            developer.devName,
            plugin.pluginSubType,
            installation.last_updated
        FROM plugin
            INNER JOIN installation ON plugin.pluginID = installation.pluginID
            INNER JOIN developer ON plugin.devID = developer.devID
        WHERE plugin.pluginType = 'Generator'
    ) AS generator_plugins_subquery,
    SearchPath,
    Developer
WHERE Developer.devName = generator_plugins_subquery.devName
ORDER BY devName ASC;
-- A02: Nested Join - Retrieve all plugin names, devs, and formats installed
SELECT Name,
    devName,
    pluginFormat
FROM Developer
    LEFT JOIN (
        Plugin
        INNER JOIN Installation ON Plugin.pluginID = Installation.pluginID
    ) ON Developer.devID = Plugin.devID
WHERE Name IS NOT NULL
ORDER BY Name ASC;
-- A03: Subquery - Retrieve the websites that correspond to all fx plugins, for possible updates
SELECT Name,
    fx_plugins_subquery.devName,
    web_address
FROM (
        SELECT DISTINCT plugin.Name,
            developer.devName,
            plugin.pluginSubType,
            installation.last_updated
        FROM plugin
            INNER JOIN installation ON plugin.pluginID = installation.pluginID
            INNER JOIN developer ON plugin.devID = developer.devID
        WHERE plugin.pluginType = 'FX'
    ) AS fx_plugins_subquery,
    Developer
WHERE Developer.devName = fx_plugins_subquery.devName
ORDER BY devName ASC;
-- A04: Subquery - Retrieve the name of all plugins from European developers
SELECT Plugin.Name
FROM Plugin
WHERE Plugin.devID IN (
        SELECT Developer.devID
        FROM Developer
        WHERE devCountry IN (
                'GER',
                'HUN',
                'BEL',
                'RUS',
                'FRA',
                'GBR',
                'NLD',
                'CZE',
                'CHE',
                'SWE'
            )
    );
-- A05: Subquery - Retrieve the names and websites of all American devs that make free plugins with a redundant-ahh software license to activate the plugin
SELECT free_but_licensed_subquery.devName,
    free_but_licensed_subquery.devCountry,
    free_but_licensed_subquery.web_address
FROM (
        SELECT DISTINCT devName,
            devCountry,
            web_address
        FROM plugin
            NATURAL JOIN developer
        WHERE isFree = 1
            AND hasLicense = 1
    ) AS free_but_licensed_subquery
WHERE devCountry = 'USA'
ORDER BY devName ASC;