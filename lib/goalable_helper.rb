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
