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