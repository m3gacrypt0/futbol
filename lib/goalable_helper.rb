module GoalableHelper
### From Leagueable_Helper ###

  def total_goals_helper(team_id = "0")
    teams_total_goals = Hash.new(0)
    if team_id == "0" #all teams in hash
      self.games.each_value do |game|
        teams_total_goals[game.away_team_id] += game.away_goals
        teams_total_goals[game.home_team_id] += game.home_goals
      end
    else  #for only one team (away or home)
      self.games.each_value do |game|
        teams_total_goals[team_id] += game.away_goals if game.away_team_id == team_id
        teams_total_goals[team_id] += game.home_goals if game.home_team_id == team_id
      end
    end
    teams_total_goals
  end

  def total_goals_allowed_helper(team_id = "0")
    teams_total_goals_allowed = Hash.new(0)
    if team_id == "0" #all teams in hash
      self.games.each_value do |game|
        teams_total_goals_allowed[game.away_team_id] += game.home_goals
        teams_total_goals_allowed[game.home_team_id] += game.away_goals
      end
    else  #for only one team (away or home)
      self.games.each_value do |game|
        teams_total_goals_allowed[team_id] += game.home_goals if game.away_team_id == team_id
        teams_total_goals_allowed[team_id] += game.away_goals if game.home_team_id == team_id
      end
    end
    teams_total_goals_allowed
  end

  def total_goals_at_home_helper(team_id = "0")
    teams_total_goals_at_home = Hash.new(0)
    if team_id == "0" #all teams in hash
      self.games.each_value do |game|
        teams_total_goals_at_home[game.home_team_id] += game.home_goals
      end
    else  #for only one team (away or home)
      self.games.each_value do |game|
        teams_total_goals_at_home[team_id] += game.home_goals if game.home_team_id == team_id
      end
    end
    teams_total_goals_at_home
  end

  def total_goals_visitor_helper(team_id = "0")
    teams_total_goals_visitor = Hash.new(0)
    if team_id == "0" #all teams in hash
      self.games.each_value do |game|
        teams_total_goals_visitor[game.away_team_id] += game.away_goals
      end
    else  #for only one team (away or home)
      self.games.each_value do |game|
        teams_total_goals_visitor[team_id] += game.away_goals if game.away_team_id == team_id
      end
    end
    teams_total_goals_visitor
  end

  def all_shots_season(team_id, season)

  all_shots = 0
  all_goals = 0
    self.games.each_value do |game|
      if (game.season == season) && ((game.home_team_id == team_id) || (game.away_team_id == team_id))
          row = self.game_teams.select do |game_team|
            ((game_team.game_id == game.game_id) &&
            (game_team.team_id.to_s == team_id))
          end
          if row[0] != nil
            all_shots += row[0].shots
            all_goals += row[0].goals
          end
      end
    end

  [all_shots, all_goals]

  if (all_shots > 0) && (all_goals > 0)
    all_shots.to_f / all_goals
  else
    0.00
  end
end

end
