select * 
from PortfolioProject.dbo.NashvilleHousing


---Standardize date format


select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date

Update PortfolioProject.dbo.NashvilleHousing
set SaleDateConverted = CONVERT(Date, SaleDate)


--- Populate Property address data

select * 
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null


select * 
from PortfolioProject.dbo.NashvilleHousing


select x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, ISNULL(x.PropertyAddress, y.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing x
join PortfolioProject.dbo.NashvilleHousing y
on x.ParcelID = y.ParcelID
and x.[UniqueID ] <> y.[UniqueID ]


Update x
set PropertyAddress = ISNULL(x.PropertyAddress, y.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing x
join PortfolioProject.dbo.NashvilleHousing y
on x.ParcelID = y.ParcelID
and x.[UniqueID ] <> y.[UniqueID ]
where x.PropertyAddress is null


--Breaking out the address into individual columns (street, city and state)


select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar (255);

Update PortfolioProject.dbo.NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar (255)

Update PortfolioProject.dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 


select * 
from PortfolioProject.dbo.NashvilleHousing

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar (255);

Update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar (255)

Update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar (255)

Update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



--Change Y and N to Yes and No in the SoldASVacant field

select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


select SoldAsVacant,
CASE when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
from PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
from PortfolioProject.dbo.NashvilleHousing


--Removing Duplicates


WITH ROWNUMCTE AS (
select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			PropertyAddress, 
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
			UniqueID)
			row_num
from PortfolioProject.dbo.NashvilleHousing
)
select * 
from RowNumCTE
where row_num > 1
order by PropertyAddress




--Deleting Unused columns


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP Column OwnerAddress, PropertyAddress, TaxDistrict


select * 
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP Column SaleDate
