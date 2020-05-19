create table Transactions(ID integer, D_DATE DATE, CHN_ID integer, Amount integer, MERCH varchar(100), CITY varchar(100));
insert into Transactions(id, D_DATE, CHN_ID, Amount, MERCH, CITY) values(101, STR_TO_DATE('01.12.2019', '%d.%m.%Y'), 1, 100, 'Merch1', 'Moscow');
insert into Transactions(id, D_DATE, CHN_ID, Amount, MERCH, CITY) values(102, STR_TO_DATE('04.11.2019', '%d.%m.%Y'), 2, 500, 'Merch2', 'MOSCOW');
insert into Transactions(id, D_DATE, CHN_ID, Amount, MERCH, CITY) values(103, STR_TO_DATE('12.12.2019', '%d.%m.%Y'), 4, 700, 'Merch1', 'Samara');
insert into Transactions(id, D_DATE, CHN_ID, Amount, MERCH, CITY) values(104, STR_TO_DATE('01.12.2019', '%d.%m.%Y'), 3, 200, 'Merch3', 'Moscow');
insert into Transactions(id, D_DATE, CHN_ID, Amount, MERCH, CITY) values(105, STR_TO_DATE('18.12.2019', '%d.%m.%Y'), 3, 300, 'Merch3', 'SamAra');
insert into Transactions(id, D_DATE, CHN_ID, Amount, MERCH, CITY) values(106, STR_TO_DATE('20.12.2019', '%d.%m.%Y'), 4, 500, 'Merch2', 'Volgograd');
insert into Transactions(id, D_DATE, CHN_ID, Amount, MERCH, CITY) values(107, STR_TO_DATE('04.12.2019', '%d.%m.%Y'), 4, 400, 'Merch4', 'Moscow');
insert into Transactions(id, D_DATE, CHN_ID, Amount, MERCH, CITY) values(108, STR_TO_DATE('07.12.2019', '%d.%m.%Y'), 4, 400, 'Merch5', 'MoScow');

create table Transaction_successful(ID integer, PRODUCT varchar(100));
insert into Transaction_successful(ID, PRODUCT) values(101, 'aso');
insert into Transaction_successful(ID, PRODUCT) values(102, 'pos');
insert into Transaction_successful(ID, PRODUCT) values(103, 'aso');
insert into Transaction_successful(ID, PRODUCT) values(104, 'pos');
insert into Transaction_successful(ID, PRODUCT) values(105, 'aso');
insert into Transaction_successful(ID, PRODUCT) values(110, 'aso');
insert into Transaction_successful(ID, PRODUCT) values(112, 'pos');
insert into Transaction_successful(ID, PRODUCT) values(108, 'aso');

create table Merch_tariff(MERCH varchar(100), CHN_ID integer, TARIFF varchar(100));
insert into Merch_tariff(MERCH, CHN_ID, TARIFF) values('Merch1', 1, '1,2 мин. 20 руб.');
insert into Merch_tariff(MERCH, CHN_ID, TARIFF) values('Merch1', NULL, '1%');
insert into Merch_tariff(MERCH, CHN_ID, TARIFF) values('Merch2', NULL, '2%');
insert into Merch_tariff(MERCH, CHN_ID, TARIFF) values('Merch3', 3, '1,4% мин. 12 руб.');
insert into Merch_tariff(MERCH, CHN_ID, TARIFF) values('Merch4', 34, '2% макс. 50 руб.');

/* 1. Получить из таблицы Transaction всю информацию только по успешныем операциям 
+ PRODUCT  через каторый этот платеж прошел */
SELECT * 
    FROM Transactions 
        INNER JOIN Transaction_successful 
        ON Transactions.id = Transaction_successful.ID;
        
/* 2. Вывести только те транзакции, где city = Москва (в любом написании) и product = aso */
SELECT * 
    FROM Transactions 
        INNER JOIN Transaction_successful 
        ON Transactions.id=Transaction_successful.ID
    WHERE PRODUCT = 'aso' AND CITY LIKE '%Moscow%'

/* 3. Выгрузить по месяцам сумму платежей и  суммарное количество транзакций в разрезе мерчантов, 
у которых суммарное количество платежей от 2 и больше и отсортировать в порядке возрастания по сумме платежей */   
SELECT MERCH, MONTH(D_DATE), sum(Amount)
    FROM Transactions
GROUP BY MERCH, MONTH(D_DATE)
HAVING (COUNT(Amount) > 1)
ORDER BY sum(Amount) ASC

/* 4. Вывести всю информацию(все поля)по каждой транзакции из таблицы Transactions и 
добавить 3 дополниетельных поля в которых будут посчитаны: 
1. Количество всех транзакций в таблице Transactions
2. Сумма всех платежей в городе в котором прошла данная транзакция
3. Долю транзакции от суммы всех платежей в аналогичном городе */
SELECT *, 
    (SELECT COUNT(ID) FROM Transactions), 
    (SELECT SUM(Amount) FROM Transactions AS T1 WHERE T2.CITY = T1.CITY) as sm,
    (SELECT T2.Amount / sm)
FROM Transactions AS T2

/* 5. Одним запросом получить все транзакции, котоые есть в Transactions, но нет в Transaction_sucsessfull и 
наоборот есть в  Transaction_sucsessfull и нет в Transactions */
SELECT Transactions.ID, Transaction_successful.ID 
    FROM Transactions
        FULL OUTER JOIN Transaction_successful 
        ON Transactions.ID = Transaction_successful.ID
WHERE (Transactions.ID = NULL) != (Transaction_successful.ID = NULL)
/* ИЛИ */
SELECT T.ID 
    FROM Transactions T
        LEFT JOIN Transaction_successful TS ON T.ID = TS.ID
    WHERE (TS.ID = NULL)
UNION
SELECT TS.ID 
    FROM Transaction_successful TS
        RIGHT JOIN Transactions T ON TS.ID = T.ID;
WHERE (TS.ID = NULL)
