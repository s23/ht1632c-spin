' A preliminary skeleton for the HT1632C driver.


PUB start(firstPin)
	cog := cognew(@ControlTask, 0)

PUB stop
	if cog
		cogstop(cog~ -1)

DAT ORG 0

ControlTask nop
