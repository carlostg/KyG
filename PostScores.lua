----------------------------------------------------------------------------------
--
-- PostScores.lua
--
----------------------------------------------------------------------------------

local kGetAllScoresURL = "http://www.cadespr.org/KyG/getAllScores.php"
local kInsertScoreURL  = "http://www.cadespr.org/KyG/insertScore.php"
local kGameId          = "game_id"
local kTableNo         = "table_no"
local kScore           = "score"

function insertScore(gameId, tableNo, scoreVal)
    local response = ""
    local postString = kInsertScoreURL
    postString = postString.."?"..kGameId .."="..gameId
    postString = postString.."&"..kTableNo.."="..tableNo
    postString = postString.."&"..kScore..  "="..scoreVal
    
    local function networkListener( event )
        if ( event.isError ) then
            response = "Network error!"
        else
            response = "RESPONSE: " .. event.response
        end
    end
    
    network.request(postString, "POST", networkListener)
    
    return response
end