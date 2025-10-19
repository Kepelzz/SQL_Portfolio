select *
from all_seasons
limit 10;

-- Ranking players in each season by points, rebounds, assists per game.
select 
player_name,
season,
pts,
rank() over(partition by season order by pts desc) as pts_rank,
rank() over(partition by season order by reb desc) as reb_rank,
rank() over(partition by season order by ast desc) as ast_rank
from all_seasons
limit 10;

-- Comparing efficiency stats (TS% vs usage%) - do volume scorers sacrifice efficiency?
-- cleaning up outliers
select 
    season,
    avg(usg_pct) as avg_usage,
    avg(ts_pct) as avg_efficiency
FROM all_seasons
group by season;

-- Doing simple relationship check
select 
    season,
    case
        when usg_pct < 0.15 then 'Low usage'
        when usg_pct between 0.15 and 0.25 then 'Medium usage' 
        else 'High usage'
    end as usage_tier,
    avg(ts_pct) as avg_ts
from all_seasons
where gp > 20
group by season, usage_tier
order by season, usage_tier;

-- grouping players into usage percentiles 
with rankings as (
select 
    season,
    player_name,
    usg_pct,
    ts_pct,
    NTILE(10) over(partition by season order by usg_pct) as usage_decile
    from all_seasons
    where gp > 20
)
select 
    season, 
    usage_decile,
    avg(usg_pct) as avg_usage,
    avg(ts_pct) as avg_ts
from rankings
group by season, usage_decile
order by season, usage_decile;

-- Insights: Contrary to the “volume scorers sacrifice efficiency” hypothesis, players with very high usage (~28%) actually have higher average TS% (≈0.55) than low-usage players (~0.52).
-- Mid-usage players (around 15–20%) don’t gain much
-- Low-usage players (bottom deciles) are less efficient


-- Identifying most improved players across seasons (biggest jump in points/rebounds/assists)
select 
    player_name,
    season,
    lag(pts) over(partition by player_name order by season) as pts_diff,
    lag(reb) over(partition by player_name order by season) as reb_diff,
    lag(ast) over(partition by player_name order by season) as ast_diff
from all_seasons;

-- Observations:
-- Skylar Mays had one of the biggest jumps in modern data, i.e. From almost no playing time in 2021–22 to strong production in 2022–23.
-- He went from a bench/depth player to a rotation-level starter. His leap in true shooting (TS%) also shows efficiency improved, not just volume.

-- Players like Derrick Walton, Kendall Marshall and Brevin Knight saw their biggest improvements in assists (+5–6 APG) rather than points.
-- That’s typical of guards who move from backup to starting point guard: the usage and playmaking load skyrockets.

-- Comparing average player size (height/weight) between 1990s, 2000s, 2010s, and 2020s.
SELECT 
    CASE
        WHEN LEFT(season, 4) BETWEEN '1990' AND '1999' THEN '1990s'
        WHEN LEFT(season, 4) BETWEEN '2000' AND '2009' THEN '2000s'
        WHEN LEFT(season, 4) BETWEEN '2010' AND '2019' THEN '2010s'
        WHEN LEFT(season, 4) BETWEEN '2020' AND '2029' THEN '2020s'
    END AS decade,
    AVG(player_height) AS avg_height,
    AVG(player_weight) AS avg_weight
FROM all_seasons
GROUP BY decade
ORDER BY decade;

-- Insights:
-- Heights stayed roughly stable, that is around 200 cm average. The NBA already had tall players by the ’90s.
-- Weights peaked in the 2000s, as the league favored big men and physical play.
-- 2020s show leaner builds, reflecting a shift toward speed, agility, and shooting over post-dominance.


-- Identifying which teams consistently produce top-performing players.
WITH ranked AS (
  SELECT 
      season,
      team_abbreviation,
      player_name,
      pts,
      RANK() OVER (PARTITION BY season ORDER BY pts DESC) AS pts_rank,
      reb,
      RANK() OVER (PARTITION BY season ORDER BY reb DESC) AS reb_rank,
      ast,
      RANK() OVER (PARTITION BY season ORDER BY ast DESC) AS ast_rank
  FROM all_seasons
), top_players AS (
  SELECT 
      season,
      team_abbreviation,
      player_name
  FROM ranked
  WHERE pts_rank <= 10 OR reb_rank <= 10 OR ast_rank <= 10
)
SELECT 
    team_abbreviation,
    COUNT(DISTINCT player_name) AS top_unique_players,
    COUNT(*) AS total_top_appearances
FROM top_players
GROUP BY team_abbreviation
ORDER BY total_top_appearances DESC;

-- Insights:
-- Lakers dominance is across multiple eras, they’ve had both superstar scorers and all-round performers, aligning with their long championship history.
-- Phoenix and Golden State appear due to dynamic offenses (Nash-era Suns, Curry-era Warriors), producing multiple stat leaders.
-- Minnesota’s high rank shows the impact of individual stars (e.g., Garnett, Towns, Edwards) — lots of elite seasons, even without consistent team success.

-- Looking at rookies vs veterans - how do their contributions differ?
with experience_class as (
select 
    player_name,
    season,
    team_abbreviation,
    pts,
    reb,
    ast,
    net_rating,
    usg_pct,
    ts_pct,
    case
        when cast(left(season, 4) as unsigned) = cast(draft_year as unsigned) then 'Rookie'
        ELSE 'Veteran'
        END as experience_level
    from all_seasons
    where draft_year != 'Undrafted'
)
select 
    experience_level,
    avg(pts) as avg_points,
    avg(reb) as avg_rebounds,
    avg(ast) as avg_assists,
    avg(usg_pct) as avg_usage,
    avg(ts_pct) as avg_true_shooting
from experience_class
group by experience_level;

-- Insights: 
-- Veterans contribute roughly 65% more across the board. The jump in points (+3.7 PPG) and rebounds (+1.4 RPG) reflects both experience and trust from coaches they get more playing time and offensive involvement.
-- Both rookies and veterans have around 18–19% usage, meaning they get similar share of possessions when on the floor but veterans convert those opportunities far more effectively.

-- Using a weighted index (e.g., 40% points, 30% rebounds/assists, 30% efficiency) to find an MVP for a given season.
with mvp_scores as (
select 
    season,
    player_name,
    team_abbreviation,
    pts,
    reb,
    ast,
    ts_pct,
    round(0.4 * pts + 0.15 * reb + 0.15 * ast + 0.3 *(ts_pct * 100), 2) as mvp_index
from all_seasons
), ranked_mvp as(
select
    season,
    player_name,
    team_abbreviation, 
    mvp_index,
    rank() over(partition by season order by mvp_index desc) as mvp_rank
    from mvp_scores
)
select
    season,
    player_name,
    team_abbreviation, 
    mvp_index
FROM ranked_mvp
where mvp_rank = 1
order by season;

-- insights: 
-- Karl Malone and Shaq top their seasons because they combine scoring volume, rebounding, and elite efficiency, fitting the weighting perfectly.
-- Players like Tom Chambers and Tyson Wheeler rise in the rankings likely due to high TS%, showing how even moderate scorers can look elite when they shoot efficiently.
-- Shaq’s dominance in 1999–00 aligns with real history. That’s the year he won real NBA MVP, confirming this weighted model captures realistic all-around impact.

-- Building your dream starting 5 (PG, SG, SF, PF, C) using stats across all seasons.
WITH player_performance AS (
  SELECT
      player_name,
      team_abbreviation,
      player_height,
      pts,
      reb,
      ast,
      ts_pct,
      ROUND(0.4 * pts + 0.15 * reb + 0.15 * ast + 0.3 * (ts_pct * 100), 2) AS performance_index
  FROM all_seasons
), player_positions AS (
  SELECT
      player_name,
      team_abbreviation,
      player_height,
      performance_index,
      CASE
          WHEN player_height <= 190 THEN 'PG'
          WHEN player_height BETWEEN 191 AND 200 THEN 'SG'
          WHEN player_height BETWEEN 201 AND 205 THEN 'SF'
          WHEN player_height BETWEEN 206 AND 210 THEN 'PF'
          WHEN player_height > 210 THEN 'C'
      END AS position
  FROM player_performance
), top_by_position AS (
  SELECT 
      position,
      player_name,
      team_abbreviation,
      player_height,
      performance_index,
      RANK() OVER (PARTITION BY position ORDER BY performance_index DESC) AS pos_rank
  FROM player_positions
)
SELECT 
    position,
    player_name,
    team_abbreviation,
    player_height,
    performance_index
FROM top_by_position
WHERE pos_rank = 1
ORDER BY position;

-- End
