-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cleaning Data in SQL Queries

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Project STEPS:
-- 1) Standardized Date Format
-- 2) populate property address data 
-- 3) Breaking out address into two different columns city and address
-- 4) Change Y and N to Yes and No in the 'Sold as Vacant' field
-- 5) Remove Duplicates
-- 6) Delete unused columns

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Standardized Date Format

ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
ADD SaleDateConverted Date;

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- populate property address data 
-- see what is null
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is null
ORDER by parcelID 

-- find a replacement
SELECT na.PropertyAddress, Rep.PropertyAddress, ISNULL(na.PropertyAddress, rep.PropertyAddress)
FROM PortfolioProject..NashvilleHousing as na
JOIN PortfolioProject..NashvilleHousing as Rep
	ON na.ParcelID = Rep.ParcelID
	AND na.[UniqueID ] <> Rep.[UniqueID ]
WHERE na.PropertyAddress is null;

-- Place the na.PropertyAddress with rep.Property Address with the same parcelID but different UniqueIDs
UPDATE na
SET PropertyAddress = ISNULL(na.PropertyAddress, rep.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing na
JOIN PortfolioProject.dbo.NashvilleHousing rep
	on na.ParcelID = rep.ParcelID
	AND na.[UniqueID ] <> rep.[UniqueID ]
WHERE na.PropertyAddress is null

-- Check to see if null values still exist
SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking out address into two different columns city and address

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

-- Determine New Columns

SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as SeperatedAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as SeperatedCity
FROM PortfolioProject.dbo.NashvilleHousing

-- Create new column names and data type

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress VARCHAR(255);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitCity VARCHAR(255);

-- Insert data into new columns

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1);


UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress));

-- Check results

SELECT PropertySplitAddress, PropertySplitCity, PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

-- Split Owners Address using a different method

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3) as OwnerSplitAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'), 2) as OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress,',','.'), 1) as OwnerSplitState
FROM PortfolioProject.dbo.NashvilleHousing

-- Create new columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress varchar(255);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitCity varchar(255);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitState varchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

-- Check Results
SELECT OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM PortfolioProject.dbo.NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in the 'Sold as Vacant' field

-- Identity the need to data cleaning
-- There are 4 data type in a field that has two true values

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) as YN_Count
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- Determine New Cells
SELECT SoldAsVacant,
		CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END
FROM PortfolioProject.dbo.NashvilleHousing

-- Update Values

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = 	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END

-- Check Results

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) as YN_Count
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

-- Identify Duplicates

WITH CTE_Dups as
(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID
	) as row_num
FROM PortfolioProject.dbo.NashvilleHousing
)
SELECT *
FROM CTE_Dups
WHERE row_num > 1

-- DELETE Duplicates

WITH CTE_Dups as
(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID
	) as row_num
FROM PortfolioProject.dbo.NashvilleHousing
)
DELETE
FROM CTE_Dups 
WHERE row_num > 1

-- Check Results

WITH CTE_Dups as
(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID
	) as row_num
FROM PortfolioProject.dbo.NashvilleHousing
)
SELECT *
FROM CTE_Dups 
WHERE row_num > 1

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete unused columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

-- Unused columns: Property Address, Sale Date, OwnerAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict

-- Check Results
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing