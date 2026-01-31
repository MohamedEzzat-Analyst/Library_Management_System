-- Task 1. Create a New Book Record -- -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')" --
insert into books (isbn, book_title, category , rental_price , status ,author,publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co');
select * from books
where author = 'Harper Lee';

-- Task 2: Update an Existing Member's Address --
SELECT * FROM library_db.members;

update members
set member_address = '2fawzy_elzaitoun'
where member_id = 'C106';
SELECT * from members;

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table --

select * from issued_status;

delete from issued_status
where issued_id='IS121';


-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.x 	 --

select * from issued_status
where issued_emp_id='E101';




-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book  --
/* I ADD JOIN TO FIND EMP_NAME */

select e.emp_name, ss.issued_emp_id, 
 count(*) as Num_Published
from issued_status as ss
join employees as e
on e.emp_id = ss.issued_emp_id
group by 2
having  Num_Published > 1 ;

-- Task 6: Retrieve All Books in a Specific Category: --

select * from books
where category = 'children';




/* CTAS (Create Table As Select) */
-- Task 7: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt** --
create table book_issued_count as 
select b.isbn , b.book_title , count(ss.issued_id) as Issued_Count

from issued_status as ss
join books as b
on ss.issued_book_isbn=b.isbn
group by 1 ,2;



/*Data Analysis & Findings */
-- Task 8: Find Total Rental Income by Category: --

SELECT 
    b.category ,
    SUM(b.rental_price) as sum_rental_price,
COUNT(*)   as Total_rental_num
FROM 
issued_status as ss
JOIN
books as b
ON b.isbn = ss.issued_book_isbn
GROUP BY 1;


        
-- Task 9: List Members Who Registered in the Last 180 Days: --
/*NO DATA FOUND FOR 180 Days difict so i add
('X1c' , 'Ezzat' , 'el_zaitoun' , '2026-1-14'),
		('X2C' , 'David' , 'New_cairo' , '2025-7-9')
        all data will below expect EZZAT */
        
SELECT * FROM members 
WHERE (reg_date <=NOW() - INTERVAL '180 days'DAY);
select * from members 
where reg_date <=now() -interval 180 day ;
SELECT * FROM members ;


insert into members (member_id , member_name , member_address , reg_date)
values ('X1c' , 'Ezzat' , 'el_zaitoun' , '2026-1-14');


insert into members (member_id , member_name , member_address , reg_date)
values('X2C' , 'David' , 'New_cairo' , '2025-7-9');


select * from members
 where reg_date >= date_sub(curdate(), interval 365 day);
/* ALL DATA HIDDEN EXPECT (Ezzat and David) new commer  in 1 year */



-- Task 10 : List Employees with Their Branch Manager's Name and their branch details: --
select e.emp_name ,e.emp_id , e.position , e.salary,
b.* , e2.emp_name as manager
from employees as e
join branch as b 
on e.emp_id =b.manager_id
join
employees as e2
on e2.emp_id = b.manager_id;

/*short*/

select e.emp_name ,e.emp_id , e.position , e.salary,
b.* , e.emp_name as manager
from employees as e
join branch as b 
on e.emp_id =b.manager_id;

-- Task 11 : Create a Table of Books with Rental Price Above a Certain Threshold: --

create table High_price_books as
select * from books 
where rental_price > 7.00;

rename table High_price_books to  expensive_books;
select * from expensive_books;


-- Task 12: Retrieve the List of Books Not Yet Returned --
select * from issued_status as ss
left join  return_status as rs
on ss.issued_id = rs.issued_id
where rs.issued_id is null;

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;



/*Advanced SQL Operations*/

-- Task 13: Identify Members with Overdue Books --
/* Write a query to identify members who have overdue books (assume a 30-day return period).
 Display the member's_id, member's name, book title, issue date, and days overdue. */
 
 /*******Time_Changed******/
 
 
SELECT 
		m.member_id,
        m.member_name ,
        b.book_title , 
        ss.issued_date, 
        rs.return_date as not_returned,
      current_date - ss.issued_date as Over_Dues_day
	
		FROM issued_status as ss
	join
    members as m
		on m.member_id = ss.issued_member_id
join
 books as b
		on ss.issued_book_isbn = b.isbn
LEFT join
return_status as rs
		on rs.issued_id = ss.issued_id
      where return_date is null  ; 
 

 
  
-- Task 14: Update Book Status on Return --
/*Write a query to update the status of books ,in the books table to "Yes" when they are returned (based on entries in the return_status table). */

select * from books;

 select * from books
where isbn = '978-0-06-025492-6';
 
 UPDATE books 
SET status = 'No'
where isbn = '978-0-06-025492-6';

 
select * from books
 where isbn ='978-0-06-025492-6';
 
 select * from return_status 
 where issued_id='IS124';
 
 insert  into return_status (return_id ,issued_id ,return_book_name, return_date)
 values 
 ('RI199','IS199', current_date());

 

 select * from return_status
 where return_id ='RI199';
 
 
 
 
 update  return_status 
set return_book_name = 'The_New_destiny'
where
return_id ='RI199';
 

 select * from return_status
 where return_id ='RI199';


/**APPROVED**/


