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