module Seasonable

  def biggest_bust(season) # BB
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

  def biggest_surprise(season) # BB
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

  def winningest_coach(season) # JP
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

  def worst_coach(season)   # JP
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

  def most_accurate_team(season)   # AM
    agg_data = Hash.new(0)
      self.teams.each_pair do |team_id, _|
        agg_data[team_id] = all_shots_season(team_id, season)
      end

      agg_data.delete_if do |_, v|
        v == 0
      end
    team_name_finder_helper(agg_data.min_by {|_, v| v if v > 0}[0])
  end

  def least_accurate_team(season)   # AM
        agg_data = Hash.new(0)
          self.teams.each_pair do |team_id, _|
            agg_data[team_id] = all_shots_season(team_id, season)
          end
        team_name_finder_helper(agg_data.max_by {|_, v| v}[0])
  end

  def most_tackles(season) # JP
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

  def fewest_tackles(season)   # JP
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
end
