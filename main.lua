
 --Developed by Shreevallabh Kulkarni
 --Email: shreevallabh29@gmail.com
 --WORK IN PROGRESS code


function love.load()
 
  --Setting up graphics window
  love.window.setMode(1280, 720)

  --Struct variables for holding various types of data
  Button = {}
  Button.x = 200
  Button.y = 200
  Button.size = 50

  ClicksData = {}
  ClicksData.TotalClicks = 0
  ClicksData.HitClicks = 0
  ClicksData.MissedClicks = 0

  ClicksHitTimeStamp = {}

  --Variables to process the user input and manage game state
  score = 0
  timer = 15
  gameState = 1
  currentFrameDeltaTime = 0
  tempString = ""
  TimeStampString = ""

  BaseFont = love.graphics.newFont(40)
  ClicksDataFont = love.graphics.newFont(24)

end

  --Function which runs every frame and handles the timer
function love.update(dt)

  if gameState == 2 then
  
    if timer > 0 then
      timer = timer - dt
      currentFrameDeltaTime = RoundedTimer(timer, 3)
    end

    if timer < 0 then
      timer = 0
      gameState = 3
      score = 0
    end
	
  end
end

function love.draw()

  --Game state where we show circle graphics and timer on the screen
  if gameState == 2 then
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", Button.x, Button.y, Button.size)

    love.graphics.setFont(BaseFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Time: " .. math.ceil(timer), 0, 0)
  end

  --Game state where we are waiting for user to start the game
  if gameState == 1 then
    love.graphics.setFont(BaseFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Click anywhere to begin!", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
  end

  --Game state where we show a simple report containing accuracy of the clicks
  if gameState == 3 then
    love.graphics.setFont(BaseFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Actions per Minute(APM) Report", 0, love.graphics.getHeight()/2 - 320, love.graphics.getWidth(), "center")
    love.graphics.setFont(ClicksDataFont)
    love.graphics.setColor(0.5, 1, 1)
    love.graphics.printf("Total Clicks: " .. ClicksData.TotalClicks, - 300, love.graphics.getHeight()/2 - 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Hit Clicks: " .. ClicksData.HitClicks, 0, love.graphics.getHeight()/2 - 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Missed Clicks: " .. ClicksData.MissedClicks, 300, love.graphics.getHeight()/2 - 100 , love.graphics.getWidth(), "center")

    Accuracy = ( ClicksData.HitClicks / ClicksData.TotalClicks ) * 100
    Accuracy = RoundedTimer(Accuracy, 2)
    love.graphics.printf("Accuracy: " .. Accuracy .."%", 0, love.graphics.getHeight()/2 , love.graphics.getWidth(), "center")

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Click to continue to see detailed time stamps!", 0, love.graphics.getHeight()/2 + 200 , love.graphics.getWidth(), "center")
  end

  --Game state where we show the actual report to the user in miliseconds pattern
  if gameState == 4 then
    love.graphics.setFont(BaseFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Actions per Minute(APM) Report", 0, love.graphics.getHeight()/2 - 320, love.graphics.getWidth(), "center")
    love.graphics.setFont(ClicksDataFont)
    love.graphics.setColor(0.5, 1, 1)
    love.graphics.printf("- Clicks Timestamp - ", 0, love.graphics.getHeight()/2 - 260, love.graphics.getWidth(), "center")


    love.graphics.printf(tempString, love.graphics.getWidth()/2 - 250 , love.graphics.getHeight()/2 - 100, love.graphics.getWidth(), "left")

  end
end

function love.mousepressed( x, y, b, istouch )

  if b == 1 and gameState == 2 then
    ClicksData.TotalClicks = ClicksData.TotalClicks + 1
    if distanceBetween(Button.x, Button.y, love.mouse.getX(), love.mouse.getY()) < Button.size then
      score = score + 1

      Button.x = math.random(Button.size, love.graphics.getWidth() - Button.size)
      Button.y = math.random(Button.size, love.graphics.getHeight() - Button.size)

      if ClicksData.HitClicks == 0 then
    --Change the integer from following statement equal to the timer [VERY IMP], for e.g. current timer is 15 then following integer should be 15
        table.insert(ClicksData, 15 - currentFrameDeltaTime)

      else
        local currentTime = ClicksHitTimeStamp[#ClicksHitTimeStamp] - currentFrameDeltaTime
        table.insert(ClicksData, currentTime)
      end

      ClicksData.HitClicks = ClicksData.HitClicks + 1
      table.insert(ClicksHitTimeStamp, currentFrameDeltaTime)
    else
      ClicksData.MissedClicks = ClicksData.MissedClicks + 1
    end
	
  end
  
  --Simple game state management using if-else conditions
  if gameState == 1 then
    gameState = 2
    timer = 15
  end

  if b == 1 and gameState == 3 then
    for k , v in ipairs(ClicksData) do
      if k % 5 == 0 then
      tempString = tempString .. "\n\n " .. tostring(v)
    else
      tempString =  tempString .. "     " .. tostring(v)
    end
  end

    gameState = 4
  end
end

  --Helper functions to use distance formula
function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

  --Helper functions round the timer
function RoundedTimer(num, numOfDecimalPlaces)
  if numOfDecimalPlaces and numOfDecimalPlaces>0 then
      local mult = 10^numOfDecimalPlaces
      return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end


 --Following function returns a character from a specific index from a string
function GetCharFromString(str,i) return string.sub(str,i,i) end
