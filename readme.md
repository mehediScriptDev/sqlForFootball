# Football Ticket Booking System — SQL Database

A relational PostgreSQL schema and example queries for managing football match ticket bookings. The project models users (fans and staff), matches, and bookings, and ships a small set of reporting queries used in the assignment.

Contents
- `QUERY.sql` — schema (types + tables), sample seed data, and seven example queries. This file targets PostgreSQL.
- `archive/` — archived copies of files moved out of the root for a minimal repository layout (ERD source, original schema, theory answers, instructions).

Tech stack
- PostgreSQL (uses ENUM types, `ILIKE`, `LEFT JOIN`, `OFFSET .. LIMIT`, scalar subqueries)

Schema overview (short)
- Tables: `users`, `matches`, `bookings`.
- Custom ENUM types: `userrole`, `tournament_category_type`, `match_status_type`, `payment_status_type`.
- Key relationships: `users (1) -> bookings (many)` and `matches (1) -> bookings (many)`. `bookings` links a single user to a single match (one booking per row).

Sample data
- The script seeds 4 users, 5 matches, and 5 bookings. Some bookings intentionally include `NULL` for `seat_number` or `payment_status` to show null-handling in queries.

Queries included (what they demonstrate)
1. Available Champions League matches — `WHERE` with multiple conditions
2. Name search (`Tanvir%` or contains `Haque`) — case-insensitive matching with `ILIKE`
3. Bookings missing payment status — `IS NULL` and `COALESCE` to label `Action Required`
4. Booking details joined to users and matches — `INNER JOIN`
5. All users and booking IDs — `LEFT JOIN` to include users with no bookings
6. Bookings costing more than the average — scalar subquery with `AVG()`
7. Top 2 matches skipping the highest — `ORDER BY` + `OFFSET`/`LIMIT`

How to run (quick)

1) Create a local database and run the SQL file (macOS / zsh):

```bash
createdb football_test
psql -d football_test -f QUERY.sql
```

2) To run queries interactively (from `psql`) after loading data:

```bash
psql -d football_test
\i QUERY.sql
```

Notes & tips
- `QUERY.sql` is written for PostgreSQL. If you use MySQL or SQLite you will need to convert ENUMs and possibly the numeric type syntax.
- Money fields use `numeric(10,2)` for precision.
- If you prefer the full set of files (ERD, theory answers, archived schema) restored to the project root, I can restore any of them on request.

Next actions I can take for you
- Add short inline comments to each query in `QUERY.sql` to make it more beginner-friendly.
- Render `archive/erd.puml` to `erd.png` and add it to the repository.
- Commit and push the current changes to your GitHub remote (I will show the git commands before running them).

If you'd like any of the above, tell me which one to do next.

---------------------------------

## Project Summary (Requested Format)

Football Ticket Booking System — SQL Database

A relational database for managing football match ticket bookings. It models the people who use the platform (`Users`), the matches that tickets are sold for (`Matches`), and the bookings that connect them (`Bookings`). The project also ships a set of sample queries that demonstrate common reporting and lookup tasks.

Tech Stack
- PostgreSQL — uses Postgres-specific features such as ENUM types, `ILIKE` (case-insensitive matching), `LEFT JOIN`, and `OFFSET ... LIMIT`.

Schema Overview
The database contains three tables and several custom ENUM types.

Custom Types (ENUMs)

| Type | Allowed Values |
|---|---|
| `userrole` | `Ticket Manager`, `Football Fan` |
| `tournament_category_type` | `Champions League`, `Premier League`, `Serie A` |
| `match_status_type` | `Available`, `Selling Fast`, `Sold Out`, `Postponed` |
| `payment_status_type` | `Pending`, `Confirmed`, `Cancelled`, `Refunded` |

Users
Stores everyone who interacts with the platform.

| Column | Type | Constraints |
|---|---|---|
| `user_id` | INT | Primary key |
| `full_name` | varchar(100) | Not null |
| `email` | varchar(100) | Unique, not null |
| `role` | `userrole` | Not null |
| `phone_number` | varchar(15) | Nullable |

Matches
Stores the matches that tickets are sold for.

| Column | Type | Constraints |
|---|---|---|
| `match_id` | INT | Primary key |
| `fixture` | varchar(250) | Not null |
| `tournament_category` | `tournament_category_type` | Not null |
| `base_ticket_price` | INT | Not null, >= 0 |
| `match_status` | `match_status_type` | Not null |

Bookings
Links a user to a match they have booked a seat for.

| Column | Type | Constraints |
|---|---|---|
| `booking_id` | INT | Primary key |
| `user_id` | INT | Not null, FK → `users(user_id)` |
| `match_id` | INT | Not null, FK → `matches(match_id)` |
| `seat_number` | varchar(250) | Nullable |
| `payment_status` | `payment_status_type` | Nullable |
| `total_cost` | INT | Not null, >= 0 |

Constraints

- `fk_user` — foreign key on `user_id` referencing `users(user_id)`.
- `fk_match` — foreign key on `match_id` referencing `matches(match_id)`.
- `uq_booking` — composite unique constraint on (`user_id`, `match_id`, `seat_number`), ensuring one seat per user per match.

Entity Relationships

- A User can have many Bookings (one-to-many).
- A Match can have many Bookings (one-to-many).
- Bookings is the junction table linking Users and Matches.

Users (1) ───< Bookings >─── (1) Matches

Sample Data

The script seeds the tables with sample rows: 4 users, 5 matches, and 5 bookings. Some bookings intentionally have a `NULL` `payment_status` / `seat_number` to demonstrate handling of missing values.

Queries
The script includes seven example queries.

| # | Purpose | Key Concepts |
|---:|---|---|
| 1 | List Available Champions League matches | `WHERE` with multiple conditions |
| 2 | Find users whose name starts with `Tanvir` or contains `Haque` | `ILIKE`, `OR` |
| 3 | Show bookings with missing payment status, labelled `Action Required` | `COALESCE`, `IS NULL` |
| 4 | Booking details with user name and match fixture | `INNER JOIN` |
| 5 | All users with their booking IDs, including users with none | `LEFT JOIN` |
| 6 | Bookings costing more than the average booking | Scalar subquery, `AVG()` |
| 7 | Top 2 most expensive matches, skipping the single most expensive | `ORDER BY`, `OFFSET`, `LIMIT` |

Files

- `QUERY.sql` — schema definitions, sample data, and example queries.


flow: https://lucid.app/lucidchart/944b7569-299d-409f-9a69-f22023fef040/edit?viewport_loc=1151%2C543%2C2500%2C1439%2C0_0&invitationId=inv_e6e1b88b-2bbf-4d55-9014-ae57a29edbe8
