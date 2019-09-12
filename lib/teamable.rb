module Teamable

    def team_info(teamid) #JP (Complete)
      team_info_hash = Hash.new
      iv_name_array = []
      iv_values_array = []
      self.teams.each do |team_id, team_obj|
        if team_id == teamid
          iv_name_array = team_obj.instance_variables
          until iv_name_array == []
              iv_values_array << team_obj.instance_variable_get("#{iv_name_array[0]}")
              team_info_hash[iv_name_array.shift.to_s[1..-1]] = iv_values_array.shift
          end
        end
      end
      team_info_hash.delete("stadium")
      team_info_hash
    end

    def best_season(team_id) #JP (Complete)
      season_win_percentage_hash = season_win_percentage_helper(team_id)
      best_win_percentage = 0.0
      best_season = 0
      season_win_percentage_hash.each do |season, win_percentage|
        if win_percentage > best_win_percentage
         best_win_percentage = win_percentage
        end
        best_season = season_win_percentage_hash.key(best_win_percentage)
      end
      best_season
    end

    def worst_season(team_id) #JP (Complete)
      season_win_percentage_hash = season_win_percentage_helper(team_id)
      worst_win_percentage = 2.0
      worst_season = 0
      season_win_percentage_hash.each do |season, win_percentage|
        if win_percentage < worst_win_percentage
         worst_win_percentage = win_percentage
        end
        worst_season = season_win_percentage_hash.key(worst_win_percentage)
      end
      worst_season
    end

    def average_win_percentage(team_id) #JP
      (total_wins_count_helper(team_id) / games_for_team_helper(team_id).length.to_f).round(2)
    end


  def favorite_opponent(team_id) #BB
    opponents_number_of_wins = Hash.new(0.00) # creates a hash full of opponent ids and sets the values to 0
    games_for_team_helper(team_id).each do |game|
      opponents_number_of_wins.store(game.away_team_id, 0.00) if game.away_team_id != team_id
      opponents_number_of_wins.store(game.home_team_id, 0.00) if game.home_team_id != team_id
    end
    opponents_number_of_wins.each do |key, value| # set the value to the number of wins over
       opponents_number_of_wins[key] = total_wins_count_helper(team_id, key)
    end
    opponents_number_of_games = Hash.new(0.00) # creates a hash full of opponent ids and sets the values to 0
    games_for_team_helper(team_id).each do |game|
      opponents_number_of_games.store(game.away_team_id, 0.00) if game.away_team_id != team_id
      opponents_number_of_games.store(game.home_team_id, 0.00) if game.home_team_id != team_id
    end
    opponents_number_of_games.each do |key, value| # set the value to the number of games played
       opponents_number_of_games[key] = total_games_count_helper(team_id, key)
    end
    opponents_percentage_of_wins = Hash.new(0.00) # make a new hash to check the percent of wins against the passed in team
    games_for_team_helper(team_id).each do |game|
      opponents_percentage_of_wins.store(game.away_team_id, 0.00) if game.away_team_id != team_id
      opponents_percentage_of_wins.store(game.home_team_id, 0.00) if game.home_team_id != team_id
    end
    opponents_percentage_of_wins.each do |key_3, value_3| # Check for matching team ids and return the percent of games won for that team
      opponents_number_of_wins.each do |key_1, value_1|
        opponents_number_of_games.each do |key_2, value_2|
          if key_1 == key_2 && key_1 == key_3
            opponents_percentage_of_wins[key_3] = (value_1 / value_2)
          end
        end
      end
    end
    favorite_opponent_id = opponents_percentage_of_wins.max_by{|k,v| v} # find the max percent id from the opponents_percentage_of_wins hash
    favorite_opponent = favorite_opponent_id[0]
    team_name_finder_helper(favorite_opponent)
  end

  def rival(team_id) #BB
    opponents_number_of_wins = Hash.new(0.00) # creates a hash full of opponent ids and sets the values to 0
    games_for_team_helper(team_id).each do |game|
      opponents_number_of_wins.store(game.away_team_id, 0.00) if game.away_team_id != team_id
      opponents_number_of_wins.store(game.home_team_id, 0.00) if game.home_team_id != team_id
    end
    opponents_number_of_wins.each do |key, value| # set the value to the number of wins over
       opponents_number_of_wins[key] = total_wins_count_helper(team_id, key)
    end
    opponents_number_of_games = Hash.new(0.00) # creates a hash full of opponent ids and sets the values to 0
    games_for_team_helper(team_id).each do |game|
      opponents_number_of_games.store(game.away_team_id, 0.00) if game.away_team_id != team_id
      opponents_number_of_games.store(game.home_team_id, 0.00) if game.home_team_id != team_id
    end
    opponents_number_of_games.each do |key, value| # set the value to the number of games played
       opponents_number_of_games[key] = total_games_count_helper(team_id, key)
    end
    opponents_percentage_of_wins = Hash.new(0.00) # make a new hash to check the percent of wins against the passed in team
    games_for_team_helper(team_id).each do |game|
      opponents_percentage_of_wins.store(game.away_team_id, 0.00) if game.away_team_id != team_id
      opponents_percentage_of_wins.store(game.home_team_id, 0.00) if game.home_team_id != team_id
    end
    opponents_percentage_of_wins.each do |key_3, value_3| # Check for matching team ids and return the percent of games won for that team
      opponents_number_of_wins.each do |key_1, value_1|
        opponents_number_of_games.each do |key_2, value_2|
          if key_1 == key_2 && key_1 == key_3
            opponents_percentage_of_wins[key_3] = (value_1 / value_2)
          end
        end
      end
    end
    favorite_opponent_id = opponents_percentage_of_wins.min_by{|k,v| v} # find the max percent id from the opponents_percentage_of_wins hash
    favorite_opponent = favorite_opponent_id[0]
    team_name_finder_helper(favorite_opponent)
  end

  def biggest_team_blowout(team_id) #AM (complete)
    wins = games_for_team_helper(team_id).select! do |game| #select games team won and delete result
      if (game.away_team_id == team_id) && (game.away_goals > game.home_goals)
        true
      elsif (game.home_team_id == team_id) && (game.home_goals > game.away_goals)
        true
      else
        false
      end
    end
    max_game = wins.max_by do |game|
      (game.home_goals - game.away_goals).abs
    end
    (max_game.home_goals - max_game.away_goals).abs
  end

  def worst_loss(team_id) #AM (complete)
    games = games_for_team_helper(team_id).select! do |game| #select games team lost and delete rest
      if (game.away_team_id == team_id) && (game.away_goals < game.home_goals)
        true
      elsif (game.home_team_id == team_id) && (game.home_goals < game.away_goals)
        true
      else
        false
      end
    end
    max_game = games.max_by do |game|
      (game.home_goals - game.away_goals).abs
    end
    (max_game.home_goals - max_game.away_goals).abs
  end

  def head_to_head(team_id) #AM (completed, but not in same order as spec spec_harness)
    games_played = games_for_team_helper(team_id)
    opponent_teams = Hash.new(0)
    output = Hash.new(0) #fill hash with teams played
    games_played.each do |game| #get unique opponent team id and name
      if (opponent_teams.has_key?(game.home_team_id) == false) && (game.home_team_id != team_id)
        opponent_teams.store(game.home_team_id, team_name_finder_helper(game.home_team_id))
      elsif (opponent_teams.has_key?(game.away_team_id) == false) && (game.away_team_id != team_id)
        opponent_teams.store(game.away_team_id, team_name_finder_helper(game.away_team_id))
      end
    end
    opponent_teams.each do |opponent_team_id, opponent_team_name| #iterate over teams played and calculate win percentage for each
      output[opponent_team_name] = (total_wins_count_helper(team_id, opponent_team_id) / total_games_count_helper(team_id, opponent_team_id)).round(2)
    end
    output
  end

  def seasonal_summary(team_id) #AM
    unique_seasons = []
    self.games.each_value do |game|
      unique_seasons << game.season if (game.home_team_id == team_id) || (game.away_team_id == team_id)
    end
    unique_seasons = unique_seasons.uniq
    seasonal_summary_hash = Hash.new(0)
    unique_seasons.each do |season|
      seasonal_summary_hash[season] = {:postseason =>
        {:win_percentage => season_type_win_percentage_helper(team_id, season, "Postseason").round(2), :total_goals_scored => season_type_goals_scored_helper(team_id, season, "Postseason"), :total_goals_against => season_type_goals_against_helper(team_id, season, "Postseason"), :average_goals_scored => season_type_average_goals_scored_helper(team_id, season, "Postseason"), :average_goals_against => season_type_average_goals_against_helper(team_id, season, "Postseason")}, :regular_season => {:win_percentage => season_type_win_percentage_helper(team_id, season, "Regular Season").round(2), :total_goals_scored => season_type_goals_scored_helper(team_id, season, "Regular Season"), :total_goals_against => season_type_goals_against_helper(team_id, season, "Regular Season"), :average_goals_scored => season_type_average_goals_scored_helper(team_id, season, "Regular Season"), :average_goals_against => season_type_average_goals_against_helper(team_id, season, "Regular Season") }}
    end
    seasonal_summary_hash
  end

end
