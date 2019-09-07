class GameTeam
  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles,
              :pim,
              :powerPlayOpportunities,
              :powerPlayGoals,
              :faceOffWinPercentage,
              :giveaways,
              :takeaways

  def initialize(row)

    @game_id                = row["game_id"].to_i
    @team_id                = row["team_id"].to_i
    @hoa                    = row["HoA"]
    @result                 = row["result"]
    @settled_in             = row["settled_in"]
    @head_coach             = row["head_coach"]
    @goals                  = row["goals"].to_i
    @shots                  = row["shots"].to_i
    @tackles                = row["tackles"].to_i
    @pim                    = row["pim"]
    @powerPlayOpportunities = row["powerPlayOpportunities"]
    @powerPlayGoals         = row["powerPlayGoals"]
    @faceOffWinPercentage   = row["faceOffWinPercentage"]
    @giveaways              = row["giveaways"]
    @takeaways              = row["takeaways"]

  end

end
