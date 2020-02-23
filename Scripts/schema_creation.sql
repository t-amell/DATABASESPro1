-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema project1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema project1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS project1 ;
USE project1 ;

-- -----------------------------------------------------
-- Table project1.land_values
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS project1.land_values (
  land_id INT NOT NULL AUTO_INCREMENT,
  cur_land_val INT NOT NULL,
  PRIMARY KEY (land_id))
;


-- -----------------------------------------------------
-- Table project1.parcel_values
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS project1.parcel_values (
  val_id INT NOT NULL,
  cur_val INT NOT NULL,
  land_id INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (val_id),
  INDEX fk_parcel_values_land_values1_idx (land_id ASC),
  CONSTRAINT fk_parcel_values_land_values1
    FOREIGN KEY (land_id)
    REFERENCES project1.land_values (land_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table project1.parcel
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS project1.parcel (
  parcel_id VARCHAR(45) NOT NULL,
  cur_acres DECIMAL(8,6) NOT NULL,
  land_use VARCHAR(45) NOT NULL,
  val_id INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (parcel_id),
  INDEX fk_parcel_parcel_values1_idx (val_id ASC),
  CONSTRAINT fk_parcel_parcel_values1
    FOREIGN KEY (val_id)
    REFERENCES project1.parcel_values (val_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table project1.parcel_loc
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS project1.parcel_loc (
  prop_center VARCHAR(255) NOT NULL,
  st_num INT NOT NULL,
  st_name VARCHAR(255) NOT NULL,
  parcel_id VARCHAR(45) NOT NULL,
  loc_id INT NOT NULL AUTO_INCREMENT,
  INDEX fk_parcel_loc_parcel_idx (parcel_id ASC),
  PRIMARY KEY (loc_id),
  CONSTRAINT fk_parcel_loc_parcel
    FOREIGN KEY (parcel_id)
    REFERENCES project1.parcel (parcel_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table project1.building_info
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS project1.building_info (
  building_id INT NOT NULL AUTO_INCREMENT,
  tot_gross_area DECIMAL(12,6) NOT NULL,
  tot_finished_area DECIMAL(12,6) NOT NULL,
  grade VARCHAR(255) NOT NULL,
  year_built INT NOT NULL,
  parcel_id VARCHAR(45) NOT NULL,
  PRIMARY KEY (building_id),
  INDEX fk_building_info_parcel1_idx (parcel_id ASC),
  CONSTRAINT fk_building_info_parcel1
    FOREIGN KEY (parcel_id)
    REFERENCES project1.parcel (parcel_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table project1.building_values
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS project1.building_values (
  building_id INT NOT NULL,
  cur_building_val INT NOT NULL,
  cur_yitems_val INT NOT NULL,
  val_id INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (building_id),
  INDEX fk_building_values_parcel_values1_idx (val_id ASC),
  CONSTRAINT fk_building_values_parcel_values1
    FOREIGN KEY (val_id)
    REFERENCES project1.parcel_values (val_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
