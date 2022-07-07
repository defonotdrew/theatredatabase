-- finding information on all current shows ---
SELECT 
    Title,
    Duration AS RunTimeMinutes,
    Lang AS Language,
    Info AS Description,
    ShowType.Genre AS Genre
FROM
    Showing
        JOIN
    ShowType ON Showing.ShowTypeID = ShowType.ShowTypeID;


-- finding information on specific show--
SELECT 
    Title,
    Duration AS RunTimeMinutes,
    Lang AS Language,
    Info AS Description
FROM
    Showing
WHERE
    Title = 'Mamma Mia';
-- change title to user input --

-- gets the all available seats/ tickets for a show (cheapest tickets, will let you see what you can say 'prices from £x) 
-- ** GETS AVAILABILITY FOR A SHOW BASED OFF OF TITLE AND DATE INPUT
SELECT 
    Showing.Title,
    SeatZone,
    NumberOfSeats,
    Seat.Price AS PricePence
FROM
    Performance
        JOIN
    Showing ON Showing.ShowingID = Performance.ShowingID
        JOIN
    Seat ON Seat.PerformanceID = Performance.PerformanceID
WHERE
    Showing.Title = 'Mamma Mia'
        AND Performance.pdate = '22-07-13'
        AND SeatZone = 'Circle';
-- change title and performance dates with userinput requests




-- TB gets the Performance information and the pricing and availability for the seating zones (base prices)

SELECT
	Performance.PerformanceID,
	Performance.ShowingID,
	pdate,
	ptime,
    A.NumberOfSeats AS StallSeats,
    A.Price AS StallPricePence,
    B.NumberOfSeats AS CircleSeats,
    B.Price AS CirclePricePence
FROM
    Performance
        JOIN
    Seat AS A ON A.PerformanceID = Performance.PerformanceID
        JOIN
    Seat AS B ON B.PerformanceID = Performance.PerformanceID
WHERE
	A.SeatZone = "stalls"
	AND
	B.SeatZone = "circle";


SELECT 
    Title
FROM
    Showing
        JOIN
    Performance ON Showing.ShowingID = Performance.ShowingID
WHERE
    pdate = '2022-07-13';


-- finding todays shows
SELECT 
    Title
FROM
    Showing
        JOIN
    Performance ON Showing.ShowingID = Performance.ShowingID
WHERE
    pdate = CURDATE();


-- finding all dates for a certain show
SELECT 
    pdate
FROM
    Performance
        JOIN
    Showing ON Showing.ShowingID = Performance.ShowingID
WHERE
    Title = 'Mamma Mia'; 


-- get receipt -- i.e. return ticket information, ticketID, Number of tickets. cost, shows -- IF PAYMENT SUCCEEDS can use an adaption 
-- of this script to get specific tickets and get necessary data related to it - possibility to make multiple purchases by creating more tickets and
-- adding them all into the checkout basket.  
SELECT 
    BookingID,
    NumberOfAdults as AdultTickets,
    NumberOfChildren as ChildTickets,
    TotalCost,
    Showing.Title AS Title,
    Performance.pdate AS Date,
    Performance.ptime AS Time
FROM
    Booking
        JOIN
    Seat ON Seat.SeatID = Booking.SeatID
        JOIN
    Performance ON Seat.PerformanceID = Performance.PerformanceID
    JOIN
    Showing ON Performance.ShowingID = Showing.ShowingID;
