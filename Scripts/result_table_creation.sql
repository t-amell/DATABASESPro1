use project1;

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