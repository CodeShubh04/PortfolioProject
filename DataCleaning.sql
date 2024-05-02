select * from PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing add SaleDateConverted Date;

Update NashvilleHousing set SaleDateConverted = CONVERT(date, SaleDate)

select SaleDateConverted, CONVERT(date, SaleDate) from PortfolioProject..NashvilleHousing

select * from PortfolioProject..NashvilleHousing order by ParcelID

Update a SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
from PortfolioProject..NashvilleHousing a join PortfolioProject..NashvilleHousing b 
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) from PortfolioProject..NashvilleHousing a 
join PortfolioProject..NashvilleHousing b on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ] where a.PropertyAddress is null

select PropertyAddress from PortfolioProject..NashvilleHousing

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address ,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing add PropertySplitAddress NVARCHAR(255);
Update NashvilleHousing set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table NashvilleHousing add PropertySplitCity NVARCHAR(255);
Update NashvilleHousing set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select * from PortfolioProject..NashvilleHousing

Select PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1) from PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing add OwnerSplitAddress NVARCHAR(255);
Update NashvilleHousing set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter Table NashvilleHousing add OwnerSplitCity NVARCHAR(255);
Update NashvilleHousing set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Alter Table NashvilleHousing add OwnerSplitState NVARCHAR(255);
Update NashvilleHousing set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)

Select * from PortfolioProject..NashvilleHousing

select Distinct(SoldAsVacant), COUNT(SoldAsVacant) from PortfolioProject..NashvilleHousing Group by SoldAsVacant order by 2

Select SoldAsVacant ,
Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 END
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
				   When SoldAsVacant = 'N' Then 'No'
				   Else SoldAsVacant
				   END

select Distinct(SoldAsVacant), COUNT(SoldAsVacant) from PortfolioProject..NashvilleHousing Group by SoldAsVacant order by 2

With RowNumCTE as(
Select * , ROW_NUMBER() Over (Partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference Order by UniqueID) row_num
from PortfolioProject..NashvilleHousing )
select * from RowNumCTE where row_num > 1
--order by PropertyAddress
--Delete from RowNumCTE where row_num > 1

Alter Table PortfolioProject..NashvilleHousing 
Drop Column PropertyAddress, OwnerAddress, TaxDistrict, SaleDate

Select * from PortfolioProject..NashvilleHousing