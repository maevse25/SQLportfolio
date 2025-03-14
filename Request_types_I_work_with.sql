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

