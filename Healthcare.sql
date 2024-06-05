create database Healthcare; 
use Healthcare;
SELECT * FROM healthcare.`healthcare csv`;
SELECT count(*) FROM healthcare.`healthcare csv`;
SELECT count(*) FROM healthcare.`dialysis - i`;
SELECT count(*) FROM healthcare.`dialysis - ii`;
-- KPI 1 : Number of Patients across various summaries
select sum(`NOFPthe transfusion summary`) as Transfusion_Summary,
sum(`NOFP hypercalcemia summary`) as Hypercalcemia_summary,
sum(`NOFP Serum phosphorus summary`) as Serumphosphorus_summary,
sum(`NOFP in hospitalization summary`) as Hospitalization_summary,
sum(`Number of hospitalizations HRS`) as Readmission_summary,
sum(`NOFP in survival summary`) as Survival_summary,
sum(`NOFP in fistula summary`) as Fistula_summary,
sum(`NOFPin long term catheter`) as catheter_summary from healthcare.`healthcare csv`;

//*OR*/
  ----------------------------- kpi_1:otheroutput includes wordings as lakhs------------
  SELECT
    CONCAT(FORMAT(SUM(IFNULL(`NOFPthe transfusion summary`, 0)) / 100000, 2), ' Lakhs') AS TransfusionPatients,
    CONCAT(FORMAT(SUM(IFNULL(`NOFP hypercalcemia summary`, 0)) / 100000, 2), ' Lakhs') AS HypercalcemiaPatients,
    CONCAT(FORMAT(SUM(IFNULL(`NOFP Serum phosphorus summary`, 0)) / 100000, 2), ' Lakhs') AS SerumPhosphorusPatients,
    CONCAT(FORMAT(SUM(IFNULL(`NOFP in hospitalization summary`, 0)) / 100000, 2), ' Lakhs') AS HospitalizationPatients,
    CONCAT(FORMAT(SUM(IFNULL(`Number of hospitalizations HRS`, 0)) / 100000, 2), ' Lakhs') AS HospitalReadmissionPatients,
    CONCAT(FORMAT(SUM(IFNULL(`NOFP in survival summary`, 0)) / 100000, 2), ' Lakhs') AS SurvivalPatients,
    CONCAT(FORMAT(SUM(IFNULL(`NOFP in fistula summary`, 0)) / 100000, 2), ' Lakhs') AS FistulaPatients,
    CONCAT(FORMAT(SUM(IFNULL(`NOFPin long term catheter`, 0)) / 100000, 2), ' Lakhs') AS LongCatheterPatients
FROM
  healthcare.`healthcare csv`;

	---------------- kpi-2:Profit Vs Non-Profit------
	------------ code2"usingcount"&"groupby" ------------
	SELECT
		`Profit or Non-Profit`,
		COUNT(*) AS Total_Centers,
		AVG(`# of Dialysis Stations`) AS AvgDialysisStations,
		AVG(`NOFP in fistula summary`) AS AvgFistulaPatients,
		AVG(`NOFPin long term catheter`) AS AvgLongCatheterPatients
	FROM
		healthcare.`healthcare csv`
	GROUP BY
		`Profit or Non-Profit`;

----- KPI3 Chain Organizations w.r.t. Total Performance Score as No Score-----

SELECT `Chain Organization`, SUM(`Total Performance Score`) as `No Score`
FROM healthcare.`healthcare csv`
GROUP BY `Chain Organization`
ORDER BY SUM(`Total Performance Score`) DESC
LIMIT 10;

------------------------- KPI 4 Dialysis Stations State-------------------
SELECT
    State,
    AVG(`# of Dialysis Stations`) AS AvgDialysisStations,
    MAX(`# of Dialysis Stations`) AS MaxDialysisStations,
    MIN(`# of Dialysis Stations`) AS MinDialysisStations,
    COUNT(*) AS TotalFacilities
FROM
     healthcare.`dialysis - i`
GROUP BY
    State;

--------------------------- KPI 5 # of Category Text  - As Expected ---------------------------------
 SELECT
    SUM(CASE WHEN `Patient Transfusion category text` = 'As Expected' THEN 1 ELSE 0 END) AS TransfusionAsExpected,
    SUM(CASE WHEN `Patient hospitalization category text` = 'As Expected' THEN 1 ELSE 0 END) AS HospitalizationAsExpected,
    SUM(CASE WHEN `Patient Hospital Readmission Category` = 'As Expected' THEN 1 ELSE 0 END) AS HospitalReadmissionsAsExpected,
    SUM(CASE WHEN `Patient Survival Category Text` = 'As Expected' THEN 1 ELSE 0 END) AS SurvivalAsExpected,
    SUM(CASE WHEN `Patient Infection category text` = 'As Expected' THEN 1 ELSE 0 END) AS InfectionAsExpected,
    SUM(CASE WHEN `Fistula Category Text` = 'As Expected' THEN 1 ELSE 0 END) AS FistulaAsExpected,
    SUM(CASE WHEN `SWR category text` = 'As Expected' THEN 1 ELSE 0 END) AS SWRAsExpected,
    SUM(CASE WHEN `PPPW category text` = 'As Expected' THEN 1 ELSE 0 END) AS PPPWAsExpected
FROM
    healthcare.`dialysis - i`;
    
    
------------------------- KPI 6 Average Payment Reduction Rate---------------------------
SELECT ROUND(AVG(`PY2020 Payment Reduction Percentage`) * 100, 3) 
AS Average_Payment_Reduction_Rate
FROM healthcare.`healthcare csv`;
---- another way---
select round(avg(`PY2020 Payment Reduction Percentage`),2) as 'AveragePaymentReduction' 
from healthcare.`dialysis - ii`
 where 
`PY2020 Payment Reduction Percentage` <> 'No reduction';