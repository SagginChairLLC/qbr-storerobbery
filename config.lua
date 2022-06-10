Config = {}

--Rewards
Config.RewardItem = "cash" -- Make sure item is in the qbr-core/shared/items
Config.RewardAmount = 25 --Randomize by using  -  math.random(10, 25)

Config.resetTime = (60 * 1000) * 30 -- Every 30 minutes the store can be robbed again
Config.tickInterval = 1000 -- Ignore


--Add new registers to rob by easily
--First Copy and paste a line
--Change the first number to keep them in in order
--then change the vector to location
--Good Luck! (Do NOT Change the robbed or time status)
Config.Registers = {
    [1] = {vector3(1330.27, -1293.57, 77.02), robbed = false, time = 0},
    [2] = {vector3(-324.28, 804.29, 117.88), robbed = false, time = 0},
    [3] = {vector3(-1789.33, -387.55, 160.33), robbed = false, time = 0},
    [4] = {vector3(2860.15, -1202.15, 49.59), robbed = false, time = 0},
    [5] = {vector3(-5486.36, -2937.69, -0.4), robbed = false, time = 0},
    [6] = {vector3(-3687.3, -2622.49, -13.43), robbed = false, time = 0},
    [7] = {vector3(-785.49, -1322.16, 43.88), robbed = false, time = 0},
    [8] = {vector3(3025.48, 561.57, 44.72), robbed = false, time = 0},
}