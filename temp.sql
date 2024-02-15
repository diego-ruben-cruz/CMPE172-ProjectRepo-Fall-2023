-- Practice Question 1
SELECT employeeID,
    FirstName,
    LastName,
    CASE
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 80000 THEN 'Medium'
        WHEN Salary > 80000 THEN 'High'
    END AS SalaryGrade
FROM Employees;
-- Practice Question 2
SELECT EmployeeID,
    FirstName,
    LastName,
    CASE
        WHEN LEFT(LastName, 1) = 'A' THEN 1000
        WHEN LEFT(LastName, 1) = 'B' THEN 800
        ELSE 500
    END AS Bonus
FROM Employees;
-- Practice Question 3
SELECT EmployeeID,
    FirstName,
    LastName,
    CASE
        WHEN startDate < 2000 THEN 'Long'
        WHEN startDate BETWEEN 2000 AND 2010 THEN 'Medium'
        WHEN startDate > 2010 THEN 'Short'
    END AS Tenure
FROM Employees;