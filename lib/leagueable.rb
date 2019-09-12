module Leagueable
  def count_of_teams # BB 
    self.teams.length
  end

  def highest_scoring_visitor # AM
    away_goals = Hash.new(0.00)
    unique_away_teams_array_helper.each do |team_id|
      self.games.each_value do |game|
        away_goals[team_id] += (game.away_goals) if game.away_team_id == team_id
      end
    end
    away_goals.merge!(total_away_games_helper)  do |key, oldval, newval|
      (oldval / newval).round(2)
    end
    highest_avg_hash = away_goals.max_by do |k, v|
      v
    end
    team_name_finder_helper(highest_avg_hash[0])
  end

  def highest_scoring_home_team # AM
    home_goals = Hash.new(0.00)
    unique_home_teams_array_helper.each do |team_id| #get sum of away_goals per home team (hash output)
      self.games.each_value do |game|
        home_goals[team_id] += (game.home_goals) if game.home_team_id == team_id
      end
    end
    home_goals.merge!(total_home_games_helper)  do |key, oldval, newval| #turn sum into average
      (oldval / newval).round(2)
    end
    highest_avg_hash = home_goals.max_by do |k, v|  #return highest
      v
    end
    team_name_finder_helper(highest_avg_hash[0])
  end

  def lowest_scoring_visitor # AM
    away_goals = Hash.new(0.00)
    unique_away_teams_array_helper.each do |team_id| #get sum of away_goals per away team (hash output)
      self.games.each_value do |game|
        away_goals[team_id] += (game.away_goals) if game.away_team_id == team_id
      end
    end
    away_goals.merge!(total_away_games_helper)  do |key, oldval, newval| #turn sum into average
      (oldval / newval).round(2)
    end
    lowest_avg_hash = away_goals.min_by do |k, v| #return lowest
      v
    end
    team_name_finder_helper(lowest_avg_hash[0])
  end

  def lowest_scoring_home_team # AM
    home_goals = Hash.new(0.00)
    unique_home_teams_array_helper.each do |team_id| #get sum of away_goals per home team (hash output)
      self.games.each_value do |game|
        home_goals[team_id] += (game.home_goals) if game.home_team_id == team_id
      end
    end
    home_goals.merge!(total_home_games_helper)  do |key, oldval, newval| #turn sum into average
      (oldval / newval).round(2)
    end
    lowest_avg_hash = home_goals.min_by do |k, v| #return highest
      v
    end
    team_name_finder_helper(lowest_avg_hash[0])
  end

  def winningest_team # BB
    winningest_team_wins_average = 0
    winningest_team_team_id = 0
    this_team_wins_average = 0
    total_games_helper.each do |games_key, games_value|
      total_wins_helper.each do |wins_key, wins_value|   # Nest an iteration over teams_total_wins key/value pairs. wins_key is the team_id and wins_value is the number of games won
        if wins_key == games_key
          this_team_wins_average = (wins_value / games_value.to_f)
          if this_team_wins_average > winningest_team_wins_average
            winningest_team_wins_average = this_team_wins_average
            winningest_team_team_id = games_key
          end
        end
      end
    end
    team_name_finder_helper(winningest_team_team_id)
  end

  def best_fans # BB (Complete)
    teams_away_win_percentage = Hash.new # Create hash with team ids as keys and the total home and away win % for each team as values
    teams_home_win_percentage = Hash.new
    self.teams.each_key do |team_id|
      teams_away_win_percentage[team_id] = 0
      teams_home_win_percentage[team_id] = 0
    end
    away_win_percentage = 0 # calculate each teams_away_win_percentage
    total_away_games_helper.each do |games_id, games_v| # games_id = team_id and games_v = total number of away games
      total_away_wins_helper.each do |wins_id, wins_v| # wins_id = team_id and wins_v = total number of away wins
        teams_away_win_percentage.each_key do |team_id|
          if games_id == wins_id
            away_win_percentage = (wins_v / games_v.to_f).round(2)
          end
          if games_id == team_id
            teams_away_win_percentage[team_id] = away_win_percentage
          end
        end
      end
    end
    home_win_percentage = 0 # calculate each teams_home_win_percentage
    total_home_games_helper.each do |games_id, games_v| # games_id = team_id and games_v = total number of home games
      total_home_wins_helper.each do |wins_id, wins_v| # wins_id = team_id and wins_v = total number of home wins
        teams_home_win_percentage.each_key do |team_id|
          if games_id == wins_id
            home_win_percentage = (wins_v / games_v.to_f).round(2)
          end
          if games_id == team_id
            teams_home_win_percentage[team_id] = home_win_percentage
          end
        end
      end
    end
    difference = 0   # Get the difference between home wins and away wins for each team
    biggest_difference = 0 # Set default values
    team_id = nil
    teams_home_win_percentage.each do |team_id_1, home_win_percent|
      teams_away_win_percentage.each do |team_id_2, away_win_percent|
        if team_id_1 == team_id_2
          difference = (home_win_percent - away_win_percent).abs
          if difference > biggest_difference
            biggest_difference = difference
            team_id = team_id_1 # return team id of the team with biggest difference between home and away win percent
          end
        end
      end
    end
    team_name_finder_helper(team_id)
  end

  def worst_fans # BB (Complete)
    worst_fans_collection = []
    total_away_wins_helper.each do |team_id_1, number_of_away_wins|   # Iterate through the hashes and if a team has more away wins than home wins then they get added to the worst_fans_collection array
      total_home_wins_helper.each do |team_id_2, number_of_home_wins|
        if team_id_1 == team_id_2
          if number_of_away_wins > number_of_home_wins
            worst_fans_collection << team_id_2
          end
        end
      end
    end
    worst_fans_collection.map! do |team_id| # Convert the worst_fans array of team_ids to team names
      team_name_finder_helper(team_id)
    end
    worst_fans_collection
  end
end
