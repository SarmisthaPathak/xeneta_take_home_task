/*
Unit Test : test_valid_date_check
Description : In this unit test, it is checked that date should be between 2021-01-01 and 2022-06-01
*/  

select * from final.total_price_usd where VALID_FROM < '2021-01-01' or VALID_TO > '2022-06-01' ; 