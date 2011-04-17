CON
  _clkmode = xtal1+pll16x
  _xinfreq = 5_000_000

  'Pinning settings.
  PIN_CS   = 0
  PIN_DAT  = 2
  PIN_WCLK = 1

VAR
  long ClkDelay, ClkState

PUB HT1632_Init()
  dira[PIN_CS]   := 1
  dira[PIN_DAT]  := 1
  dira[PIN_WCLK] := 1

PUB HT1632_WriteBits(bits, firstbit)


