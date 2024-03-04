--Taylor Kramer
--Project 4

-------Statistics, aggregation, and grouping

--1) How many Slytherin students are there?
SELECT COUNT(house) AS slytherins FROM hogwarts_students WHERE house = 'Slytherin';
--2) What is the earliest start year of any student in our data?
SELECT min(start) FROM hogwarts_students;
--3) How many students have some missing information?
SELECT COUNT(*) AS missing_info FROM hogwarts_students WHERE last IS NULL or first IS NULL or house IS NULL or start IS NULL or finish IS NULL;
--4) How many Defense Against the Dark Arts (DADA) teachers have first names the same length as their last names?
SELECT COUNT(*) AS equal_name_lengths FROM hogwarts_dada WHERE LENGTH(last) = LENGTH(first);
--5) How many students are listed in each house (include the number who have no house listed as well; order by greatest number of students first)?
SELECT house, COUNT(*) AS number_of_students FROM hogwarts_students GROUP BY house ORDER BY number_of_students DESC;
--6) Which houses have more than 20 associated student records, and how many students are in those houses?
SELECT house, COUNT(*) AS number_of_students FROM hogwarts_students GROUP BY house HAVING COUNT(*) > 20 ORDER BY number_of_students DESC;
--7) By house, what was the average number of years spent at Hogwarts by students for whom we know both start and end years? Order by average number of years.
SELECT house, AVG(finish - start) AS average_time FROM hogwarts_students WHERE last IS NOT NULL AND first IS NOT NULL GROUP BY house ORDER BY average_time;
--8) Which family names (last names) appear exactly twice in the hogwarts_students table?
SELECT last AS lastname FROM hogwarts_students GROUP BY last HAVING COUNT(last) = 2;

-------Subqueries and/or complex joins

--9) What are the names, houses, and house colors of the Defense Against the Dark Arts teachers (you only need to worry about the teachers who also have student records)?
SELECT dada.first, dada.last, s.house, h.colors 
FROM hogwarts_dada AS dada, hogwarts_students AS s, hogwarts_houses AS h
WHERE dada.first = s.first AND dada.last = s.last AND s.house = h.house;
--10) Who is the earliest known student, and what year did they start?
SELECT first, last, start FROM hogwarts_students
WHERE start =
(SELECT MIN(start) FROM hogwarts_students);
--11) Which student has the shortest first name?
SELECT first, last FROM hogwarts_students
WHERE LENGTH(first) IN
(SELECT MIN(LENGTH(first)) FROM hogwarts_students);
--12) Who were the Gryffindors who would have had Dolores Umbridge as DADA teacher (assume all students take DADA, and all students are at school for the entire school year starting in Fall and ending in Spring, keeping in mind that each DADA teacher listed started in Fall and left the following Spring)?
SELECT s.first, s.last 
FROM hogwarts_students AS s, hogwarts_dada AS d 
WHERE s.start <= d.start AND s.finish >= d.finish AND s.house = 'Gryffindor' AND d.last = 'Umbridge';
--13) Which students have had other family members attend Hogwarts (assume anyone with the same last name is a family member)? Order by last name and first name.
SELECT e1.first, e1.last FROM hogwarts_students as e1
WHERE e1.last IN
(SELECT e2.last FROM hogwarts_students as e2
WHERE e2.first IS NOT NULL GROUP BY e2.last HAVING COUNT(e2.last) > 1) ORDER BY e1.last, e1.first;
--14) How many students of each house are known to have started the year that Alastor Moody was the appointed DADA teacher?
SELECT s.house, COUNT(*) FROM hogwarts_students AS s 
WHERE s.start =
(SELECT dada.start FROM hogwarts_dada AS dada
WHERE dada.last = 'Moody') AND s.house IS NOT NULL GROUP BY s.house;

-------Extra credit

--15) What student (last, first, house) started in the same year as, has the same length first and last names as, but a different house than, a student with initials "S. B." who was in a house with a Badger as its heraldic animal?

--some hot garbage: (but at least it's fire) 

SELECT s.last, s.first, s.house FROM hogwarts_students AS s
WHERE s.house IN
(SELECT h.house FROM hogwarts_houses AS h WHERE h.animal <> 'Badger') AND
LENGTH(s.first) =
(SELECT LENGTH(s6.first) FROM hogwarts_students AS s6, hogwarts_houses AS h6 WHERE s6.first LIKE 'S%' AND s6.last LIKE 'B%' AND h6.animal = 'Badger' AND s6.house = h6.house) AND
LENGTH(s.last) =
(SELECT LENGTH(s7.last) FROM hogwarts_students AS s7, hogwarts_houses AS h7 WHERE s7.first LIKE 'S%' AND s7.last LIKE 'B%' AND h7.animal = 'Badger' AND s7.house = h7.house) AND
s.start =
(SELECT s4.start FROM hogwarts_students AS s4, hogwarts_houses AS h2 WHERE s4.first LIKE 'S%' AND s4.last LIKE 'B%' AND h2.animal = 'Badger' AND s4.house = h2.house);