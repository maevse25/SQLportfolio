-- Distinct artist names in DB
select DISTINCT(ar.Name) from Artist ar 

-- How many distinct Artists do we have?
select COUNT(DISTINCT(ar.Name)) from Artist ar 

-- Multiple JOINs + Like + Concatenation + Sorting order
select CONCAT( "'",t.Name,"'", " by ", ar.Name)
from
	Track t
join Album al on
	al.AlbumId = t.AlbumId
join Artist ar on
	ar.ArtistId = al.ArtistId
where ar.Name like '%Frank%'
order by ar.Name ASC;

-- Multiple JOINs + CASE
select
	t.Name Track_Name, al.Title Album_Name, ar.Name Artist_Name, t.Composer, g.Name Genre,
case
		when ar.Name = 'AC/DC' then 'Highway to hey look a squirrel!' -- id: 1
		when ar.Name = 'Apocalyptica' then 'Amazing cello' -- id: 7
		when ar.Name = 'Black Sabbath' then 'Ozzy Ozborne alive' -- id: 9
		when ar.Name = 'Buddy Guy' then 'Blues matters' -- id: 15
		when ar.Name = 'Aerosmith' then 'Armageddon movie' -- id: 3
		when ar.Name = 'Frank Sinatra' then 'What a voice!' -- id:23
		-- ELSE 'empty'
	END AS 'Impression'
from
	Track t
join Album al on
	al.AlbumId = t.AlbumId
join Artist ar on
	ar.ArtistId = al.ArtistId
join Genre g on
	g.GenreId = t.GenreId
where
	Impression is not NULL;

-- UPDATE price for tracks by 'Buddy Guy', 'Aerosmith', 'Frank Sinatra'
update
	Track
set
	UnitPrice = 1.5
where
	TrackId in 
(
	select
		t.TrackId
	from
		Track t
	join Album al on
		al.AlbumId = t.AlbumId
	join Artist ar on
		ar.ArtistId = al.ArtistId
	where
		ar.Name in ('Buddy Guy', 'Aerosmith', 'Frank Sinatra')
);

-- Verify UPDATE + Distinct
select
		distinct(t.UnitPrice)
	from
		Track t
	join Album al on
		al.AlbumId = t.AlbumId
	join Artist ar on
		ar.ArtistId = al.ArtistId
	where
		ar.Name in ('Buddy Guy', 'Aerosmith', 'Frank Sinatra')


-- Aggregation (COUNT + MAX) + HAVING + Multiple JOINs
-- Find an Artist who has MAX number of tracks among ('Buddy Guy', 'Aerosmith', 'Frank Sinatra', 'Metallica')
select
	artist_name,
	MAX(number_of_tracks)
from
	(
	select
		count(TrackId) as number_of_tracks,
		artist_name
	from
		(
		select
			t.TrackId
,
			t.UnitPrice track_price 
,
			t.Name track_name 
,
			al.Title album_title 
,
			ar.Name artist_name 
,
			ar.ArtistId
		from
			Track t
		join Album al on
			al.AlbumId = t.AlbumId
		join Artist ar on
			ar.ArtistId = al.ArtistId
			-- where ar.Name in ('Buddy Guy', 'Aerosmith', 'Frank Sinatra')
)
	GROUP by
		artist_name
	HAVING
		artist_name in ('Buddy Guy', 'Aerosmith', 'Frank Sinatra', 'Metallica')
)

-- WITH: to combine two tables, but one of the tables is the result of another calculation

with previous_query as(
	select
		customer_id,
		count(subscription_id) as 'subscriptions'
	from
		orders
	group by
		customer_id
)
select
	c.customer_name,
	p.subscriptions
from
	previous_query p
join customers c
on
	c.customer_id = p.customer_id

-- INSERT 
INSERT INTO public.events
(id, event_type, "location", "name", event_address_region_description, start_date, end_date, medical_event_vod__c)
VALUES(
nextval('events_id_seq'::regclass)
,'Event'
, 'Hotel Dnipro'
, 'Best event ever'
, 'Strategic street, 21, Kyiv, 02020'
, '2025-05-21 14:30:00.000'
, '2025-05-21 17:00:00.000'
, 'a0010000211521');

-- UPDATE 
update events e 
set start_date = '2025-05-06 12:00:00.000', 
end_date = '2025-05-06 17:00:00.000' 
where medical_event_vod__c = 'a0010000211521'

-- INSERT: using parameters
DO $$
DECLARE
    med_event_id TEXT := 'a0pBC000000XU49YAG'; -- !! change medical_event_vod__c according to your event
BEGIN

-- Attendee #1
INSERT INTO public.attendees
(id, 											account_vod__c, 	user_vod__c, 	medical_event_vod__c, status, code, receive_notification)
VALUES(nextval('attendees_id_seq'::regclass), '001AK000000000026', NULL, 			med_event_id, 'CRM', generate_random_code(), FALSE);

-- Attendee #2
INSERT INTO public.attendees
(id, 											account_vod__c, 	user_vod__c, 	medical_event_vod__c, status, code, receive_notification)
VALUES(nextval('attendees_id_seq'::regclass), '001d01ff350363a4ae', NULL, 			med_event_id, 'CRM', generate_random_code(), FALSE);

END
$$;

-- 