with a as (
select *
from [dbo].[Course]
)
, b as (
select * 
from [dbo].[CourseInstructor]
)
, c as (
select *
from [dbo].[Person]
) 
, d as (
select 
a.*
, b.PersonID
from a 
join b 
on a.CourseID = b.CourseID
)
select 
d.Title
,d.Credits
,c.LastName
,c.FirstName
,c.HireDate
,c.Discriminator
from d
join c 
on  d.PersonID = c.PersonID