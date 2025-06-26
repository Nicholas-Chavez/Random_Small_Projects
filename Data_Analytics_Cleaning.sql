# Initial Exploration
/* 
In this part of the analysis, I will clean the data to simplify and make it usable in Excel or Tableau.
First I will explore the data to formulate strategies for grouping, summarizing, and mutating. 
The goal of this cleaning is to alter the data to answer three essential questions:
- How are different data analytics-specific jobs compensated differently?
- What is the experience compensation for different job titles?
- What are trends associated with data analytics jobs over time from 2020 to 2025?
With the answer to these questions, I will be able to determine the most beginner-friendly job titles, which data analytics
related jobs are paid the most, and how has the market for the data analytics career changed from 2020 to 2025?
*/

# Here I first Explored the data based on the top 10 rows.
SELECT *
FROM dataanalytics.salaries
limit 10;
/* 
Based on my initial observations, I first noticed that experience level and remote ratio are not optimized to be interpreted.
I would then want to change acronyms to full terms.
I would want to group the data by work year, experience level, jobtitle, and remote ratio.
*/
Select COUNT(DISTINCT job_title) as Job_Count
FROM dataanalytics.salaries;
/*
 There are 390 jobs, however these jobs are not Data Analytics focused but can relate to Data, Machine Learning, and AI.
 I Specifically want jobs that are more Data Analytics focused, which I would assume have `Data Analyst` or `Data Analytics`
 in the title. 
*/
SELECT COUNT(DISTINCT job_title)
FROM dataanalytics.salaries
WHERE job_title LIKE "Data Analy%";
# There are 13 jobs I want to focus on
SELECT DISTINCT job_title
FROM dataanalytics.salaries
WHERE job_title LIKE "Data Analy%";
/*
One last note  is that, based on my business objective I would want to 
focus on full-time employement, this will be done to avoid part-time, contract, 
and freelance employees from having a dramatic effect on averages.

Based on my exploration the following steps were determined:
Objective: Prepare data for analysis is Excel and Tableau
 Step 1: Group by work_year, experience_level, and jobtitle to determine average salaries in USD for data analysts 
 Step 2: filter through job_title to display data only data analytics related jobs
 Step 3: filter and only display full time employees
 Step 4: Alter remote_ratio to be remote when 100, hybrid when 50, and on-site when 0
 Step 5: Alter experience level to be full terms rather than abbreviations
 Step 6: Export Data for analysis in Excel, if small enough, or tableau
*/

# Cleaning
WITH CTE AS
(
	WITH CTE_2 AS
	(
	SELECT work_year, experience_level, job_title, salary_in_usd, remote_ratio
	FROM dataanalytics.salaries
	WHERE employment_type = 'FT' AND job_title like 'Data Analy%'
	)	
	SELECT work_year, experience_level, job_title, remote_ratio, ROUND(AVG(salary_in_usd),0) as average_Salary
	FROM CTE_2
	GROUP BY work_year, experience_level, job_title, remote_ratio
)
SELECT work_year, job_title, 
CASE WHEN remote_ratio = 0
    THEN 'On-Site'
    WHEN remote_ratio = 50
    THEN 'Hybrid'
    WHEN remote_ratio = 100
    THEN 'remote'
    END AS Work_Type,
CASE WHEN experience_level = 'EN'
	THEN 'Entry-level'
    WHEN experience_level = 'MI'
    THEN 'Mid-level'
    WHEN experience_level = 'SE'
    THEN 'Senior-level'
    WHEN experience_level = 'EX'
    THEN 'Executive'
    END as experience_level,
    average_salary
FROM CTE;

/*
Now we have a data set that shows different data analytics job types based on the jobs title, 
whether its remote, hybrid, or on-site, 
what experience level associated with the job, and the average salary of each of those jobs.

Due to the new size of the file being 115 rows, I can utilize excel to analyze this data and determine new insights.
*/

