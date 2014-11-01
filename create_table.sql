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

.mode "csv"
.import bike_data.csv nybikes
.import '/home/matthew/Downloads/citibike/2013-07.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-08.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-09.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-10.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-11.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-12.csv' nybikes
.import '/home/matthew/Downloads/citibike/2014-01.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-02.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-03.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-04.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-05.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-06.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-07.csv' nybikes
.import '/home/matthew/Downloads/citibike/2013-08.csv' nybikes

delete from nybikes where gender = 'gender';

drop table if exists stns;

create table stns(
stn_id int primary key,
stn_name text,
stn_lat real,
stn_long real
);

insert into stns select distinct start_stn_id,start_stn_name,start_stn_lat,start_stn_long from nybikes union select distinct end_stn_id,end_stn_name,end_stn_lat,end_stn_long from nybikes;

create temporary table nybikes1(
tripduration int,
starttime text,
stoptime text,
start_stn_id int,
end_stn_id int,
bikeid int,
usertype text,
birth_year int,
gender int
);

insert into nybikes1 select tripduration,starttime,stoptime,
start_stn_id,end_stn_id,bikeid,usertype,birth_year,gender from nybikes;

drop table nybikes;

create table nybikes(
tripduration int,
starttime text,
stoptime text,
start_stn_id int,
end_stn_id int,
bikeid int,
usertype text,
birth_year int,
gender int
);

insert into nybikes select tripduration,starttime,stoptime,
start_stn_id,end_stn_id,bikeid,usertype,birth_year,gender from nybikes1;

drop table nybikes1;

