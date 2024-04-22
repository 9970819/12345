function [nowTime, punish, latePunish] = timepunish(ET, LT, CE, CL, route, partDistance, j, speed, nowTime)
    % Update the current time based on travel time and a constant adjustment factor
    nowTime = nowTime + partDistance / speed / 60 + speed / 48;
    earlyPunish = 0;  
    latePunish = 0;
    
    % Check if the arrival is earlier than expected
    if nowTime < ET(route(j))
        earlyPunish = CE * (ET(route(j)) - nowTime); % Calculate early arrival penalty
        nowTime = ET(route(j)); % Adjust current time to expected time
    % Check if the arrival is later than expected
    elseif nowTime > LT(route(j))
        latePunish = CL * (nowTime - LT(route(j))); % Calculate late arrival penalty
    else
        earlyPunish = 0;
        latePunish = 0;
    end
    
    % Calculate total penalty
    punish = earlyPunish + latePunish;
end