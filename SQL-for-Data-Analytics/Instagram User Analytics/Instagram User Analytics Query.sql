use ig_clone;

select * from users;

Select * from photos;

select * from comments;

select * from likes;

select * from follows;

select * from tags;

Select * from photo_tags;

/*  A.1 - Identify the five oldest users on Instagram from the provided database. */

SELECT * FROM users
ORDER BY created_at ASC
LIMIT 5;

/* A.2 - Identify users who have never posted a single photo on Instagram. */

SELECT users.id AS user_id, users.username, photos.id AS photo_id
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;

/* A.3 - Determine the winner of the contest where the user with the most likes on a single photo wins. */

SELECT users.id AS user_id, users.username, photos.id AS photo_id, photos.image_url, 
COUNT(likes.photo_id) AS total_likes
FROM users
JOIN photos ON users.id = photos.user_id
JOIN likes ON photos.id = likes.photo_id
GROUP BY users.id, users.username, photos.id, photos.image_url
ORDER BY total_likes desc
LIMIT 1;

/* A.4 - Identify and suggest the top five most commonly used hashtags on the platform. */

SELECT id as tag_id, tags.tag_name as tag_name, COUNT(photo_tags.tag_id) AS total_tags
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.tag_name
ORDER BY total_tags DESC
LIMIT 5;

/* A.5 - Determine the day of the week when most users register on Instagram. */

SELECT DAYNAME(created_at) AS register_day, COUNT(*) AS register_count
FROM users
GROUP BY register_day
ORDER BY register_count DESC;

/* B.1 -  Calculate the average number of posts per user on Instagram. 
Also, provide the total number of photos on Instagram divided by the total number of users. */

SELECT COUNT(photos.id) / COUNT(DISTINCT users.id) AS avg_posts_per_user, 
	   COUNT(photos.id) AS total_photos, COUNT(DISTINCT users.id) AS total_users,
       COUNT(photos.id) / COUNT(DISTINCT users.id) AS photo_user_ratio
FROM users
LEFT JOIN photos ON users.id = photos.user_id;

/* B.2 -  Identify users (potential bots) who have liked every single photo on the site, 
as this is not typically possible for a normal user. */

select users.username, likes.user_id , count(likes.photo_id) as total_liked
from likes 
join users on users.id=likes.user_id 
where likes.photo_id 
group by likes.user_id 
HAVING total_liked = (SELECT COUNT(photos.id) from photos);

