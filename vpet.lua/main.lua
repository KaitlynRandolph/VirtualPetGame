-- A virtual pet game
-- Author: Kaitlyn Randolph
-- 12/24/18
-- current project: set up second "stats checking" state
-- draw icon for illness
-- set win/lose condition
-- set way for debug to be toggled from inside game itself
-- fix age up so that you only sleep when pet is tired

-----------------------
--  Global Variables --
-----------------------
vpet = {}
debug = true
hunger_heart_img = NIL
mood_heart_img = NIL

----------------------
--  Main Functions  --
----------------------
function love.load()
	state = "game"
	require("vpet")
	-- elapsed time in seconds
	vtime = 1
	love.graphics.setDefaultFilter('nearest', 'nearest')
	font = love.graphics.newFont('Font/VCR_OSD_MONO_1.001.ttf', 32)
	vpet.hatched = false
	imageScale = 5
	vpet.needCare = false
	-- create vpet
	vpet.newEgg()
	-- background image
	background_img = love.graphics.newImage('Textures/background2.png')
	-- alert image
	vpet.alert_img = love.graphics.newImage('Textures/alert.png')
	-- feed images
	vpet.feedOff_img = love.graphics.newImage('Textures/feedOff.png')
	vpet.feedOn_img = love.graphics.newImage('Textures/feedOn.png')
	-- play images
	vpet.playOff_img = love.graphics.newImage('Textures/playOff.png')
	vpet.playOn_img = love.graphics.newImage('Textures/playOn.png')
	-- lamp images
	vpet.lampOff_img = love.graphics.newImage('Textures/lampOff.png')
	vpet.lampOn_img = love.graphics.newImage('Textures/lampOn.png')
	-- clean images
	vpet.cleanOff_img = love.graphics.newImage('Textures/cleanOff.png')
	vpet.cleanOn_img = love.graphics.newImage('Textures/cleanOn.png')
	-- medicine images
	vpet.medOff_img = love.graphics.newImage('Textures/medicineOff.png')
	vpet.medOn_img = love.graphics.newImage('Textures/medicineOn.png')
	-- stats images
	vpet.statsOff_img = love.graphics.newImage('Textures/statsOff.png')
	vpet.statsOn_img = love.graphics.newImage('Textures/statsOn.png')
	-- poo image
	vpet.poo_img = love.graphics.newImage('Textures/poo.png')
	-- sickness image
	vpet.sick_img = love.graphics.newImage('Textures/sick.png')
	-- heart images
	no_heart_img = love.graphics.newImage('Textures/0hearts.png')
	one_heart_img = love.graphics.newImage('Textures/1heart.png')
	two_heart_img = love.graphics.newImage('Textures/2hearts.png')
	three_heart_img = love.graphics.newImage('Textures/3hearts.png')
	four_heart_img = love.graphics.newImage('Textures/4hearts.png')
	five_heart_img = love.graphics.newImage('Textures/5hearts.png')
end

function love.update(dt)
	setVtime(vtime + dt)
	vpet.update(dt)
end

function love.draw()
	love.graphics.setFont(font)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setBackgroundColor(0.8, 0.8, 0.8)
	drawBackground()
	drawMenu()
	if (state == "game") then
		love.graphics.draw(vpet.image, 150, 200, 0, imageScale)
		if (needCare()) then
			drawAlert()
		end
		if (vpet.needsPoo()) then
			drawPoo()
		end
		if (vpet.isSick()) then
			drawSick()
		end
		if (debug) then
			love.graphics.setColor(0, 1, 0, 1)
			love.graphics.print('hunger: ' .. getHunger(), 10, 500, 0, 1, 1, 0, 0, 0, 0)
			love.graphics.setColor(0, 1, 0, 1)
			love.graphics.print('mood: ' .. getMood(), 10, 550, 0, 1, 1, 0, 0, 0, 0)
			love.graphics.setColor(0, 1, 0, 1)
			love.graphics.print('energy: ' .. getEnergy(), 250, 500, 0, 1, 1, 0, 0, 0, 0)
			love.graphics.setColor(0, 1, 0, 1)
			love.graphics.print('bladder: ' .. getBladder(), 250, 550, 0, 1, 1, 0, 0, 0, 0)
			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.print('vtime: ' .. vtime, 240, 110, 0, 1, 1, 0, 0, 0, 0)
		end
	elseif (state == "stats") then
		hunger_heart_img = pickHeartImg(getHunger())
		mood_heart_img = pickHeartImg(getMood())
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.print('Hunger', 3, 145, 0, 1, 1, 0, 0, 0, 0)
		love.graphics.draw(hunger_heart_img, 70, 180, 0, imageScale)
		love.graphics.print('Happiness', 3, 275, 0, 1, 1, 0, 0, 0, 0)
		love.graphics.draw(mood_heart_img, 70, 310, 0, imageScale)
		love.graphics.print('Age: ' .. getAge(), 3, 455, 0, 1, 1, 0, 0, 0, 0)
	end
end

--function love.quit()
	--implement later??
--end

function drawBackground()
	love.graphics.draw(background_img, 0, 0, 0, 1/2)
end

function drawAlert()
	love.graphics.draw(vpet.alert_img, 150, 200, 0, imageScale)
end

function drawPoo()
	love.graphics.draw(vpet.poo_img, 400, 405, 0, imageScale - 2)
	setPoo(true)
end

function drawSick()
	love.graphics.draw(vpet.sick_img, 350, 200, 0, imageScale)
end

function drawMenu()
	if (state == "game") then
		feedMenu()
		playMenu()
		lampMenu()
		cleanMenu()
		medMenu()
	end
	statsMenu()
end

function pickHeartImg(statIn)
	if (statIn == 0) then
		return no_heart_img
	elseif (statIn == 1) then
		return one_heart_img
	elseif (statIn == 2) then
		return two_heart_img
	elseif (statIn == 3) then
		return three_heart_img
	elseif (statIn == 4) then
		return four_heart_img
	else
		return five_heart_img
	end
end

function feedMenu()
	love.graphics.draw(vpet.feedOff_img, 0, 0, 0, imageScale*2)
	if (checkMouseCollision(0, 0, 10*imageScale*2, 10*imageScale*2)) then
		love.graphics.draw(vpet.feedOn_img, 0, 0, 0, imageScale*2)
	end
end

function playMenu()
	love.graphics.draw(vpet.playOff_img, 100, 0, 0, imageScale*2)
	if (checkMouseCollision(100, 0, 10*imageScale*2, 10*imageScale*2)) then
		love.graphics.draw(vpet.playOn_img, 100, 0, 0, imageScale*2)
	end
end

function lampMenu()
	love.graphics.draw(vpet.lampOff_img, 200, 0, 0, imageScale*2)
	if (checkMouseCollision(200, 0, 10*imageScale*2, 10*imageScale*2)) then
		love.graphics.draw(vpet.lampOn_img, 200, 0, 0, imageScale*2)
	end
end

function cleanMenu()
	love.graphics.draw(vpet.cleanOff_img, 310, 0, 0, imageScale*2)
	if (checkMouseCollision(310, 0, 10*imageScale*2, 10*imageScale*2)) then
		love.graphics.draw(vpet.cleanOn_img, 310, 0, 0, imageScale*2)
	end
end

function medMenu()
	love.graphics.draw(vpet.medOff_img, 410, 0, 0, imageScale*2)
	if (checkMouseCollision(410, 0, 10*imageScale*2, 10*imageScale*2)) then
		love.graphics.draw(vpet.medOn_img, 410, 0, 0, imageScale*2)
	end
end

function statsMenu()
	love.graphics.draw(vpet.statsOff_img, 500, 0, 0, imageScale*2)
	if (checkMouseCollision(500, 0, 10*imageScale*2, 10*imageScale*2)) then
		love.graphics.draw(vpet.statsOn_img, 500, 0, 0, imageScale*2)
	end
end

function toggleState()
	if (state == "game") then
		state = "stats"
	elseif (state == "stats") then
		state = "game"
	end
end

-------------------------------
--  Mouse Control Functions  --
-------------------------------
function checkMouseCollision(x, y, width_x, width_y)
	if ((love.mouse.getX() >= x) 
		and  (love.mouse.getX() <= x+width_x)
		and (love.mouse.getY() >= y)
		and (love.mouse.getY() <= y+width_y)) then
		return true
	end
	return false
end

function love.mousepressed(x, y, button, istouch, presses)
	if (button == 1) then
		if (state == "game") then
			-- feed pet
			if(isHatched() and checkMouseCollision(0, 0, 10*imageScale*2, 10*imageScale*2)) then
				vpet.feed()
			end
			-- play with pet
			if (isHatched() and checkMouseCollision(100, 0, 10*imageScale*2, 10*imageScale*2)) then
				vpet.play()
			end
			-- let pet sleep
			if (isHatched() and checkMouseCollision(200, 0, 10*imageScale*2, 10*imageScale*2)) then
				vpet.sleep()
			end
			-- clean any poo up
			if (isHatched() and checkMouseCollision(310, 0, 10*imageScale*2, 10*imageScale*2)) then
				vpet.clean()
			end
			-- give medicine
			if (isHatched() and checkMouseCollision(410, 0, 10*imageScale*2, 10*imageScale*2)) then
				vpet.giveMeds()
			end
		end
		-- check stats
		if (checkMouseCollision(510, 0, 10*imageScale*2, 10*imageScale*2)) then
			toggleState()
		end
	end
end

------------------------
--  Getter Functions  --
------------------------
function getDebug()
	return debug
end

function getVtime()
	return vtime
end

------------------------
--  Setter Functions  --
------------------------
function setDebug(debugIn)
	debug = debugIn
end

function setVtime(vtimeIn)
	vtime = vtimeIn
end