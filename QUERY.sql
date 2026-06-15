-- user table

create type userrole as enum(
  'Ticket Manager',
  'Football Fan'
);

create table users(
  user_id serial primary key,
  full_name varchar(70),
  email varchar(50) not null unique,
  role userrole not null,
  phone_number varchar(30)
);

-- match table

create type tournament_category_type as enum(
  'Champions League',
  'Premier League',
  'Serie A'
);

create type match_status_type as enum(
  'Available',
  'Selling Fast',
  'Sold Out',
  'Postponed'
);

create table matches (
  match_id int primary key,
  fixture varchar(250) not null,
  tournament_category tournament_category_type not null,
  base_ticket_price numeric(10,2) not null check (base_ticket_price >= 0),
  match_status match_status_type not null
);

-- booking table
create type payment_status_type as enum(
  'Pending',
  'Confirmed',
  'Cancelled',
  'Refunded'
);

create table bookings (
  booking_id int primary key,
  user_id int not null,
  match_id int not null,
  seat_number varchar(250),
  payment_status payment_status_type,
  total_cost numeric(10,2) not null check (total_cost >= 0),

  constraint fk_user foreign key (user_id) references users(user_id),
  constraint fk_match foreign key (match_id) references matches(match_id),
  constraint uq_booking unique (user_id, match_id, seat_number)
);

insert into users (user_id, full_name, email, role, phone_number) values
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', null);


insert into matches (match_id, fixture, tournament_category, base_ticket_price, match_status) values
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');


insert into bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) values
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, null, null, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);


select match_id, fixture, base_ticket_price
from matches
where tournament_category = 'Champions League'
  and match_status = 'Available'
order by match_id;


select user_id, full_name, email
from users
where full_name ilike 'Tanvir%'
   or full_name ilike '%Haque%'
order by user_id;


select booking_id, user_id, match_id,
       coalesce(payment_status, 'Action Required') as systematic_status
from bookings
where payment_status is null;


select b.booking_id, u.full_name, m.fixture, b.total_cost
from bookings b
join users u on b.user_id = u.user_id
join matches m on b.match_id = m.match_id
order by b.booking_id;


select u.user_id, u.full_name, b.booking_id
from users u
left join bookings b on u.user_id = b.user_id
order by u.user_id, b.booking_id;


select booking_id, match_id, total_cost
from bookings
where total_cost > (select avg(total_cost) from bookings)
order by booking_id;


select match_id, fixture, base_ticket_price
from matches
order by base_ticket_price desc
offset 1
limit 2;
