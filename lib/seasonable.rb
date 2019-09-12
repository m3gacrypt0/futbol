require 'pry'
module Seasonable

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
      teams_reg_season_win_percentage[team_id] = season_type_win_percentage_helper(team_id, season, "Regular Season")
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

  # AM
  def most_accurate_team(season)
    agg_data = Hash.new(0)
      self.teams.each_pair do |team_id, _|
        agg_data[team_id] = all_shots_season(team_id, season)
      end
    team_name_finder_helper(agg_data.max_by {|_, v| v}[0])
  end

  # AM
  def least_accurate_team(season)
        agg_data = Hash.new(0)
          self.teams.each_pair do |team_id, _|
            agg_data[team_id] = all_shots_season(team_id, season)
          end
        team_name_finder_helper(agg_data.min_by {|_, v| v}[0])
  end

  # JP
  def most_tackles(season)
    total_tackles = tackles_helper(season)
    most_tackles = 0
    best_team = 0
    total_tackles.each do |team, tackles|
      if tackles > most_tackles
        most_tackles = tackles
        best_team = team
      end

    end
    team_name_finder_helper(best_team.to_s)
  end

  # JP
  def fewest_tackles(season)
    total_tackles = tackles_helper(season)
    least_tackles = 10000
    worst_team = 0
    total_tackles.each do |team, tackles|
      if tackles < least_tackles
        least_tackles = tackles
        worst_team = team
      end
    end
    team_name_finder_helper(worst_team.to_s)
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
