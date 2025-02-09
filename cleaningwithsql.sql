-- Cleaning Data Using SQL  

-- Checking the Initial Dataset  

SELECT * FROM dataset;  

-- Filling in Missing Property Address Data  

UPDATE dataset AS a  
SET PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)  
FROM dataset AS b  
WHERE a.ParcelID = b.ParcelID  
AND a.UniqueID <> b.UniqueID  
AND a.PropertyAddress IS NULL;  

-- Splitting Property Address into Address and City  

SELECT PropertyAddress,  
SUBSTRING(PropertyAddress FROM 1 FOR POSITION(',' IN PropertyAddress) - 1) AS Address,  
TRIM(SUBSTRING(PropertyAddress FROM POSITION(',' IN PropertyAddress) + 1)) AS City  
FROM dataset;  

-- Adding and Populating Separate Columns for Property Address and City  

ALTER TABLE dataset ADD PropertySplitCity VARCHAR;  

UPDATE dataset  
SET PropertySplitCity = TRIM(SUBSTRING(PropertyAddress FROM POSITION(',' IN PropertyAddress) + 1));  

ALTER TABLE dataset ADD PropertySplitAddress VARCHAR;  

UPDATE dataset  
SET PropertySplitAddress = SUBSTRING(PropertyAddress FROM 1 FOR POSITION(',' IN PropertyAddress) - 1);  

-- Checking new columns

SELECT  
PropertyAddress,  
PropertySplitAddress,  
PropertySplitCity  
FROM dataset;  

-- Splitting Owner Address into Address, City, and State  

SELECT  
OwnerAddress,  
SPLIT_PART(OwnerAddress, ',', 1) AS OwnerStreet,  
SPLIT_PART(OwnerAddress, ',', 2) AS OwnerCity,  
SPLIT_PART(OwnerAddress, ',', 3) AS OwnerState  
FROM dataset;  

-- Adding and Populating Separate Columns for Owner Address  

ALTER TABLE dataset ADD OwnerSplitAddress VARCHAR;  

UPDATE dataset  
SET OwnerSplitAddress = SPLIT_PART(OwnerAddress, ',', 1);  

ALTER TABLE dataset ADD OwnerSplitCity VARCHAR;  

UPDATE dataset  
SET OwnerSplitCity = SPLIT_PART(OwnerAddress, ',', 2);  

ALTER TABLE dataset ADD OwnerSplitState VARCHAR;  

UPDATE dataset  
SET OwnerSplitState = SPLIT_PART(OwnerAddress, ',', 3);  

-- Checking new columns

SELECT  
OwnerAddress,  
OwnerSplitAddress,  
OwnerSplitCity,  
OwnerSplitState  
FROM dataset;  

-- Standardizing "Sold as Vacant" Values (Y/N to Yes/No)  

UPDATE dataset  
SET SoldAsVacant =CASE  
WHEN SoldAsVacant = 'Y' THEN 'Yes'  
WHEN SoldAsVacant = 'N' THEN 'No'  
ELSE SoldAsVacant  
END;  

SELECT SoldAsVacant FROM dataset;  

-- Removing Unnecessary Columns  

ALTER TABLE dataset DROP COLUMN TaxDistrict;  

-- Final Dataset Check  
SELECT * FROM dataset;  
