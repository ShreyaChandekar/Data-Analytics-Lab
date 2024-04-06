CREATE DATABASE jobdata_analysis;

USE jobdata_analysis;

DROP TABLE job_data;

CREATE TABLE job_data (
ds DATE,
job_id INT,
actor_id INT,
event VARCHAR(255),
language VARCHAR(255),
time_spent TIME,
org VARCHAR(50)
);

INSERT INTO job_data (ds, job_id, actor_id, event, language, time_spent, org)
VALUES ('2020-11-30', 21, 1001,'skip ', 'English', 15, 'A'),
	   ('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
       ('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
       ('2020-11-28', 23, 1005, 'transfer', 'Persian', 22, 'D'),
       ('2020-11-28', 25, 1005, 'decision', 'Hindi', 11, 'B'),
       ('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
       ('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
       ('2020-11-25', 20, 1003, 'transfer', 'Italian', 45, 'C');

SELECT * FROM job_data;

# Write an SQL query to calculate the number of jobs reviewed per hour for each day in November 2020.
SELECT ds AS `date`, ROUND(COUNT(job_id)/SUM(time_spent/(60*60))) AS job_reviewed_per_hour
FROM job_data
WHERE ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY ds
ORDER BY ds ASC;


/* Write an SQL query to calculate the 7-day rolling average of throughput. 
Additionally, explain whether you prefer using the daily metric or the 7-day rolling average for throughput, and why.*/

# Option-1
SELECT ds AS date, time_spent, event,
  COUNT(event) OVER (ORDER BY ds asc, event ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)/ 
  SUM(time_spent) OVER (ORDER BY ds asc, event ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM job_data
ORDER BY ds;

#Option-2
SELECT date, events_per_second as daily_avg_tp, 
ROUND(AVG(events_per_second) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 3) AS 7days_rolling_avg_tp
FROM (
SELECT ds AS date, ROUND(COUNT(event) / SUM(time_spent), 3) AS events_per_second
FROM job_data
GROUP BY ds
) AS job_data1
ORDER BY date;												


/* Write an SQL query to calculate the percentage share of each language over the last 30 days.*/

SELECT language, COUNT(language) AS language_count,
  ROUND(COUNT(language) * 100.0 / SUM(COUNT(language)) OVER (), 2) AS percentage_share
FROM job_data
GROUP BY language
ORDER BY language_count ASC;


/* Write an SQL query to display duplicate rows from the job_data table.*/
SELECT *, COUNT(*) AS duplicate_rows
FROM job_data
GROUP BY job_id, actor_id, event, language, time_spent, org, ds
HAVING COUNT(*) > 1;


SELECT *  FROM ( 
SELECT *, 
ROW_NUMBER()OVER(PARTITION  BY job_id) AS row_no
FROM job_data 
) job_data1
WHERE row_no > 1;
