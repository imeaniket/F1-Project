use f1_proj;
select year, name, date from races
order by date desc;

###########################///////////////////////////////////#######################################

SELECT 
    r.name, COUNT(*) AS number_of_races, location
FROM
    races r
        JOIN
    circuits c ON r.circuit_id = c.circuitid
GROUP BY Name
ORDER BY number_of_races DESC;

###########################///////////////////////////////////#######################################

######################/////Races Participated //////////////////////////////


SELECT 
    dr.full_name, COUNT(ds.driver_id) AS Participated
FROM
    driverstandings AS ds
        JOIN
    drivers AS dr ON ds.driver_id = dr.driver_id
GROUP BY ds.driver_id
ORDER BY Participated desc;


#/Number of wins by Driver////////////////------------------------------------------

SELECT 
    full_name, COUNT(full_name) AS total_wins, dr.driver_id
FROM
    driverstandings AS ds
        JOIN
    drivers dr ON ds.driver_id = dr.driver_id
WHERE
    position = 1
GROUP BY full_name
ORDER BY total_wins DESC;

#### Nationality wise standings #######################///////////////////////////////////#######################################

SELECT 
	Name, Nationality, COUNT(name) AS Wins
FROM
    constructorstandings AS cs
        JOIN
    constructors AS c ON cs.Constructor_id = c.Constructor_id
WHERE
    position = 1
GROUP BY name
ORDER BY Wins DESC;



###########///////////////////////////

SELECT 
	Race_id, ds.driver_id, d.Full_name,
	CONCAT(ROUND((points/SUM(points) 
		OVER (PARTITION BY race_id) * 100),2), '%') AS Percentage_of_points_scored
FROM driverstandings 
	AS ds	
JOIN 
	drivers d
ON 
	ds.driver_id = d.driver_id
where race_id = 355;


#use a CTE to calculate the number of races each driver participated in and the number of races they finished in the top 5. 
#Then, use this CTE to find drivers with the highest percentage of top 10 finishes.
#////////---------------------------------------


WITH races_participated AS 
	(
		SELECT dr.full_name, count(ds.driver_id) AS Participated
			FROM driverstandings AS ds
		JOIN drivers AS dr
		ON ds.driver_id = dr.driver_id
		GROUP BY ds.driver_id
),
top_5 AS 
	(
		SELECT full_name, count(ds.driver_id) AS Times_in_top_5
			FROM driverstandings AS ds
		JOIN drivers AS dr
		ON ds.driver_id = dr.driver_id
		WHERE position >= 1 AND position <= 5
		GROUP BY ds.driver_id
)

SELECT 
    t.Full_name,
    rp.Participated,
    t.Times_in_top_5,
    (ROUND((t.times_in_top_5 / rp.participated * 100),
            2)) AS Win_percentage
FROM
    races_participated AS rp
        JOIN
    top_5 AS t ON rp.full_name = t.full_name
ORDER BY Win_percentage DESC;


##########################////race wise winners ///////////////////////////////////


SELECT year, name, full_name
FROM
    races rs
        JOIN
    driverstandings ds ON rs.Raceid = ds.race_id
        JOIN
    drivers d ON d.driver_id = ds.driver_id
WHERE
    position = 1

order by year
;

##########################Schumacher races won over years ##########.....////////////////.........................

with cu as (select year, name, ds.driver_id, d.full_name
from races rs
join driverstandings ds
on rs.Raceid = ds.race_id
join drivers d
on d.driver_id = ds.driver_id
where position = 1
)
select dense_rank() over(partition by full_name order by count(name) desc) as Positioned_Rank, name, count(name) as Races_won
from cu
where full_name = 'Michael Schumacher'
group by name



