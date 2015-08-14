require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'ar_test.db')

class AppOfferings < ActiveRecord::Base
end

id=1		
app = AppOfferings.find_by sys_id: id
puts app.name

# for testing
# before run this test ruby script, run following SQL in sqlite3 first
# $ sqlite3 ar_test.db
#> CREATE TABLE "app_offerings" ("sys_id" TEXT NOT NULL, "name" TEXT, PRIMARY KEY("sys_id"));
#> insert into app_offerings values ("1", "test_appl");