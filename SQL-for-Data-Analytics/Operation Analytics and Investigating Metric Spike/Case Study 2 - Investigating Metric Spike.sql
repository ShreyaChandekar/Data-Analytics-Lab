DROP DATABASE metric_spike;

CREATE DATABASE metric_spike;

USE metric_spike;

# Table 1 - Users

Drop table users;

CREATE TABLE users (
user_id INT NOT NULL,
created_at VARCHAR(100),
company_id INT NOT NULL,
language VARCHAR(50),
activated_at VARCHAR(100),
state VARCHAR(50));

SELECT * from users;

SET SQL_SAFE_UPDATES = 0;

# Convert String date into timestamp
ALTER TABLE users ADD COLUMN temp_created_at DATETIME;
UPDATE users SET temp_created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');
ALTER TABLE users DROP COLUMN created_at;
ALTER TABLE users DROP COLUMN temp_occurred_at;
ALTER TABLE users CHANGE COLUMN temp_created_at created_at DATETIME;

ALTER TABLE users ADD COLUMN temp_activated_at DATETIME;
UPDATE users SET temp_activated_at = STR_TO_DATE(activated_at, '%d-%m-%Y %H:%i');
ALTER TABLE users DROP COLUMN activated_at;
ALTER TABLE users CHANGE COLUMN temp_activated_at activated_at DATETIME;

# Table 2 - Events
						
CREATE TABLE events (
user_id int,
occurred_at varchar(100),
event_type varchar(100),
event_name varchar(100),
location varchar(100),
device varchar(100),
user_type int 
);

SELECT * from events;

# Convert String date into timestamp
ALTER TABLE events ADD COLUMN temp_occurred_at DATETIME;
UPDATE events SET temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
ALTER TABLE events DROP COLUMN occurred_at;
ALTER TABLE events CHANGE COLUMN temp_occurred_at occurred_at DATETIME;

# Table 3 - Email Events
			
CREATE TABLE email_events (
user_id int,
occurred_at varchar(100),
action varchar(100),
user_type int);

SELECT * from email_events;

# Convert String date into timestamp
ALTER TABLE email_events ADD COLUMN temp_occurred_at DATETIME;
UPDATE email_events SET temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
ALTER TABLE email_events DROP COLUMN occurred_at;
ALTER TABLE email_events CHANGE COLUMN temp_occurred_at occurred_at DATETIME;


# Write an SQL query to calculate the weekly user engagement.
WITH weekly_user_count AS (
SELECT YEAR(occurred_at) AS years, WEEK(occurred_at) AS weeks, COUNT(DISTINCT user_id) AS weekly_user_count
FROM events
WHERE event_type = "engagement"
GROUP BY years, weeks
)
SELECT years, weeks, weekly_user_count,
ROUND((weekly_user_count/SUM(weekly_user_count) OVER ()) * 100, 2) AS engage_percent
FROM weekly_user_count
ORDER BY years, weeks asc;


# Write an SQL query to calculate the user growth for the product.
WITH users_1 AS (
SELECT  YEAR(created_at) as years, MONTH(created_at) as months,
        COUNT(DISTINCT user_id) AS total_users
FROM users
GROUP BY years, months
)
SELECT years, months, total_users, 
		total_users - LAG (total_users) OVER (ORDER BY years, months) AS user_growth,
        ROUND((total_users - LAG (total_users) OVER (ORDER BY years, months))/ 
        LAG(total_users) OVER (ORDER BY years, months)*100, 2) AS user_growth_percentage
FROM users_1
ORDER BY years, months;


# Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.
SELECT first_login AS weeks,
SUM(CASE WHEN week_number = 0 THEN 1 ELSE 0 END) AS Week_0,
SUM(CASE WHEN week_number = 1 THEN 1 ELSE 0 END) AS Week_1,
SUM(CASE WHEN week_number = 2 THEN 1 ELSE 0 END) AS Week_2,
SUM(CASE WHEN week_number = 3 THEN 1 ELSE 0 END) AS Week_3,
SUM(CASE WHEN week_number = 4 THEN 1 ELSE 0 END) AS Week_4,
SUM(CASE WHEN week_number = 5 THEN 1 ELSE 0 END) AS Week_5,
SUM(CASE WHEN week_number = 6 THEN 1 ELSE 0 END) AS Week_6,
SUM(CASE WHEN week_number = 7 THEN 1 ELSE 0 END) AS Week_7,
SUM(CASE WHEN week_number = 8 THEN 1 ELSE 0 END) AS Week_8,
SUM(CASE WHEN week_number = 9 THEN 1 ELSE 0 END) AS Week_9,
SUM(CASE WHEN week_number = 10 THEN 1 ELSE 0 END) AS Week_10,
SUM(CASE WHEN week_number = 11 THEN 1 ELSE 0 END) AS Week_11,
SUM(CASE WHEN week_number = 12 THEN 1 ELSE 0 END) AS Week_12,
SUM(CASE WHEN week_number = 13 THEN 1 ELSE 0 END) AS Week_13,
SUM(CASE WHEN week_number = 14 THEN 1 ELSE 0 END) AS Week_14,
SUM(CASE WHEN week_number = 15 THEN 1 ELSE 0 END) AS Week_15,
SUM(CASE WHEN week_number = 16 THEN 1 ELSE 0 END) AS Week_16,
SUM(CASE WHEN week_number = 17 THEN 1 ELSE 0 END) AS Week_17,
SUM(CASE WHEN week_number = 18 THEN 1 ELSE 0 END) AS Week_18
FROM
(
SELECT event_login.user_id, event_login.login_week, first_event.first_login, 
event_login.login_week - first_event.first_login AS week_number
FROM
(SELECT user_id, WEEK(occurred_at) AS login_week 
	FROM events
	GROUP BY 1, 2) event_login,
(SELECT user_id, MIN(WEEK(occurred_at)) AS first_login
	FROM events
	GROUP BY 1) first_event
	WHERE event_login.user_id = first_event.user_id
) sub
GROUP BY first_login
ORDER BY first_login ASC;


# Write an SQL query to calculate the weekly engagement per device.
WITH weekly_user_count AS (
SELECT WEEK(occurred_at) AS weeks, device, COUNT(DISTINCT user_id) AS weekly_user_count
FROM events
WHERE event_type = "engagement"
GROUP BY weeks, device
)
SELECT weeks, device, weekly_user_count,
ROUND((weekly_user_count/SUM(weekly_user_count) OVER ()) * 100, 2) AS engage_percent
FROM weekly_user_count
ORDER BY engage_percent DESC;

SELECT WEEK(occurred_at) AS weeks,
	COUNT(DISTINCT CASE WHEN device = 'acer aspire desktop' THEN user_id ELSE NULL END) AS acer_aspire_desktop,
    COUNT(DISTINCT CASE WHEN device = 'acer aspire notebook' THEN user_id ELSE NULL END) AS acer_aspire_notebook,
    COUNT(DISTINCT CASE WHEN device = 'amazon fire phone' THEN user_id ELSE NULL END) AS amazon_fire_phone,
    COUNT(DISTINCT CASE WHEN device = 'asus chromebook' THEN user_id ELSE NULL END) AS asus_chromebook,
    COUNT(DISTINCT CASE WHEN device = 'dell inspiron desktop' THEN user_id ELSE NULL END) AS dell_inspiron_desktop,
    COUNT(DISTINCT CASE WHEN device = 'dell inspiron notebook' THEN user_id ELSE NULL END) AS dell_inspiron_notebook,
    COUNT(DISTINCT CASE WHEN device = 'hp pavilion desktop' THEN user_id ELSE NULL END) AS hp_pavilion_desktop,
    COUNT(DISTINCT CASE WHEN device = 'htc one' THEN user_id ELSE NULL END) AS htc_one,
    COUNT(DISTINCT CASE WHEN device = 'ipad air' THEN user_id ELSE NULL END) AS ipad_air,
    COUNT(DISTINCT CASE WHEN device = 'ipad mini' THEN user_id ELSE NULL END) AS ipad_mini,
    COUNT(DISTINCT CASE WHEN device = 'iphone 4s' THEN user_id ELSE NULL END) AS iphone_4s,
    COUNT(DISTINCT CASE WHEN device = 'iphone 5' THEN user_id ELSE NULL END) AS iphone_5,
    COUNT(DISTINCT CASE WHEN device = 'iphone 5s' THEN user_id ELSE NULL END) AS iphone_5s,
    COUNT(DISTINCT CASE WHEN device = 'kindle fire' THEN user_id ELSE NULL END) AS kindle_fire,
    COUNT(DISTINCT CASE WHEN device = 'lenovo thinkpad' THEN user_id ELSE NULL END) AS lenovo_thinkpad,
    COUNT(DISTINCT CASE WHEN device = 'mac mini' THEN user_id ELSE NULL END) AS mac_mini,
    COUNT(DISTINCT CASE WHEN device = 'macbook air' THEN user_id ELSE NULL END) AS macbook_air,
    COUNT(DISTINCT CASE WHEN device = 'macbook pro' THEN user_id ELSE NULL END) AS macbook_pro,
    COUNT(DISTINCT CASE WHEN device = 'nexus 10' THEN user_id ELSE NULL END) AS nexus_10,
    COUNT(DISTINCT CASE WHEN device = 'nexus 5' THEN user_id ELSE NULL END) AS nexus_5,
    COUNT(DISTINCT CASE WHEN device = 'nexus 7' THEN user_id ELSE NULL END) AS nexus_7,
    COUNT(DISTINCT CASE WHEN device = 'nokia lumia 635' THEN user_id ELSE NULL END) AS nokia_lumia_635,
    COUNT(DISTINCT CASE WHEN device = 'samsumg galaxy tablet' THEN user_id ELSE NULL END) AS samsumg_galaxy_tablet,
    COUNT(DISTINCT CASE WHEN device = 'samsung galaxy note' THEN user_id ELSE NULL END) AS samsung_galaxy_note,
    COUNT(DISTINCT CASE WHEN device = 'samsung galaxy s4' THEN user_id ELSE NULL END) AS samsung_galaxy_s4,
    COUNT(DISTINCT CASE WHEN device = 'windows surface' THEN user_id ELSE NULL END) AS windows_surface
FROM events
WHERE event_type = "engagement"
GROUP BY weeks
ORDER BY weeks ASC;

# Write an SQL query to calculate the email engagement metrics.
WITH email_metrics AS (
    SELECT user_id,
        COUNT(*) AS total_emails_sent,
        SUM(CASE WHEN action = 'sent_weekly_digest' THEN 1 ELSE 0 END) AS sent_weekly_digest,
        SUM(CASE WHEN action = 'email_open' THEN 1 ELSE 0 END) AS email_open,
        SUM(CASE WHEN action = 'email_clickthrough' THEN 1 ELSE 0 END) AS email_clickthrough,
        SUM(CASE WHEN action = 'sent_reengagement_email' THEN 1 ELSE 0 END) AS sent_reengagement_email
    FROM email_events
    GROUP BY user_id
)
SELECT
    user_id, 
    CASE WHEN total_emails_sent > 0 THEN ROUND((sent_weekly_digest/ total_emails_sent) * 100, 2) ELSE 0 END AS sent_weekly_percent,
    CASE WHEN total_emails_sent > 0 THEN ROUND((email_open/ total_emails_sent) * 100, 2) ELSE 0 END AS email_open_percent,
    CASE WHEN total_emails_sent > 0 THEN ROUND((email_clickthrough/ total_emails_sent) * 100, 2) ELSE 0 END AS clickthrough_percent,
    CASE WHEN total_emails_sent > 0 THEN ROUND((sent_reengagement_email/ total_emails_sent) * 100, 2) ELSE 0 END AS reengagement_percent
FROM email_metrics
ORDER BY user_id;

