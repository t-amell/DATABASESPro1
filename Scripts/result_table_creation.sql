use project1;

/*
Question 1
What are the biggest properties by street? (acreage)
*/
drop table if exists q1results;
create table q1results(
id varchar(45),
street varchar(255),
acres decimal(12, 6),
land_use varchar(255)
)
select parcel.parcel_id as 'ID', concat(parcel_loc.st_num, ' ', parcel_loc.st_name) as 'Street',
	parcel.cur_acres as 'Acres', land_use
from parcel join parcel_loc on parcel.parcel_id = parcel_loc.parcel_id
order by cur_acres DESC;

/*
Question 2
What are the biggest buildings by street? (gross area)
*/

drop table if exists q2results;
create table q2results(
	tot_gross_area DECIMAL(12,6) not null,
    address VARCHAR(255) not null,
    land_use VARCHAR(255) not null
);

insert into q2results(
	select tot_gross_area as 'Total Gross Area' , concat(st_num,' ', st_name)
		as 'Address', land_use as 'Land Use'
	from building_info as b_i join parcel_loc as p_l
		on b_i.parcel_id = p_l.parcel_id join parcel as p
		on p_l.parcel_id = p.parcel_id
		
	order by tot_gross_area DESC
);

/*
Question 3 Part 1
Does acreage or location matter more in relation to land value? (acreage vs. location)
Create a new temp table to hold data for this part of the question, which orders by land value
*/

drop table if exists temp_landval;
create temporary table temp_landval(
keyval int not null auto_increment primary key,
parcel_id varchar(255),
st_num varchar(255),
st_name varchar(255),
cur_acres decimal(12, 6), 
cur_land_val int,
land_use varchar(255)
)
select parcel.parcel_id, st_num, st_name, cur_acres, cur_land_val, land_use
from parcel join parcel_loc on parcel.parcel_id = parcel_loc.parcel_id
	join parcel_values on parcel_values.val_id = parcel.val_id
		join land_values on land_values.land_id = parcel_values.land_id
order by cur_land_val DESC;

/*
Q3 Part 2, which orders by acres. This result will be put into another temp table
*/

drop table if exists temp_acres;
create temporary table temp_acres(
keyval int not null auto_increment primary key,
parcel_id varchar(255),
st_num varchar(255),
st_name varchar(255),
cur_acres decimal(12, 6), 
cur_land_val int,
land_use varchar(255)
)
select parcel.parcel_id, st_num, st_name, cur_acres, cur_land_val, land_use
from parcel join parcel_loc on parcel.parcel_id = parcel_loc.parcel_id
	join parcel_values on parcel_values.val_id = parcel.val_id
		join land_values on land_values.land_id = parcel_values.land_id
order by cur_acres DESC;

/*
Q3 Part 3: Run queries over the two temporary tables that will compare land values in the table
		   ordered by acreage, and the table ordered by value.
           This result table will give us the insight we need to determine if location matters
           more than acreage.
           
           If land value difference > 0 and acre difference < 0, then the location of the parcel with the higher value matters more than the size of the other parcel.
				-Because this means the smaller property is worth more than the bigger property, likely due to location
		   If land value difference < 0 and acre difference < 0, then the bigger parcel's size is worth more than the location of the smaller parcel
		   If land value difference < 0 and acre difference > 0, this is the inverse of the first condition, where the location of the parcel from the 'acres' table matters more than the size
				of the parcel from the 'land vals' table. This is still a valid result for this question.
           
		   If land value difference > 0 and acre difference > 0, then the higher value parcel is both bigger and worth more than the other property, therefore voiding a result
*/

drop table if exists q3results;
create table q3results(
big_val_id varchar(255),
big_acre_id varchar(255),
big_val_st varchar(255),
big_acre_st varchar(255),
landval_diff int,
acre_diff decimal(12, 6)
);

insert into q3results(
select temp_landval.parcel_id as 'Bigger Value ID', temp_acres.parcel_id as 'Bigger Acre ID',
	concat(temp_landval.st_num, ' ', temp_landval.st_name) as 'Bigger Value Street',
    concat(temp_acres.st_num, ' ', temp_acres.st_name) as 'Bigger Acre Street',
	(temp_landval.cur_land_val - temp_acres.cur_land_val) as 'Land Value Difference',
    (temp_landval.cur_acres - temp_acres.cur_acres) as 'Acre Difference'
from temp_landval join temp_acres on temp_landval.keyval = temp_acres.keyval

where ((temp_landval.cur_land_val - temp_acres.cur_land_val) > 0 and (temp_landval.cur_acres - temp_acres.cur_acres) < 0) or
	  ((temp_landval.cur_land_val - temp_acres.cur_land_val) < 0 and (temp_landval.cur_acres - temp_acres.cur_acres) < 0) or
      ((temp_landval.cur_land_val - temp_acres.cur_land_val) < 0 and (temp_landval.cur_acres - temp_acres.cur_acres) > 0)

group by temp_landval.st_num, temp_landval.st_name
);

/*
Question 4
Does the total finished area influence value more than gross area? (buildings)
*/

drop table if exists q4results;
create table q4results(
	tot_gross_area DECIMAL(12,6) not null,
    tot_finished_area DECIMAL(12,6) not null,
    difference DECIMAL(12,6) not null,
    cur_building_val INT not null
);

insert into q4results(
	select tot_gross_area as 'Total Gross Area', tot_finished_area as 'Total Finished Area',
		(tot_gross_area-tot_finished_area) as 'Difference of Finished to Gross Area', cur_building_val as 'Current Building Val'
	from building_info as b_i join building_values as b_v
		on b_i.building_id = b_v.building_id
		
	where cur_building_val > 0

	order by (tot_gross_area-tot_finished_area) DESC
);

/*
Question 5
Does the current value of a property influence its grade? (overall property rating)
*/

drop table if exists q5results;
create table q5results(
	grade VARCHAR(255),
    cur_val INT not null,
    land_use VARCHAR(255) not null
);

insert into q5results(
	select grade as 'Grade', cur_val as 'Current Value', land_use as 'Land Use'
	from parcel as p join building_info as b_i
		on p.parcel_id = b_i.parcel_id join parcel_values as p_v
		on p.val_id = p_v.val_id
	where cur_val > 0 and grade is not null
    order by cur_val DESC
);