DROP DATABASE IF EXISTS QAWS ;
CREATE DATABASE QAWS;
USE QAWS;

DROP TABLE IF EXISTS PERSON;
CREATE TABLE PERSON(PersonID 		INT NOT 		NULL,
                    isEmployee 		CHAR(4) 		NOT NULL,
                    isCustomer 		CHAR(4) 		NOT NULL,
                    LastName 		CHAR(25) 		NOT NULL,
                    FirstName 		CHAR(25) 		NOT NULL ,
                    Address 		CHAR(35) 		NULL,
					City 			CHAR(35) 		NULL,
                    State 			CHAR(2) 		NULL,
                    ZIP 			CHAR(10) 		NULL,
                    Phone 			CHAR(12) 		NOT NULL,
                    Email		    VARCHAR(100)  	NULL,
				    CONSTRAINT      PersonIDPK      PRIMARY KEY (PersonID)
                    );
					  
                      
DROP TABLE IF EXISTS CUSTOMER;
CREATE TABLE CUSTOMER(PersonID 					INT 			NOT NULL,
					CreditCardType 				CHAR(25) 		NOT NULL,
					CreditCardNumber			VARCHAR(30) 	NOT NULL,
					CreditCardExpirationDate 	DATE 			NOT NULL,
                    CONSTRAINT  				CustomerPersonIDPK      PRIMARY KEY(PersonID),
                    CONSTRAINT                  CustomerPersonIDFK      FOREIGN KEY(PersonID)
                                     REFERENCES PERSON(PersonID)
                                          ON UPDATE NO ACTION
                                          ON DELETE CASCADE
					);
                     
					  
DROP TABLE IF EXISTS EMPLOYEE;
CREATE TABLE EMPLOYEE(PersonID 			INT		 					NOT NULL,
					DateOfHire 			DATE 						NOT NULL,
					HourlyPayRate       NUMERIC(9,2) 				NOT NULL,
                    CONSTRAINT          EmployeePersonIDPK          PRIMARY KEY(PersonID),
                    CONSTRAINT          EmployeePersonIDFK      	FOREIGN KEY(PersonID)
                                     REFERENCES PERSON(PersonID)
                                          ON UPDATE NO ACTION
                                          ON DELETE CASCADE
					);
                                  
                      
DROP TABLE IF EXISTS SALE;
CREATE TABLE SALE(  SaleID 					INT 			   		NOT NULL,
					SaleDate 				DATE 			   		NOT NULL,
					SubTotal 				NUMERIC(9,2) 			NULL,
					Tax 					NUMERIC(9,2) 			NULL,
					Total 					NUMERIC(9,2) 			NULL,
					CustomterPersonID 		INT 					NOT NULL,
					EmployeePersonID 		INT 					NOT NULL,
					CONSTRAINT              SaleIDPK          		PRIMARY KEY(SaleID),
                    CONSTRAINT             SaleCustomerPersonIDFK      	FOREIGN KEY(CustomterPersonID)
                                     REFERENCES CUSTOMER(PersonID)
                                          ON UPDATE NO ACTION
                                          ON DELETE NO ACTION,
                    CONSTRAINT             SaleEmployeePersonIDFK      	FOREIGN KEY(EmployeePersonID)
                                     REFERENCES Employee(PersonID)
                                          ON UPDATE NO ACTION
                                          ON DELETE NO ACTION                    
                                          
					);
                      
DROP TABLE IF EXISTS VENDOR;
CREATE TABLE VENDOR( VendorID 					INT                		NOT NULL,
				   CompanyName			 		VARCHAR(100)       		NULL,
				   ContactLastName 				CHAR(25)           		NOT NULL,
				   ContactFirstName 			CHAR(25)           		NOT NULL,
				   Address 						CHAR(35)           		NULL,
				   City 						CHAR(35)           		NULL,
				   State 					    CHAR(2)            		NULL,
				   ZIP                          CHAR(10)           		NULL,
				   Phone                        CHAR(12)           		NOT NULL,
				   Fax                          CHAR(12)           		NULL,
				   Email                        VARCHAR(100)       		NULL,
                   CONSTRAINT                   VendorIDPK    PRIMARY KEY(VendorID)
                  ); 
                  
                  
 DROP TABLE IF EXISTS ITEM;
CREATE TABLE ITEM(ItemID      				    INT                     NOT NULL,
					ItemDescription 			VARCHAR(255) 			NOT NULL,
					ReorderPointQuantity 		INT  					NULL,
					QuantityOnHand 				INT 					NULL,
					ItemPrice                   NUMERIC(9,2)  			NOT NULL,
                    CONSTRAINT                  ItemIDPK               PRIMARY KEY(ItemID)
                  );
                  
                  
DROP TABLE IF EXISTS SALE_ITEM;
CREATE TABLE SALE_ITEM( SaleID                     INT                  NOT NULL,
					    SaleItemID                 INT                  NOT NULL,
					    Quantity                   INT                  NOT NULL,
						ItemPrice                  NUMERIC(9,2)         NULL,
						ExtendedPrice              NUMERIC(9,2)         NULL,
						ItemID                     INT                  NOT NULL,
                        CONSTRAINT              SaleIDSaleItemIDPK      PRIMARY KEY(SaleID, SaleItemID),
                        CONSTRAINT              SaleItemSaleIDFK      	FOREIGN KEY(SaleID)
                                     REFERENCES SALE(saleID)
                                          ON UPDATE NO ACTION
                                          ON DELETE CASCADE,
                        CONSTRAINT             SaleItemItedmIDFK      	FOREIGN KEY(ItemID)
                                     REFERENCES ITEM(ItemID)
                                          ON UPDATE NO ACTION
                                          ON DELETE NO ACTION                    
                                          
					);
                      
DROP TABLE IF EXISTS `ORDER`;
CREATE TABLE `ORDER`(InvoiceNumber 					INT 							NOT NULL,
					DateOrdered    					DATE 							NOT NULL,
					DateReceived 					DATE 							NULL,
					QuantityOrdered 				INT 							NOT NULL,
					ItemCost      					NUMERIC(9,2) 					NOT NULL,
					OrderSubTotal					NUMERIC(9,2) 					NOT NULL,
					OrderTax           				NUMERIC(9,2) 					NOT NULL,
					OrderTotalCost					NUMERIC(9,2) 					NOT NULL,
					ItemID 						    INT 							NOT NULL,
					VendorID 					    INT 				 			NOT NULL,
					CONSTRAINT                      OrderInvoiceNumberPK            PRIMARY KEY(InvoiceNumber),
				    CONSTRAINT                      OrderItemIDDFK      	        FOREIGN KEY(ItemID)
                                     REFERENCES Item(ItemID) 
                                          ON UPDATE NO ACTION
                                          ON DELETE NO ACTION,
				    CONSTRAINT            OrderVendorIDFK      	                    FOREIGN KEY(VendorID)
                                     REFERENCES VENDOR(VendorID)
                                          ON UPDATE NO ACTION
                                          ON DELETE NO ACTION     
                      );