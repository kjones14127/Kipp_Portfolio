--Ats Status Elongated
create view dbo.cover_long as
 select g1.game_date, g1.is_home, t.abbreviation, g1.w_pct, bs.spread1, bs.spread2, 
 g1.wl, g1.pts, g2.pts as pts2, 
 g1.pts-g2.pts as pts_diff, g1.season_type,
case when abs(bs.spread2) =abs(g1.pts-g2.pts) then 'push'
 when ((g1.is_home = 't' and (abs(bs.spread2) between 0 and abs(g1.pts-g2.pts))and g1.wl = 'W') OR
 (g1.is_home = 't' and (abs(bs.spread2) not between 0 and abs(g1.pts-g2.pts)) and g1.wl = 'L') OR
 (g1.is_home = 't' and (abs(bs.spread2) > abs(g1.pts-g2.pts)) and g1.wl = 'W') OR
 (g1.is_home = 'f' and (abs(bs.spread1) between 0 and abs(g1.pts-g2.pts)) and g1.wl = 'W')) OR
 (g1.is_home = 'f' and (abs(bs.spread1) not between 0 and abs(g1.pts-g2.pts)) and g1.wl = 'L') OR 
 (g1.is_home = 'f' and (abs(bs.spread1) > abs(g1.pts-g2.pts)) and g1.wl = 'W') then 'cover' 
   else 'loss' end as CoverStatus
 from nba_betting_spread bs
	inner join nba_games_all g1
	on bs.game_id=g1.game_id
	 inner join nba_games_all g2 on g1.game_id = g2.game_id
	 and g1.team_id =g2.a_team_id
	 inner join nba_teams_all t on
	t.team_id=g1.team_id
	 join nba_teams_all t1 on
	t1.team_id=g1.a_team_id
	where g1.game_date between '2016-02-15' and '2016-08-31'
	and g1.season = '2015-16'
	and g1.team_id IN ('1610612762','1610612760','1610612757','1610612750','1610612743',
	 '1610612746','1610612747','1610612756','1610612744','1610612758',
	 '1610612759', '1610612745', '1610612742', '1610612763','1610612740','1610612738',
	 '1610612752','1610612751','1610612755','1610612761',
	 '1610612749','1610612754','1610612765','1610612741','1610612739',
	 '1610612766','1610612737','1610612748','1610612753','1610612764')
	and g1.season_type = 'Regular Season'
	and bs.book_name = 'Bovada' 
	--order by t.abbreviation, CoverStatus, g1.game_date asc

--money line status elongated
select ml.game_id, g1.game_date, g1.is_home, t.abbreviation, g1.w_pct, ml.price1, t1.abbreviation, ml.price2, g1.wl, g1.pts, g2.pts, 
 g1.pts-g2.pts as pts_diff, case when (g1.is_home = 't' and ml.price2 < 0 and g1.wl ='W') OR 
 (g1.is_home = 'f' and ml.price1 < 0 and g1.wl ='W' ) 
 then 'MoneyLine Win' else 'MoneyLine Loss' end as MoneyLineStatus
 from nba_betting_money_line ml
	inner join nba_games_all g1
	on ml.game_id=g1.game_id
	 inner join nba_games_all g2 on g1.game_id = g2.game_id
	 and g1.team_id =g2.a_team_id
	 inner join nba_teams_all t on
	t.team_id=g1.team_id
	 join nba_teams_all t1 on
	t1.team_id=g1.a_team_id
	where g1.game_date between '2016-02-15' and '2016-08-31'
	and g1.team_id IN ('1610612762','1610612760','1610612757','1610612750','1610612743',
	 '1610612746','1610612747','1610612756','1610612744','1610612758',
	 '1610612759', '1610612745', '1610612742', '1610612763','1610612740','1610612738',
	 '1610612752','1610612751','1610612755','1610612761',
	 '1610612749','1610612754','1610612765','1610612741','1610612739',
	 '1610612766','1610612737','1610612748','1610612753','1610612764')
	and g1.season_type = 'Regular Season'
	and ml.book_name = 'Bovada' 
    order by t.abbreviation, g1.season_year, g1.game_date asc
 
 --alter table nba_betting_spread alter column spread2 float

 --ATS Record Only & Cover Percentage
 --create view dbo.ATS_Rec as
 select t.abbreviation,
	count(case when abs(bs.spread2) =abs(g1.pts-g2.pts) then 'push' end) as push,
 count(case when ((g1.is_home = 't' and (abs(bs.spread2) between 0 and abs(g1.pts-g2.pts))and g1.wl = 'W') OR
 (g1.is_home = 't' and (abs(bs.spread2) not between 0 and abs(g1.pts-g2.pts)) and g1.wl = 'L') OR
 (g1.is_home = 't' and (abs(bs.spread2) > abs(g1.pts-g2.pts)) and g1.wl = 'W') OR
 (g1.is_home = 'f' and (abs(bs.spread1) between 0 and abs(g1.pts-g2.pts)) and g1.wl = 'W')) OR
 (g1.is_home = 'f' and (abs(bs.spread1) not between 0 and abs(g1.pts-g2.pts)) and g1.wl = 'L') OR 
 (g1.is_home = 'f' and (abs(bs.spread1) > abs(g1.pts-g2.pts)) and g1.wl = 'W') then 'cover' end) as cover,
round(cast(count(case when ((g1.is_home = 't' and (abs(bs.spread2) between 0 and abs(g1.pts-g2.pts))and g1.wl = 'W') OR
 (g1.is_home = 't' and (abs(bs.spread2) not between 0 and abs(g1.pts-g2.pts)) and g1.wl = 'L') OR
 (g1.is_home = 't' and (abs(bs.spread2) > abs(g1.pts-g2.pts)) and g1.wl = 'W') OR
 (g1.is_home = 'f' and (abs(bs.spread1) between 0 and abs(g1.pts-g2.pts)) and g1.wl = 'W')) OR
 (g1.is_home = 'f' and (abs(bs.spread1) not between 0 and abs(g1.pts-g2.pts)) and g1.wl = 'L') OR 
 (g1.is_home = 'f' and (abs(bs.spread1) > abs(g1.pts-g2.pts)) and g1.wl = 'W') then 'cover' end) as float)/cast(count(g1.game_id) as float),2)*100 as Cover_Percentage
 from nba_betting_spread bs
	inner join nba_games_all g1
	on bs.game_id=g1.game_id
	 inner join nba_games_all g2 on g1.game_id = g2.game_id
	 and g1.team_id =g2.a_team_id
	 inner join nba_teams_all t on
	t.team_id=g1.team_id
	 join nba_teams_all t1 on
	t1.team_id=g1.a_team_id
	where g1.game_date between '2016-02-15' and '2016-08-31'
	and g1.season = '2015-16'
	and g1.team_id IN ('1610612762','1610612760','1610612757','1610612750','1610612743',
	 '1610612746','1610612747','1610612756','1610612744','1610612758',
	 '1610612759', '1610612745', '1610612742', '1610612763','1610612740','1610612738',
	 '1610612752','1610612751','1610612755','1610612761',
	 '1610612749','1610612754','1610612765','1610612741','1610612739',
	 '1610612766','1610612737','1610612748','1610612753','1610612764')
	and g1.season_type = 'Regular Season'
	and bs.book_name = 'Bovada' 
	group by t.abbreviation
	--order by t.abbreviation asc

	--win_pct up until allstar break
	--create view dbo.Win_pct as
	(select t.abbreviation, avg(w_pct) from nba_games_all g1 inner join nba_teams_all t on
	t.team_id=g1.team_id where game_date between '2016-02-08' and '2016-02-15'
	and season IN ('2015-16') and season_type IN  ('Regular Season') group by t.abbreviation )A
	
		--ending season win_pct
			--create view dbo.End_Win_pct as
	(select t.abbreviation, avg(w_pct) from nba_games_all g1 inner join nba_teams_all t on
	t.team_id=g1.team_id where game_date between '2016-04-12' and '2016-04-15'
	and season IN ('2015-16') and season_type IN  ('Regular Season') group by t.abbreviation)B

	--joined queries of win_pct after allstar and end of season
	create view dbo.Win_pct_diff as
	select A.*, B.*, A.mid_win_pct-B.end_win_pct as dif
  from 	(select t.abbreviation, avg(w_pct) as mid_win_pct from nba_games_all g1 inner join nba_teams_all t on
	t.team_id=g1.team_id where game_date between '2016-02-08' and '2016-02-15'
	and season IN ('2015-16') and season_type IN  ('Regular Season') group by t.abbreviation ) A
  full outer join (select t.abbreviation as abb, avg(w_pct) as end_win_pct from nba_games_all g1 inner join nba_teams_all t on
	t.team_id=g1.team_id where game_date between '2016-04-12' and '2016-04-15'
	and season IN ('2015-16') and season_type IN  ('Regular Season') group by t.abbreviation)B
    on A.abbreviation = B.abb

	--playoff teams
		create view dbo.playoff_teams as
	select t.abbreviation from nba_games_all g1 inner join nba_teams_all t on
	t.team_id=g1.team_id where game_date between '2016-04-15' and '2016-04-17'
	and season IN ('2015-16') and season_type IN  ('Playoffs') group by t.abbreviation  

	--win pct after all star break
	select game_date, t.abbreviation, w_pct from nba_games_all g1 inner join nba_teams_all t on
	t.team_id=g1.team_id 
	where g1.game_date between '2016-02-15' and '2016-08-31'
	and g1.season = '2015-16' and season_type IN  ('Regular Season')
	order by t.abbreviation asc

--Tables
select * from nba_games_all
select * from nba_betting_money_line
select * from nba_betting_spread
select * from nba_teams_all

 
 
 



 


 

 