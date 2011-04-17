CON
  _clkmode = xtal1+pll16x
  _xinfreq = 5_000_000

  'Pinning settings.
  PIN_CS   = 0
  PIN_DAT  = 2
  PIN_WCLK = 1

  CMD_HT1632_SYS_DIS     = %1000000000000
  CMD_HT1632_SYS_EN      = %100000000010
  CMD_HT1632_LED_OFF     = %100000000100
  CMD_HT1632_LED_ON      = %100000000110
  CMD_HT1632_BLINK_OFF   = $08
  CMD_HT1632_BLINK_ON    = $09
  CMD_HT1632_SLAVE_MODE  = $10
  CMD_HT1632_MASTER_MODE = %100000110000
  CMD_HT1632_EXTCLK      = $1C
  CMD_HT1632_COMS00      = $20
  CMD_HT1632_COMS01      = %100001001000
  CMD_HT1632_COMS10      = $28
  CMD_HT1632_COMS11      = $2C
  CMD_HT1632_PWM         = $A0
  CMD_HT1632_PWM16       = %100101011110

OBJ
  SPI : "SPI_Spin"


PUB main
  repeat
      HT1632_Init
      HT1632_Set2416
      SPI.start(50, 1)
      outa[PIN_CS] := 0
      HT1632_Print
      waitcnt(cnt+(clkfreq/50))
      outa[PIN_CS] := 1
      waitcnt(cnt+(clkfreq/50))


PUB HT1632_Init
  dira[PIN_CS]   := 1
  dira[PIN_DAT]  := 1
  dira[PIN_WCLK] := 1

PUB HT1632_Set2416
  HT1632_Write(CMD_HT1632_SYS_DIS)
  HT1632_Write(CMD_HT1632_COMS01)
  HT1632_Write(CMD_HT1632_MASTER_MODE)
  HT1632_Write(CMD_HT1632_SYS_EN)
  HT1632_Write(CMD_HT1632_LED_ON)
  HT1632_Write(CMD_HT1632_PWM16)

PUB HT1632_Write(command) | i,j
  command := command & $0FFF
  outa[PIN_CS] := 1
  waitcnt(cnt+(CLKFREQ/10000))
  outa[PIN_CS] := 0
  waitcnt(cnt+(CLKFREQ/10000))

  i := 0

  repeat until i == 11
    outa[PIN_WCLK] := 0
    waitcnt(cnt+(CLKFREQ/10000))
    j := command & $0800
    command := command<<1
    j := j>>11

    outa[PIN_DAT] := j
    waitcnt(cnt+(CLKFREQ/10000))
    outa[PIN_WCLK] := 1
    waitcnt(cnt+(CLKFREQ/10000))
    i++

  outa[PIN_CS] := 1

PUB HT1632_AddrWrite(address) | i,temp
  address := address & $7F
  outa[PIN_WCLK] := 0
  waitcnt(cnt+(CLKFREQ/10000))
  outa[PIN_WCLK] := 1
  waitcnt(cnt+(CLKFREQ/10000))
  outa[PIN_WCLK] := 1
  waitcnt(cnt+(CLKFREQ/10000))
  outa[PIN_WCLK] := 0
  waitcnt(cnt+(CLKFREQ/10000))
  outa[PIN_WCLK] := 0
  waitcnt(cnt+(CLKFREQ/10000))
  outa[PIN_WCLK] := 1
  waitcnt(cnt+(CLKFREQ/10000))
  outa[PIN_WCLK] := 0
  waitcnt(cnt+(CLKFREQ/10000))
  outa[PIN_WCLK] := 1
  waitcnt(cnt+(CLKFREQ/10000))
  outa[PIN_WCLK] := 1
  waitcnt(cnt+(CLKFREQ/10000))

  i := 0
  repeat until i == 6
    outa[PIN_WCLK] := 0
    waitcnt(cnt+(CLKFREQ/10000))
    temp := address & $40
    address := address<<1
    temp := temp>>6
    outa[PIN_DAT] := temp
    waitcnt(cnt+(CLKFREQ/10000))
    outa[PIN_WCLK] := 1
    waitcnt(cnt+(CLKFREQ/10000))
    i++

PUB HT1632_Print |i, buff
  HT1632_AddrWrite($00)
  i := 0
  repeat until i == 47
    buff := $AA
    SPI.SHIFTOUT(PIN_DAT, PIN_WCLK, SPI#MSBFIRST, 8, buff)
    i++








