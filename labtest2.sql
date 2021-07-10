show databases;
create database library;

use library;

create table publisher(
	name varchar(30) primary key,
    address varchar(50),
    phone varchar(10)
);
select * from publisher;

create table book(
	book_id int primary key,
    title varchar(20),
    pub_name varchar(30),
    pub_year varchar(20),
    foreign key(pub_name) references publisher(name) on delete cascade
);
select * from book;

create table book_authors(
	book_id int,
    author_name varchar(30),
    primary key(book_id,author_name),
    foreign key(book_id) references book(book_id) on delete cascade
);
select * from book_authors;

create table library_branch(
	branch_id int primary key,
    branch_name varchar(20),
    address varchar(50)
);
select * from library_branch;

create table book_copies(
	book_id int,
    branch_id int,
    no_of_copies int,
    primary key(book_id,branch_id),
    foreign key(book_id) references book(book_id) on delete cascade,
    foreign key(branch_id)references library_branch(branch_id) on delete cascade
);
select * from book_copies;

create table borrower(
	card_no int primary key,
    borrower_name varchar(30),
    address varchar(50),
    phone varchar(10)
);
select * from borrower;

create table book_loans(
	book_id int,
    branch_id int,
    card_no int,
    date_out date,
    due_date date,
    primary key(book_id,branch_id,card_no),
    foreign key(book_id) references book(book_id) on delete cascade,
    foreign key(branch_id) references library_branch(branch_id) on delete cascade,
    foreign key(card_no) references borrower(card_no) on delete cascade
);
select * from book_loans;

insert into publisher
values  ('Mcgraw-Hill','Bangalore',9989076587),
		('Pearson','New Delhi',9889076565),
        ('Random House','Hyderabad',7455679345),
        ('Hachette Livre','Chennai',8970862340),
        ('Grupo Planeta','Bangalore',7756120238);
        
select * from publisher;

insert into book
values  (1,'DBMS','Mcgraw-Hill','Jan-2017'),
		(2,'ADBMS','Mcgraw-Hill','Jun-2016'),
        (3,'CN','Pearson','Sep-2016'),
        (4,'CG','Grupo Planeta','Sep-2015'),
        (5,'OS','Pearson','May-2016'),
        (6,'Art of living','Pearson','May-2018');
        
select * from book;

insert into book_authors
values  (1,'Navathe'),
		(2,'Navathe'),
        (3,'Tanenbaum'),
        (4,'Edward Angel'),
        (5,'Galvin'),
        (6,'Stephen King');
        
select * from book_authors;

insert into library_branch
values  (10,'RR Nagar','Bangalore'),
		(11,'Rnsit','Bangalore'),
        (12,'Rajaji Nagar','Bangalore'),
        (13,'Nitte','Mangalore'),
        (14,'Manipal','Udupi'),
        (15,'Townhall','US'),
        (16,'Central','US');
select * from library_branch;

insert into book_copies
values  (4,10,10),
		(5,10,11),
        (2,12,12),
        (5,12,13),
        (3,13,14),
        (1,11,10),
        (3,14,11),
        (6,16,5),
        (2,15,8),
        (1,15,8);
select * from book_copies;

insert into borrower
values  (101,'Neelam','Bangalore','8618518254'),
		(102,'Aayush','Bangalore','8618519765'),
        (103,'Hema','US','8618511543'),
        (104,'Gagan','Mangalore','8618518631'),
        (105,'Meghana','Udupi','9548518254');
select * from borrower;

insert into book_loans
values  (1, 10, 101,'2017-01-01','2017-01-06'),
		(2, 10, 101,'2017-01-01','2017-01-06'),
        (3, 10, 101,'2017-01-01','2017-01-06'),
        (4, 10, 101,'2017-01-01','2017-01-06'),
        (5, 10, 101,'2017-01-01','2017-01-06'),
        (6, 10, 101,'2017-01-01','2017-01-06'),
		( 3, 14, 102,'2017-01-11','2017-03-11'),
		( 2, 13, 103,'2017-02-21','2017-04-21'),
		( 4, 11, 101,'2017-03-15','2017-07-15'),
		( 1, 11, 104,'2017-04-12','2017-05-12'),
        (4,15,102,'2021-06-05','2021-07-10'),
        (6,15,103,'2021-06-22','2021-07-25');
        
select * from book_loans;

#queries

#q1
SELECT B.borrower_name, B.address, COUNT(*) 
FROM borrower B, book_loans L 
WHERE B.card_no = L.card_no 
GROUP BY B.card_no 
HAVING COUNT(*) > 5;

#q2
SELECT title, no_of_copies 
FROM ( ( (book_authors NATURAL JOIN book) 
NATURAL JOIN book_copies) 
NATURAL JOIN library_branch) 
WHERE author_name = 'Stephen King' and branch_name = 'Central';

#q3
SELECT B.borrower_name 
FROM borrower B 
WHERE B.card_no NOT IN( 
	SELECT B.card_no
	FROM book_loans L 
	WHERE B.card_no = L.card_no
);

#q4
SELECT B.title, R.borrower_name, R.address 
FROM book B, borrower R, book_loans BL, library_branch LB 
WHERE LB.branch_name='Townhall' AND LB.branch_id=BL.branch_id AND 
BL.due_date='2021-07-10' AND BL.card_no=R.card_no AND BL.book_id=B.book_id;
