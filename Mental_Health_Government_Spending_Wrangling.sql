-- Import data from world expentitures from UNCTAD and data for depression/anxiety rates from ourworldindata --
-- Flip data so that countries condense for one row per distinct country and sectors become rows--
CREATE VIEW Government_Spending As
WITH CTE as
(
SELECT *
FROM worldexpenditures
where Year = "2017"
)
SELECT 
    C.Country,
    SUM(CASE WHEN sector = 'Total function' THEN Exp_Mill_USD ELSE 0 END) AS 'Total function',
    SUM(CASE WHEN sector = 'Agriculture, forestry, fishing and hunting' THEN Exp_Mill_USD ELSE 0 END) AS 'Agriculture, forestry, fishing and hunting',
    SUM(CASE WHEN sector = 'Mining, manufacturing and construction' THEN Exp_Mill_USD ELSE 0 END) AS 'Mining, manufacturing and construction',
    SUM(CASE WHEN sector = 'Communication' THEN Exp_Mill_USD ELSE 0 END) AS 'Communication',
    SUM(CASE WHEN sector = 'Fuel and energy' THEN Exp_Mill_USD ELSE 0 END) AS 'Fuel and energy',
    SUM(CASE WHEN sector = 'Environment protection' THEN Exp_Mill_USD ELSE 0 END) AS 'Environment protection',
    SUM(CASE WHEN sector = 'Housing and community amenities' THEN Exp_Mill_USD ELSE 0 END) AS 'Housing and community amenities',
    SUM(CASE WHEN sector = 'Health' THEN Exp_Mill_USD ELSE 0 END) AS 'Health',
    SUM(CASE WHEN sector = 'Education' THEN Exp_Mill_USD ELSE 0 END) AS 'Education',
    SUM(CASE WHEN sector = 'Social protection' THEN Exp_Mill_USD ELSE 0 END) AS 'Social protection',
    SUM(CASE WHEN sector = 'General public services' THEN Exp_Mill_USD ELSE 0 END)  AS 'General public services',
    SUM(CASE WHEN sector = 'Defence' THEN Exp_Mill_USD ELSE 0 END) AS 'Defence',
    SUM(CASE WHEN sector = 'Public order and safety' THEN Exp_Mill_USD ELSE 0 END) AS 'Public order and safety',
    SUM(CASE WHEN sector = 'Recreation, culture and religion' THEN Exp_Mill_USD ELSE 0 END) AS 'Recreation, culture and religion',
    SUM(CASE WHEN sector = 'General economic, commercial and labour affairs' THEN Exp_Mill_USD ELSE 0 END) AS 'General economic, commercial and labour affairs',
    SUM(CASE WHEN sector = 'Other industries' THEN Exp_Mill_USD ELSE 0 END) AS 'Other industries',
    SUM(CASE WHEN sector = 'RandD Economic affairs' THEN Exp_Mill_USD ELSE 0 END) AS 'RandD Economic affairs',
    SUM(CASE WHEN sector = 'Economic affairs n.e.c.' THEN EXP_Mill_USD ELSE 0 END) AS 'Economic affairs n.e.c.'
FROM CTE as C
GROUP BY C.Country;
-- Create a view displaying the Joined data from UNCTAD and Our World in Data--
CREATE VIEW Spending_MH_Rates as 
WITH MH_Rates as
(
SELECT *
FROM dna_rates
WHERE Year = '2017'
)
SELECT *
FROM government_spending AS GS
JOIN MH_Rates As MH
ON  GS.Country = MH.Entity;
-- Results--
SELECT *
FROM Spending_MH_Rates;
-- Create Table--
CREATE TABLE spending_wellness as
SELECT * FROM Spending_MH_Rates;
