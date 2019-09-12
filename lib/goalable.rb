module Goalable

  ### From Leagueable ###
  def best_offense # JP
    teams_total_goals = total_goals_helper
    teams_total_games = total_games_helper

    best_team_goals_avg = 0
    best_offense_team_id = 0
    this_team_goals_avg = 0

    teams_total_games.each do |games_key, games_value|
      teams_total_goals.each do |goals_key, goals_value|
        if goals_key == games_key
          this_team_goals_avg = (goals_value / games_value.to_f)
          if this_team_goals_avg > best_team_goals_avg
            best_team_goals_avg = this_team_goals_avg
            best_offense_team_id = games_key
          end
        end
      end
    end

    team_with_best_offense = nil
    self.teams.each_value do |team_obj|
      if team_obj.team_id. == best_offense_team_id
      team_with_best_offense = team_obj.team_name
      end
    end

    team_with_best_offense
  end

  def worst_offense # JP
    teams_total_goals = total_goals_helper
    teams_total_games = total_games_helper

    worst_team_goals_avg = 1000
    worst_offense_team_id = 0
    this_team_goals_avg = 0

    teams_total_games.each do |games_key, games_value|
      teams_total_goals.each do |goals_key, goals_value|
        if goals_key == games_key
          this_team_goals_avg = (goals_value / games_value.to_f)
          if this_team_goals_avg < worst_team_goals_avg
            worst_team_goals_avg = this_team_goals_avg
            worst_offense_team_id = games_key
          end
        end
      end
    end

    team_with_worst_offense = nil
    self.teams.each_value do |team_obj|
      if team_obj.team_id. == worst_offense_team_id
      team_with_worst_offense = team_obj.team_name
      end
    end
    team_with_worst_offense
  end

  def best_defense # JP
    teams_total_goals_allowed = total_goals_allowed_helper
    teams_total_games = total_games_helper

    best_team_goals_allowed_avg = 100
    best_defense_team_id = 0
    this_team_goals_allowed_avg = 0

    teams_total_games.each do |games_key, games_value|
      teams_total_goals_allowed.each do |goals_key, goals_value|
        if goals_key == games_key
          this_team_goals_allowed_avg = (goals_value / games_value.to_f)
          if this_team_goals_allowed_avg < best_team_goals_allowed_avg
            best_team_goals_allowed_avg = this_team_goals_allowed_avg
            best_defense_team_id = games_key
          end
        end
      end
    end

    team_with_best_defense = nil
    self.teams.each_value do |team_obj|
      if team_obj.team_id. == best_defense_team_id
      team_with_best_defense = team_obj.team_name
      end
    end
    team_with_best_defense
  end

  def worst_defense # JP
    teams_total_goals_allowed = total_goals_allowed_helper
    teams_total_games = total_games_helper

    worst_team_goals_allowed_avg = 0
    worst_defense_team_id = 0
    this_team_goals_allowed_avg = 0

    teams_total_games.each do |games_key, games_value|

      teams_total_goals_allowed.each do |goals_key, goals_value|
        if goals_key == games_key
          this_team_goals_allowed_avg = (goals_value / games_value.to_f)
          if this_team_goals_allowed_avg > worst_team_goals_allowed_avg
            worst_team_goals_allowed_avg = this_team_goals_allowed_avg
            worst_defense_team_id = games_key
          end
        end
      end
    end
    team_with_worst_defense = team_name_finder_helper(worst_defense_team_id)

    team_with_worst_defense
  end

  ### From Teamable ###
  def most_goals_scored(team_id) #BB
    most_goals_scored_counter = 0
    int_team_id = team_id.to_i
    self.game_teams.each do |game_team_obj|
      if game_team_obj.team_id == int_team_id
        if game_team_obj.goals > most_goals_scored_counter
          most_goals_scored_counter = game_team_obj.goals
        end
      end
    end
    most_goals_scored_counter
  end

  def fewest_goals_scored(team_id) #BB
    fewest_goals_scored_counter = 100
    int_team_id = team_id.to_i
    self.game_teams.each do |game_team_obj|
      if game_team_obj.team_id == int_team_id
        if game_team_obj.goals < fewest_goals_scored_counter
          fewest_goals_scored_counter = game_team_obj.goals
        end
      end
    end
    fewest_goals_scored_counter
  end

end
