drop table if exists app_offerings;
drop table if exists url_checks; 
CREATE TABLE "app_offerings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "app_name" varchar, "app_sys_id" varchar, "app_class_name" varchar, "bu_l2" varchar, "bu_l3" varchar, "bu_l4" varchar, "off_name" varchar, "off_class_name" varchar, "off_core" text, "off_type" varchar, "last_upd" datetime DEFAULT '2015-08-12 21:17:22.651649');
CREATE TABLE "url_checks" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "url" varchar, "check_id" varchar, "app_sys_id" varchar, "app_offerings_id" varchar, "metric" varchar, "status" varchar, "response" decimal, "interval" decimal, "description" text, "service_type" varchar, "service_type_instance" varchar, "snow_update" datetime DEFAULT '2015-08-12 21:17:22.654921', "last_upd" datetime DEFAULT '2015-08-12 21:17:22.654931');
CREATE UNIQUE INDEX "index_url_checks_on_app_sys_id_and_check_id" ON "url_checks" ("app_sys_id", "check_id");
insert into app_offerings('app_name','app_sys_id') values ('FPS','app001');
insert into url_checks('check_id','app_sys_id') values ('c001','app001');