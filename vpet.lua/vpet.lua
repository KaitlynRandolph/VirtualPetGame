-- Virtual Pet object implementation
-- Author: Kaitlyn Randolph
-- 12/24/18
-- current project: set up second "stats checking" state

-----------------------
--  Global Variables --
-----------------------
illnessCount = 0

----------------------
--  Vpet Functions  --
----------------------
function vpet.newEgg()
	vpet.hunger = 0
	vpet.mood = 0
	vpet.energy = 100
	vpet.bladder = 100
	vpet.poo = false
	vpet.sick = false
	vpet.age = 0
	vpet.image = love.graphics.newImage('Textures/egg.png')
end

function vpet.hatch()
	if (getVtime() >= 10) then
		vpet.image = love.graphics.newImage('Textures/eggboy.png')
		setHatched(true)
		setCare(true)
	end
end

function vpet.needsPoo()
	if (getBladder() == 0) then
		return true
	else 
		return false
	end
end

function vpet.update(dt)
	if (not isHatched()) then
		vpet.hatch()
	elseif (isHatched()) then
		vpet.checkNeeds()
		-- updates needs every 20 seconds (set to 21)
		if (math.floor(getVtime()) % 3 == 0) then
			if (didPoo()) then
				setIllCount(getIllCount() + 1)
				if (getIllCount() == 5) then
					setSick(true)
				end
			end
			setHunger(getHunger() - 1)
			setMood(getMood() - 1)
			setEnergy(getEnergy() - 10)
			setBladder(getBladder() - 25)
			-- reset count
			setVtime(1)
		end
	end
end

-----------------------
--  Needs Functions  --
-----------------------
function vpet.checkNeeds()
	if (vpet.isHungry()
		or vpet.isBored()
		or vpet.isTired()
		or vpet.isSick()
		or vpet.needsBathroom()) then
		setCare(true)
	else setCare(false)
	end
end

function vpet.isHungry()
	if (getHunger() < 5) then
		return true
	end
	return false
end

function vpet.isBored()
	if (getMood() < 5) then
		return true
	end
	return false
end

function vpet.isTired()
	if (getEnergy() <= 25) then
		return true
	end
	return false
end

function vpet.isSick()
	return vpet.sick
end

function vpet.needsBathroom()
	if (getBladder() <= 25) then
		return true
	else
		return false
	end
end

----------------------
--  Care Functions  --
----------------------
function vpet.feed()
	setHunger(getHunger() + 1)
end

function vpet.play()
	setMood(getMood() + 1)
end

function vpet.giveMeds()
	if (vpet.isSick()) then
		setSick(false)
		setIllCount(0)
	end
end

--function vpet.lightsOff()
	--implement later
--end

function vpet.sleep()
	setEnergy(100)
	setAge(getAge() + 1)
end

function vpet.clean()
	if (getBladder() == 0) then
		setBladder(100)
		setPoo(false)
	end
end

------------------------
--  Getter Functions  --
------------------------
function getHunger()
	return vpet.hunger
end

function getMood()
	return vpet.mood
end

function getEnergy()
	return vpet.energy
end

function getBladder()
	return vpet.bladder
end

function isHatched()
	return vpet.hatched
end

function needCare()
	return vpet.needCare
end

function didPoo()
	return vpet.poo
end

function getIllCount()
	return illnessCount
end

function getAge()
	return vpet.age
end

------------------------
--  Setter Functions  --
------------------------
function setHunger(hungerIn)
	if (hungerIn < 0) then
		vpet.hunger = 0
	elseif (hungerIn > 5) then
		setHunger(5)
	else
		vpet.hunger = hungerIn
	end
end

function setMood(moodIn)
	if (moodIn < 0) then
		vpet.mood = 0
	elseif (moodIn > 5) then
		vpet.mood = 5
	else
		vpet.mood = moodIn
	end
end

function setEnergy(energyIn)
	if (energyIn < 0) then
		vpet.energy = 0
	else
		vpet.energy = energyIn
	end
end

function setBladder(bladderIn)
	if (bladderIn < 0) then
		vpet.bladder = 0
	--elseif (bladderIn == 0) then
		-- poo
		--setBladder(100)
	else
		vpet.bladder = bladderIn
	end
end

function setHatched(hatchedIn)
	vpet.hatched = hatchedIn
end

function setCare(careIn)
	vpet.needCare = careIn
end

function setPoo(pooIn)
	vpet.poo = pooIn
end

function setIllCount(countIn)
	if (countIn > 5) then
		illnessCount = 5
	else
		illnessCount = countIn
	end
end

function setSick(sickIn)
	vpet.sick = sickIn
end

function setAge(ageIn)
	vpet.age = ageIn
end