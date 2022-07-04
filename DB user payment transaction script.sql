
-- transactions --
-- fulfilling a ticket -- add payment details then customer details, decrement the available seats

START transaction;
INSERT INTO Payment (CardDetails, PaymentDate, PaymentAmount) VALUES("1111222233334444", curdate(), 4000); 
-- inserts customer payment details ** TAKES USER PAYMENT DETAILS

INSERT INTO Customer (fname, lname, Email, Address,PaymentID) VALUES ("Jonathan", "Doenathon", "JoDo@email.com", "30 Oliver Dr", 3); 
-- inserts customer details ** TAKES USER DETAILS AND FK IS UPDATED MANUALLY (?)


-- selects the performance ID for seats to be removed from  ** needs user input to get this data [title, date and time]
--  -- changes amount of tickets available for specific show by changing seat numbers - had to use alias for subquery but the check query below confirms works

UPDATE Performance 
SET 
    NumberOfSeatsCircle = (NumberOFSeatsCircle - 1)
WHERE
    Performance.PerformanceID =
     (SELECT * FROM (SELECT 
            PerformanceID as SeatChange
        FROM
            Performance
                JOIN
            Showing ON Showing.ShowID = Performance.ShowingID
        WHERE
            Showing.Title = 'Mamma Mia'
                AND Performance.pdate = '2022-07-13'
                AND Performance.ptime = 'Matinee') AS P);  
-- TICKET DETAILS ** TAKES USERS INPUT FOR HOW MANY TICKETS REQUIRED. Cost (SHOULD BE RELABELLED TOTAL COST) can be calculated as price of ticket (script above) multiplied by number of tickets.

ROLLBACK; -- change to commit


-- select specific show at specific date and time (used in query to decrease value of seats) NumberOfSeatsCircle added to check transaction query success.
SELECT 
    PerformanceID, NumberOfSeatsCircle
FROM
    Performance
        JOIN
    Showing ON Showing.ShowID = Performance.ShowingID
WHERE
    Showing.Title = 'Mamma Mia'
        AND Performance.pdate = '2022-07-13'
        AND Performance.ptime = 'Matinee'; 



-- stored procedure for seat availability 4.7.22 AN; if show title/user request Showing.Title is variable, NumberOfSeatsCircle can also be changed for stalls equivilent. 

DELIMITER $$

CREATE PROCEDURE UpdateSeats2()
BEGIN
UPDATE Performance
SET 
NumberOfSeatsCircle = (NumberOfSeatsCircle - 1) 
WHERE 
  PerformanceID = (SELECT 
            *
        FROM
            (SELECT 
                PerformanceID
            FROM
                Performance
            JOIN Showing ON Showing.ShowID = Performance.PerformanceID
            WHERE
                Showing.Title = 'Mamma Mia') AS idfinder) -- Showing.Title to be changed by UI
                AND 
                NumberOfSeatsCircle > 0;
        
        IF 'NumberOfSeatsCircle' < 0 THEN 
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'no more seats'; -- throws return message "Error Code: 1644 no more seats' once seats < 0 
END IF;
END$$
DELIMITER ;

