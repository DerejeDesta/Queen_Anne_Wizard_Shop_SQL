UPDATE ITEM
     SET QuantityOnHand = 30  -- 20+ 10(returned items)
     WHERE ItemID = 6 ;
     
INSERT INTO ITEM
(ItemID, ItemDescription, ReorderPointQuantity, QuantityOnHand, ItemPrice)
VALUES
(17,'Magic Candles',NULL,	5,	10.00);

INSERT INTO SALE
(SaleID, SaleDate, SubTotal, Tax, Total, CustomterPersonID, EmployeePersonID)
VALUES
(8,	'2019-03-08', 50.00, 5.00, 55.00, 10,	2);

INSERT INTO SALE_ITEM
(SaleID, SaleItemID, Quantity, ItemPrice, ExtendedPrice, ItemID)
VALUES
(8,	1,	5,	10.00, 50.00,	17);

DELETE 
FROM SALE 
WHERE SaleID=8;
-- YES, this delete operation will delete the one in the SALE_ITEM table because
-- the SaleID in SALE_ITEM table references the SaleID in SALE table which "CASCADE" On Delete 
