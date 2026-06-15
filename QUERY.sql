-- user table

create type userRole as enum(
    'Ticket Manager',
    'Football Fan'
);

create table users(
user_id	serial primary key,
full_name varchar(70),
email varchar(50) not null unique,
role userRole not null,
phone_number varchar(11)
)

-- match table

create type tournament_category_type AS enum(
  'Champions League', 
  'Premier League', 
  'Serie A'
  );


CREATE TYPE match_status_type AS enum(
  'Available',
  'Selling Fast',
  'Sold Out',
  'Postponed'
);


CREATE TABLE Matches (
  match_id INT PRIMARY KEY,
  fixture varchar(250) NOT NULL,
  tournament_category tournament_category_type NOT NULL,
  base_ticket_price INT NOT NULL CHECK (base_ticket_price >= 0),
  match_status match_status_type NOT NULL
);

-- booking table 
CREATE TYPE payment_status_type AS enum(
  'Pending',
  'Confirmed',
  'Cancelled',
  'Refunded'
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    match_id INT NOT NULL,
    seat_number varchar(250),
    payment_status payment_status_type,
    total_cost INT NOT NULL CHECK (total_cost >= 0),
  

    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES Users(user_id),


    CONSTRAINT fk_match FOREIGN KEY (match_id) REFERENCES Matches(match_id),


    CONSTRAINT uq_booking UNIQUE (user_id, match_id, seat_number)
);

INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);



INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');



INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);




SELECT match_id, fixture, base_ticket_price
FROM matches
WHERE tournament_category = 'Champions League'
  AND match_status = 'Available'
ORDER BY match_id;


SELECT user_id, full_name, email
FROM users
WHERE full_name ILIKE 'Tanvir%'
   OR full_name ILIKE '%Haque%'
ORDER BY user_id;


SELECT booking_id, user_id, match_id,
       COALESCE(payment_status, 'Action Required') AS systematic_status
FROM bookings
WHERE payment_status IS NULL;


SELECT b.booking_id, u.full_name, m.fixture, b.total_cost
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN matches m ON b.match_id = m.match_id
ORDER BY b.booking_id;


SELECT u.user_id, u.full_name, b.booking_id
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
ORDER BY u.user_id, b.booking_id;


SELECT booking_id, match_id, total_cost
FROM bookings
WHERE total_cost > (SELECT AVG(total_cost) FROM bookings)
ORDER BY booking_id;


SELECT match_id, fixture, base_ticket_price
FROM matches
ORDER BY base_ticket_price DESC
OFFSET 1
LIMIT 2;
