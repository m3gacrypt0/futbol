require 'pry'
module Seasonable

  # Name of the team with the biggest decrease between regular season and postseason win percentage.	Return: String
  # BB (Complete)
  def biggest_bust(season)
    teams_reg_season_win_percentage = Hash.new(0)
    teams_post_season_win_percentage = Hash.new(0)
    teams_differences = Hash.new(0)
    self.games.each_value do |game|
      teams_reg_season_win_percentage[game.home_team_id] += 0
      teams_reg_season_win_percentage[game.away_team_id] += 0
      teams_post_season_win_percentage[game.home_team_id] += 0
      teams_post_season_win_percentage[game.away_team_id] += 0
      teams_differences[game.home_team_id] += 0
      teams_differences[game.away_team_id] += 0
    end

    teams_reg_season_win_percentage.each do |team_id, percent|
      teams_reg_season_win_percentage[team_id] = season_type_win_percentage_helper(team_id, season, type = "Regular Season")
    end

    teams_post_season_win_percentage.each do |team_id, percent|
      teams_post_season_win_percentage[team_id] = season_type_win_percentage_helper(team_id, season, type = "Postseason")
    end

    teams_differences.each do |team_id_1, diff_percent|
      teams_reg_season_win_percentage.each do |team_id_2, reg_win_percent|
        teams_post_season_win_percentage.each do |team_id_3, post_win_percent|
          if team_id_1 == team_id_2 && team_id_1 == team_id_3 && team_id_2 == team_id_3
            teams_differences[team_id_1] = reg_win_percent - post_win_percent
          end
        end
      end
    end

    team_with_biggest_diff = teams_differences.max_by {|k,v| v }

    team_name_finder_helper(team_with_biggest_diff[0])

  end

  # Name of the team with the biggest increase between regular season and postseason win percentage.	Return: String
  # BB (Complete)
  def biggest_surprise(season)
    teams_reg_season_win_percentage = Hash.new(0)
    teams_post_season_win_percentage = Hash.new(0)
    teams_differences = Hash.new(0)
    self.games.each_value do |game|
      teams_reg_season_win_percentage[game.home_team_id] += 0
      teams_reg_season_win_percentage[game.away_team_id] += 0
      teams_post_season_win_percentage[game.home_team_id] += 0
      teams_post_season_win_percentage[game.away_team_id] += 0
      teams_differences[game.home_team_id] += 0
      teams_differences[game.away_team_id] += 0
    end

    teams_reg_season_win_percentage.each do |team_id, percent|
      teams_reg_season_win_percentage[team_id] = season_type_win_percentage_helper(team_id, season, type = "Regular Season")
    end

    teams_post_season_win_percentage.each do |team_id, percent|
      teams_post_season_win_percentage[team_id] = season_type_win_percentage_helper(team_id, season, type = "Postseason")
    end

    teams_differences.each do |team_id_1, diff_percent|
      teams_reg_season_win_percentage.each do |team_id_2, reg_win_percent|
        teams_post_season_win_percentage.each do |team_id_3, post_win_percent|
          if team_id_1 == team_id_2 && team_id_1 == team_id_3 && team_id_2 == team_id_3
            teams_differences[team_id_1] = reg_win_percent - post_win_percent
          end
        end
      end
    end

    team_with_lowest_diff = teams_differences.min_by {|k,v| v }

    team_name_finder_helper(team_with_lowest_diff[0])
  end

  # Name of the Coach with the best win percentage for the season. Return:	String
  # JP (complete)
  def winningest_coach(season)
    coach_win_percentage_hash = coach_win_percentage_helper(season)
    best_win_percentage = 0.0
    best_coach = ""

    coach_win_percentage_hash.each do |coach, win_percentage|
      if win_percentage > best_win_percentage
        best_win_percentage = win_percentage
        best_coach = coach
      end
    end
    best_coach
  end

  # Name of the Coach with the worst win percentage for the season. Return:	String
  # JP (complete)
  def worst_coach(season)
    coach_win_percentage_hash = coach_win_percentage_helper(season)
    worst_win_percentage = 2.0
    worst_coach = ""

    coach_win_percentage_hash.each do |coach, win_percentage|
      if win_percentage < worst_win_percentage
        worst_win_percentage = win_percentage
        worst_coach = coach
      end
    end
    worst_coach
  end

  # Name of the Team with the best ratio of shots to goals for the season. Return:	String
  # AM
  def most_accurate_team(season)
    # code goes here!
  end

  # Name of the Team with the worst ratio of shots to goals for the season. Return:	String
  # AM
  def least_accurate_team(season)
    # code goes here!
  end

  # Name of the Team with the most tackles in the season. Return:	String
  # JP
  def most_tackles(season)
    # code goes here!
  end

  # Name of the Team with the fewest tackles in the season. Return:	String
  # JP
  def fewest_tackles(season)
    # code goes here!
  end

  ### Helper Methods ###

  def coach_win_percentage_helper(season) #ALL Coaches. Hash. Key = coach name, Value = win percentage
    coach_array = coach_array_helper
    coach_win_game_hash = Hash.new(0)
    coach_win_percentage_hash = Hash.new(0)
    until coach_array == []
      coach_win_game_hash[coach_array.shift] = { :wins => 0,
                                                :games => 0}
    end

    self.game_teams.each do |game_obj|
      coach_win_game_hash.each do |coach, win_game_hash|
        if coach == game_obj.head_coach && season_converter(season) == game_obj.game_id.to_s[0..3].to_i
          if game_obj.result == "WIN"
            win_game_hash[:wins] += 1
            win_game_hash[:games] += 1
          elsif game_obj.result == "LOSS" || game_obj.result == "TIE"
            win_game_hash[:games] += 1
          end
        end
      end
    end

    win_percentage = nil
    coach_win_game_hash.each do |coach, win_games|
      win_percentage = ((win_games[:wins]).to_f / (win_games[:games]).to_f).round(2)
      coach_win_percentage_hash[coach] = win_percentage
    end

    coach_win_percentage_hash.delete_if do |coach, win_percentage|
      win_percentage.nan?
    end

    coach_win_percentage_hash
  end

  def coach_array_helper #All uniq coaches in an array
    coach_array = []
    self.game_teams.each do |game_obj|
      coach_array << game_obj.head_coach
    end
    coach_array.uniq!.sort!
  end

  def season_converter(season)
    #convert full season to first 4 characters
    shortened_season = season[0..3]
    shortened_season.to_i
  end

  def shots_helper(season) #ALL Teams. Hash. Key = Team_id, Value = shots

  end

  def goals_helper(season) #ALL Teams. Hash. Key = Team_id, Value = goals
  end

  def tackles_helper(season) #ALL Teams. Hash. Key = Team_id, Value = tackles
  end

end
