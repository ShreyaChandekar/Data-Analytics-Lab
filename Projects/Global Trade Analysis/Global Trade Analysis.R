summary(trade1)

trade1$miss_val = NULL

trade1$miss_val = ifelse((trade1$weight_kg < 1 & trade1$quantity < 1), 1, 0)
table(trade1$miss_val)
prop.table(table(trade1$miss_val))

trade_amt_miss = filter(trade1, miss_val == 1)
sum(trade_amt_miss$trade_usd)

trade_amt = filter(trade1, miss_val == 0)
sum(trade_amt$trade_usd)

tradeamt = sum(trade_amt$trade_usd) - sum(trade_amt_miss$trade_usd)

tradeamtmiss_aus = filter(trade1, country_or_area == "Australia", miss_val == 1)
sum(tradeamtmiss_aus$trade_usd)

tradeamt_aus = filter(trade1, country_or_area == "Australia", miss_val == 0)
sum(tradeamt_aus$trade_usd)

totaltradeamt_aus = sum(tradeamt_aus$trade_usd) - sum(tradeamtmiss_aus$trade_usd)

tradeamtmiss_can = filter(trade1, country_or_area == "Canada", miss_val == 1)
sum(tradeamtmiss_can$trade_usd)

tradeamt_can = filter(trade1, country_or_area == "Canada", miss_val == 0)
sum(tradeamt_can$trade_usd)

totaltradeamt_can = sum(tradeamt_can$trade_usd) - sum(tradeamtmiss_can$trade_usd)

tradeamtmiss_usa = filter(trade1, country_or_area == "USA", miss_val == 1)
sum(tradeamtmiss_usa$trade_usd)

tradeamt_usa = filter(trade1, country_or_area == "USA", miss_val == 0)
sum(tradeamt_usa$trade_usd)

totaltradeamt_usa = sum(tradeamt_usa$trade_usd) - sum(tradeamtmiss_usa$trade_usd)

global_trade = na.omit(trade1)

write.csv(global_trade, "global trade.csv")
