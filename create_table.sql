drop table if exists nybikes;

create table nybikes(
tripduration int,
starttime text,
stoptime text,
start_stn_id int,
start_stn_name text,
start_stn_lat real,
start_stn_long real,
end_stn_id int,
end_stn_name char,
end_stn_lat real,
end_stn_long real,
bikeid int,
usertype text,
birth_year int,
gender int
);

-- Obviously you would need to adjust the file locations!
-- Data available for download from http://www.citibikenyc.com/system-data

.mode "csv"
.import '2013-07.csv' nybikes
.import '2013-08.csv' nybikes
.import '2013-09.csv' nybikes
.import '2013-10.csv' nybikes
.import '2013-11.csv' nybikes
.import '2013-12.csv' nybikes
.import '2014-01.csv' nybikes
.import '2014-02.csv' nybikes
.import '2014-03.csv' nybikes
.import '2014-04.csv' nybikes
.import '2014-05.csv' nybikes
.import '2014-06.csv' nybikes
.import '2014-07.csv' nybikes
.import '2014-08.csv' nybikes

-- each of these files has a header row, so lets get rid of all of those

delete from nybikes where gender = 'gender';

-- This is where I ran code in sqlitestudio
-- you could just run all this code in sqlitestudio by uncommenting the lines below. This take a long time to complete however!

--update nybikes set end_hash = substr(sha1(start_stn_id || start_stn_name || start_stn_lat || start_stn_long),1,6);
--update nybikes set end_hash = substr(sha1(end_stn_id || end_stn_name || end_stn_lat || end_stn_long),1,6);

drop table if exists stns;

-- Note that id is non-unique, so can't be used as primary key

create table stns(
hash text primary key,
id int,
name text,
lat real,
lon real
);

-- Since there are journeys starting and stopping at all the stations, it's probably not necessary to look at both start and stop stations to get the complete list of stations... but let's do it anyway for completeness.

insert into stns select distinct hash,start_stn_id,start_stn_name,start_stn_lat,start_stn_long from nybikes union select distinct end_hash,end_stn_id,end_stn_name,end_stn_lat,end_stn_long from nybikes;

-- You cannot remove columns in sqlite, so we need to copy the table and create a new one without the columns we want to drop

create temporary table nybikes1(
tripduration int,
starttime text,
stoptime text,
start_hash text,
end_hash text,
bikeid int,
usertype text,
birth_year int,
gender int
);

-- Copy nybikes into temporary nybikes1

insert into nybikes1 select tripduration,starttime,stoptime,
start_hash,end_hash,bikeid,usertype,birth_year,gender from nybikes;

drop table nybikes;

-- now create a new smaller table, insert the rows as before, and drop the temporary table...done!

create table nybikes(
tripduration int,
starttime text,
stoptime text,
start_hash int,
end_hash int,
bikeid int,
usertype text,
birth_year int,
gender int
);

insert into nybikes select tripduration,starttime,stoptime,
start_stn_id,end_stn_id,bikeid,usertype,birth_year,gender from nybikes1;

drop table nybikes1;
