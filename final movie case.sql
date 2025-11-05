#                               SQL Assignment - Movie Analysis

        ########################################################################
        #   Weighting 2.5%, 57 points in total                                 #
        #   Structure:                                                         #
        # - Exercise 1                                                         #
        # - Exercise 2                                                         #
        # - Exercise 3                                                         #
        # -------------------------------------------------------------------- #x
        #   Please keep the following in mind:                                 #
        # - Is the code organized such that it is easy to read/understandable? #
        # - Is documentation (where needed) included?                          #
        # - Code quality/efficiency/logic                                      #
        # - One query per question                                             #
        ########################################################################


# Manage a chain of Movie Rental Stores
# Introduction
# -Data: Dataset download link: https://weclouddata.s3.amazonaws.com/datasets/movie_rental_sakila.zip
    # In this project, you will write more advanced queries on a database designed to resemble a real-world database system - MySQL’s Sakila Sample Database.
    # The development of the Sakila sample database began in early 2005. Early designs were based on the database used in the Dell whitepaper (Three Approaches to MySQL Applications on Dell PowerEdge Servers).
    # The Sakila sample database is designed to represent a DVD rental store. The Sakila sample database still borrows film and actor names from the Dell sample database.

# Problem Description
# You will be writing queries in SQL to manage a chain of movie rental stores, for example,
    # -Track the inventory level and determine whether the rental can happen
    # -Manage customer information and identify loyalty customers
    # -Monitor customers’ owing balance and find overdue DVDs

# This project can be considered as a typical retail-related business case, because it has the main metrics you can find in any retailer’s real database, such as Walmart, Shoppers, Loblaws, Amazon...

# Key Metrics:
    # -Production information (in this project, it is the film)
    # -Sales information
    # -Inventory information
    # -Customer behavior information



create database sakila;
use sakila;
-- I re-ran the entire database file
-- source : https://dev.mysql.com/doc/index-other.html


########################################################################################################################
#                                    Exercise 1

# 1.Before doing any exercise, you should explore the data first.
    # -For Exercise 1, we will focus on the product, which is the film (DVD) in this project.
    # -Please explore the product-related tables
# (actor, film_actor, film, language, film_category, category) by using SELECT * – Do not forget to limit the number of records

select * from actor limit 10;
select * from film_actor limit 10;
select * from language limit 10;
select * from category limit 10;
select * from film limit 10;
select * from film_category limit 10;


## Use table FILM to solve the questions below:
# 2.What is the largest `rental_rate` for each rating?
select
    rating,
    max(rental_rate)
from film
group  by rating;


# 3.How many films are in each rating category?
select
    distinct(rating) as "rating category" ,
    count(distinct (film_id)) as "count Films"
    from film
 group by rating;

# 4.Create a new column `film_length` to segment different films by length:
# `length < 60 then ‘short’; length < 120 then standard’; length >=120 then ‘long’,
# then count the number of films in each segment.`
select * from film limit 10;

-- temp column not actually alter table
select
    case
        WHEN length>0 and length<60 THEN 'short'
        when length<120 THEN 'standard'
        else 'long'
    end as "film_length",
    count(*) as number_of_films
from film
group by film_length
;

## Use table ACTOR to solve questions as below:
# 5.Which actors have the last name ‘Johansson’?
select * from actor limit 10;
select
    first_name,
    last_name
from actor
where last_name = "Johansson"
;

# 6.How many distinct actors’ last names are there?
select
    count(distinct (actor.last_name)) as distinct_last_name
from actor;

# 7.Which last names are not repeated? Hint: use COUNT() and GROUP BY and HAVING
select
    actor.last_name
from actor
group by last_name
having count(*)=1 ;

# 8.Which last names appear more than once?
select * from actor limit 10;

select
    actor.last_name
from actor
group by last_name
having count(*) > 1 ;

## Use table FILM_ACTOR to solve questions as below:
    select * from film_actor limit 10;
# 9.Count the number of actors in each film, order the result by the number of actors in descending order
select
    film_id,
    count(actor_id) as actor_number
from film_actor
group by film_id
order by actor_number DESC;


# 10.How many films do each actor play in?
select
    actor_id,
    count(film_id) as number_of_movies
from film_actor
group by actor_id
order by number_of_movies desc;

########################################################################################################################
#                        Exercise 2 (for after Day 4 Lecture):

# 1.Before doing any exercise, you should explore the data first.
    # -For Exercise 1, we will focus on the product, which is the film (DVD) in this project.
    # -Please explore the product-related tables (`actor, film_actor, film, language, film_category, category`) by using `SELECT *`
    # –Do not forget to limit the number of records;
select * from actor, film_actor, film, language, film_category, category limit 10;

# 2.Find language name for each film by using table Film and Language;
select * from film limit 10 ;
select * from language limit 10;

select
    film.film_id,
    film.title,
    language.name
from film
left join language
on film.language_id = language.language_id
order by film.film_id ;

# 3.In table `Film_actor`, there are `actor_id` and `film_id` columns. I want to know the actor name for each `actor_id`,
# and the film tile for each `film_id`.
# Hint: Use multiple table Inner Join
select * from film_actor;
select * from film;
select * from actor;

select
    film.film_id,
    film.title,
    actor.actor_id,
    actor.first_name,
    actor.last_name
from film
inner join film_actor on film.film_id = film_actor.film_id
left join actor on film_actor.actor_id = actor.actor_id
order by film.film_id;

# 4.In table Film, there is no category information. I want to know which category each film belongs to.
# Hint: use table `film_category` to find the category id for each film and then use table category to get the category name
select * from film ;
select * from film_category;
select * from category;

select
    film.film_id,
    film.title ,
    category.name
from film
inner join  film_category on film.film_id = film_category.film_id
left join category on category.category_id = film_category.category_id
order by film.film_id ;

# 5.Select films with `rental_rate` > 2 and then combine the results with films with ratings G, PG-13, or PG.
select * from film;

select
    film_id,
    title,
    rental_rate,
    rating
from film
where rental_rate > 2 or rating in ("G", "PG-13", "PG") ;

########################################################################################################################
#                                    Exercise 3:

# Let’s look at sales first:
# The rental table contains one row for each rental of each inventory item with information about
# who rented what item when it was rented, and when it was returned
# The rental table refers to the inventory, customer, and staff tables and is referred to by the payment table
# `Rental_id`: A surrogate primary key that uniquely identifies the rental

# 1.How many rentals (basically, the sales volume) happened from 2005-05 to 2005-08? Hint: use date between '2005-05-01' and '2005-08-31';
select * from rental;
select * from payment;

select
    count(rental_id) as rental_count
from rental
where rental_date between '2005-05-01'and '2005-08-31' ;

# 2.I want to see the rental volume by month. Hint: you need to use the substring function to create a month column, e.g.
select
    count(rental_id) as rental_volume ,
    substring(rental_date, 1, 7) as month
from rental
group by month
order by rental_volume desc ;

# 3.Rank the staff by total rental volumes for all time periods.
# I need the staff’s names, so you have to join with the staff table
select * from staff;
select * from rental;

select
    staff.staff_id,
    staff.first_name,
    staff.last_name,
    count(rental.rental_id) as rental_volume
from rental
left join staff on rental.staff_id = staff.staff_id
group by staff.staff_id
order by rental_volume desc;

## How about inventory?
# 4.Create the current inventory level report for each film in each store.
    # -The inventory table has the inventory information for each film at each store
    # - `inventory_id` - A surrogate primary key used to uniquely identify each item in inventory, so each inventory id means each available film.
select * from inventory;
select * from store;

select
    store_id,
    count(distinct(inventory_id) ) as inventory_level
from inventory
group by store_id;


# 5.When you show the inventory level to your manager, your manager definitely wants to know the film's name.
# Please add the film's name to the inventory report.
    # -Tile column in film table is the film name
    # -Should you use left join or inner join? – this depends on how you want to present your result to your manager,
    # so there is no right or wrong answer
    # -Which table should be your base table if you want to use left join?
select * from inventory;
select * from film;

select
    inventory.store_id,
    film.film_id,
    film.title,
    count(inventory.inventory_id) as count_inventorty
from film
left join inventory on film.film_id = inventory.film_id
group by inventory.store_id, film.film_id, film.title
order by inventory.store_id;

# 6.After you show the inventory level again to your manager, your manager still wants to know the category for each film.
# Please add the category for the inventory report.
    # -Name column in the category table is the category name
    # -You need to join film, category, inventory, and `film_category
select * from film limit 10 ;
select * from film_category limit 10;
select * from category limit 10;
select * from inventory limit 10;
select * from store limit 10 ;

select
    film.film_id,
    film.title,
    category.name,
    count(inventory.inventory_id) as count_inventory,
    store.store_id
from film
inner join film_category on film.film_id = film_category.film_id
left join category on category.category_id = film_category.category_id
left join inventory on inventory.film_id = film.film_id
left join store on inventory.store_id = store.store_id
group by  film.film_id, store.store_id, film.title
order by count_inventory, category.name, film.title;

# 7.Your manager is happy now, but you need to save the query result to a table,
# just in case your manager wants to check again, and you may need the table to do some analysis in the future.
    # Use the `CREATE` statement to create a table called `inventory_rep`
drop table if exists inventory_rep;

create table inventory_rep (
    film_id int,
    film_name varchar(60),
    category varchar(20),
    inventory int,
    store_id int
);

-- fill data into the table
insert into inventory_rep (film_id, film_name, category, inventory, store_id)
select
    film.film_id,
    film.title,
    category.name,
    count(inventory.inventory_id) as count_inventory,
    store.store_id
from film
inner join film_category on film.film_id = film_category.film_id
left join category on category.category_id = film_category.category_id
left join inventory on inventory.film_id = film.film_id
left join store on inventory.store_id = store.store_id
group by  film.film_id, store.store_id, film.title
order by count_inventory, category.name, film.title;

select * from inventory_rep limit 50;

# 8.Use your report to identify the film which is not available in any store,
# and the next step will be to notice the supply chain team add the film to the store

select
    film_id,
    film_name,
    category,
    inventory
from inventory_rep
where store_id is NULL
group by film_id
order by film_id ;

## Let’s look at Revenue:
    # -The payment table records each payment made by a customer,
    # with information such as the amount and the rental paid for.
    # Let us consider the payment amount as revenue and ignore the receivable revenue part
    # -`rental_id`: The rental that the payment is being applied.
    # This is optional because some payments are for outstanding fees
    # and may not be directly related to a rental – which means it can be null;

# 9.How much revenue was made from 2005-05 to 2005-08 by month?
select * from payment;

select
    sum(amount) as total_revenue ,
    substring(payment_date , 1, 7) as month
from payment
where payment_date between '2005-05-01' and '2005-08-31'
group by month
order by month;


# 10.How much revenue was made from 2005-05 to 2005-08 by each store?
select * from payment;
select * from inventory;
select * from rental;

select
    sum(payment.amount) as total_revenue ,
    substring(payment.payment_date , 1, 7) as month,
    inventory.store_id
from payment
inner join rental on rental.rental_id = payment.rental_id
inner join inventory on inventory.inventory_id = rental.inventory_id
where payment.payment_date between '2005-05-01' and '2005-08-31'
group by month, inventory.store_id
order by month, inventory.store_id;

# 11.Say the movie rental store wants to offer unpopular movies for sale to free up shelf space for newer ones.
# Help the store to identify unpopular movies by counting the number of rental times for each film.
# Provide the film id, film name, and category name so the store can also know which categories are not popular.
    # Hint: count how many times each film was checked out and rank the result by ascending order.
select * from rental; -- count rental id, group by inventory id
select * from inventory; -- get inventory id and film-id
select * from film_category; -- category id, and film id
select * from category; -- category id and category name
select * from film; -- film id , title

select
    film.film_id,
    film.title as movie_name ,
    category.name as category,
    count(rental.rental_id) as rental_times
from rental
inner join inventory on inventory.inventory_id = rental.inventory_id
inner join film_category on film_category.film_id = inventory.film_id
inner join category on category.category_id = film_category.category_id
inner join film on film.film_id = film_category.film_id
group by rental.inventory_id, -- group by this to see which inventory is not moving. (inventory level)
         film.film_id,
         category
order by rental_times;
