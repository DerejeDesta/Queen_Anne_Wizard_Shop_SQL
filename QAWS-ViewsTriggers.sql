-- 1 ----------------------------------------------------------
DROP VIEW IF EXISTS SaleSummaryView;
CREATE VIEW SaleSummaryView AS
      SELECT SALE.SaleID, SALE.SaleDate, SALE_ITEM.Quantity,
             ITEM.ItemDescription, SALE.Total
      FROM SALE 
      JOIN SALE_ITEM ON SALE.SaleID=SALE_ITEM.SaleID
      JOIN ITEM ON SALE_ITEM.SaleID = ITEM.ItemID;
-- Query to return all of the rows

-- ------------------------------------------------------------
-- 2-----------------------------------------------------------
DROP VIEW IF EXISTS CustomerSaleSummaryView;
CREATE VIEW CustomerSaleSummaryView AS
      SELECT SALE.SaleID, SALE.SaleDate, PERSON.LastName,
			PERSON.FirstName, ITEM.ItemDescription,
		    ITEM.ItemPrice
      FROM PERSON 
      JOIN SALE ON PERSON.PersonID = SALE.CustomterPersonID 
      JOIN SALE_ITEM ON SALE.SaleID=SALE_ITEM.SaleID
      JOIN ITEM ON SALE_ITEM.SaleID = ITEM.ItemID
      ORDER BY SALE.SaleId;
-- -------------------------------------------------------------
-- 3------------------------------------------------------------
DROP TRIGGER IF EXISTS CreditCardExpCheck;
DELIMITER //
CREATE TRIGGER CreditCardExpCheck
BEFORE INSERT ON CUSTOMER
FOR EACH ROW
BEGIN
  IF (NEW.CreditCardExpirationDate < CURDATE() ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT= 'trying to add expired credit card ';
  END IF;
END;
//DELIMITER ;


-- --------------------------------------------------------------------------------
-- 4-------------------------------------------------------------------------------

-- InsertSale stored procedure
DROP PROCEDURE IF EXISTS InsertSale;
DELIMITER //
CREATE PROCEDURE InsertSale
(IN newSaleID  INT,
IN newSaleDate  DATE,
IN newCustomerPersonID INT,
IN newEmployeePersonID INT,
IN newQuantity    INT,                  
IN newItemPrice   NUMERIC(9,2),        
IN newExtendedPrice  NUMERIC(9,2),         
IN newItemID  INT )

BEGIN
DECLARE varRowCountSale Int;
DECLARE varSaleItemID Int;
DECLARE varSubTotal NUMERIC(9,2);
DECLARE varTax NUMERIC(9,2);
DECLARE varTotal NUMERIC(9,2);

SELECT  COUNT(*) INTO varRowCountSale
FROM  SALE
WHERE SaleID = newSaleID;

IF(varRowCountSale > 0) THEN
ROLLBACK;
SELECT 'Sale already exists and updated';
END IF;

IF(varRowCountSale = 0) THEN
INSERT INTO SALE (SaleID, SaleDate, SubTotal, Tax, Total, CustomterPersonID, EmployeePersonID)
VALUES(newSaleID, newSaleDate, NULL, NULL, NULL, newCustomerPersonID, newEmployeePersonID);
END IF;

SELECT  COUNT(*) INTO varSaleItemID
FROM  SALE_ITEm
WHERE SaleID = newSaleID;


SET varSaleItemID = varSaleItemID + 1;
CALL InsertSaleItem(newSaleID, varSaleItemID , newQuantity, newItemPrice, newExtendedPrice,newItemID);

SELECT SUM(ExtendedPrice) INTO varSubTotal
FROM SALE_ITEm 
WHERE SaleID = newSaleID;

SET varTax = 0.1 * varSubtotal;
SET varTotal = varSubTotal + varTax;

UPDATE SALE
SET SubTotal = varSubTotal
WHERE SaleID = newSaleID;

UPDATE SALE
SET Tax = varTax
WHERE SaleID = newSaleID;

UPDATE SALE
SET Total = varTotal
WHERE SaleID = newSaleID;

END;
// 
DELIMITER ;


-- InsertSaleItem Stored procedure
DROP PROCEDURE IF EXISTS InsertSaleItem;
DELIMITER //
CREATE PROCEDURE InsertSaleItem
(IN newSaleID  INT,
IN newSaleItemID  INT,
IN newQuantity    INT,                  
IN newItemPrice   NUMERIC(9,2),        
IN newExtendedPrice  NUMERIC(9,2),         
IN newItemID  INT )

BEGIN

INSERT INTO SALE_ITEM
(SaleID, SaleItemID, Quantity, ItemPrice, ExtendedPrice, ItemID)
VALUES
(newSaleID, newSaleItemID, newQuantity, newItemPrice, newExtendedPrice, newItemID);

END;
// 
DELIMITER ;

-- test Stored procedure
call InsertSale(9,'2019-12-01', 12, 5,6,10, 100,10 );
call InsertSale(9,'2019-12-01', 12, 5,6,11, 300,10 );

