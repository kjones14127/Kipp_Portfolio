--alter table Batting alter column GIDP int

--Left Join w/ Subquery
select p.*, nameLast+', '+nameFirst as full_name, b.*
from people p
join (select playerID, yearID, sum(G) as G, sum(AB) AB, sum(R) R, sum(H) H, sum(B2) B2, sum(B3) B3, sum(HR) HR, 
sum(RBI) RBI, sum(SB) SB, sum(CS) CS, sum(BB) BB, sum(SO) SO, sum(IBB) IBB, sum(HBP) HBP, sum(SH) SH, sum(SF) SF, 
sum(GIDP) GIDP
from batting b
where G >= 50
group by playerID, yearID ) b
ON p.playerID=b.playerID
where deathyear is null 
and finalGame >= '1/1/2021'
order by finalGame asc

select * from people
select * from batting

update People
set deathYear = NULL
where deathyear = ''
 
 --alter table Batting alter column G int
 --alter table people add DOB date
 alter table people alter column finalGame varchar