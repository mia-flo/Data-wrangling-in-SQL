--data cleaning
	--56477 data points
SELECT * FROM [Nashville Housing Data for Data Cleaning]; 

--null values in the property address column
	--a lot of null values in the OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath fields
SELECT * 
FROM [Nashville Housing Data for Data Cleaning] 
WHERE PropertyAddress IS NULL
ORDER BY ParcelID DESC; 


--populating null values in the PropertyAddress
	--if there are two entries where the parcelID is the same but one is missing the property address, the property address can be populated from the other entry with the same parcel id
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Nashville Housing Data for Data Cleaning] a
JOIN [Nashville Housing Data for Data Cleaning] b
	ON a.ParcelID = b.ParcelID
WHERE a.UniqueID <> b.UniqueID
	AND a.PropertyAddress IS NULL;



--extracting the year from the sale date and creating a new column
ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD [SaleYear] INT;


UPDATE [Nashville Housing Data for Data Cleaning]
SET [SaleYear] = SUBSTRING(CAST(SaleDate AS nvarchar(50)),1,4);



--extracting the city and from the property address into its own column using SUBSTRING methods
	--street address
ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD StreetAddress NVARCHAR(255);

	--city
ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD City NVARCHAR(255);


	--street address
UPDATE [Nashville Housing Data for Data Cleaning]
SET StreetAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);


	--city
UPDATE [Nashville Housing Data for Data Cleaning]
SET City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress));




--splitting the owner address column using the PARSENAME method
	--owner street address
ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD OwnerStreetAddress NVARCHAR(255);

	--owner city
ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD OwnerCity NVARCHAR(255);

	--owner street address
UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3);

	--owner city
UPDATE [Nashville Housing Data for Data Cleaning]
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2);




--no duplicates found in the UniqueID column
SELECT
	COUNT(UniqueID)
FROM [Nashville Housing Data for Data Cleaning]
GROUP BY UniqueID
HAVING COUNT(UniqueID) > 1;

