create external table countries
   (    
   country_id string  , 
    country_name string, 
    region_id int
   ) 
   row format delimited
   FIELDS TERMINATED BY ','
   location '/tmp/hr/countries/'
   ;
  
   
  create external table employees
   (    employee_id int, 
    first_name string, 
    last_name string , 
    email string , 
    phone_number string, 
    hire_date string , 
    job_id string , 
    salary double, 
    commission_pct double, 
    manager_id int, 
    department_id int
   ) 
row format delimited
   FIELDS TERMINATED BY ','
   location '/tmp/hr/employees/'
   ;
   
   
  create external table job_history
   (    employee_id int  , 
    start_date string , 
    end_date string , 
    job_id string , 
    department_id int
   )
   row format delimited
   FIELDS TERMINATED BY ','
   location '/tmp/hr/job_history/' ;
   
   
  create external table jobs
   (    job_id string, 
    job_title string , 
    min_salary int, 
    max_salary int
   ) 
      row format delimited
   FIELDS TERMINATED BY ','
   location '/tmp/hr/jobs/' ;
   
   
  create external table locations
   (    location_id int, 
    street_address string, 
    postal_code string, 
    city string , 
    state_province string, 
    country_id string 
   ) 
      row format delimited
   FIELDS TERMINATED BY ','
   location '/tmp/hr/locations/' ;
   
   
  create external table regions
   (    region_id int  , 
    region_name string
   ) 
       row format delimited
   FIELDS TERMINATED BY ','
   location '/tmp/hr/regions/' ;