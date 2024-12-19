
--Standardize date format
Go
Alter table [NashvilHousing]
add SaleDateConverted Date;
GO

Update [NashvilHousing]
SET SaleDateConverted = CONVERT(Date,SaleDate);

--populate property address data


Update a
Set a.PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
From [NashvilHousing] a
Join [NashvilHousing] b 
  On a.ParcelID = b.ParcelID
  where a.[UniqueID ] <> b.[UniqueID ]
  AND a.PropertyAddress is null

--breaking out address into individual columns

Go
 Alter table Nashvilhousing 
 Add PropertyAdress Nvarchar(255)
 GO

 Go

  Alter table Nashvilhousing 
 Add PropertyCity Nvarchar(255)

 Go

 Update NashvilHousing
 SET PropertyCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
 From Portfolio..NashvilHousing


  Update NashvilHousing
 SET PropertyAdress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
 From Portfolio..NashvilHousing

 --breaking out owneraddress into individual columns

GO
Alter table NashvilHousing 
Add OwnerSpecificAddress Nvarchar(255)
GO

GO
Alter table NashvilHousing 
Add OwnerCity Nvarchar(255)
GO

GO
Alter table NashvilHousing 
Add OwnerState Nvarchar(255)
GO

Update NashvilHousing
 Set OwnerAddress = REPLACE(OwnerAddress,',','.')

Update NashvilHousing 
 Set OwnerState = PARSENAME(OwnerAddress,1)
 From Portfolio..NashvilHousing

Update NashvilHousing 
 Set OwnerCity = PARSENAME(OwnerAddress,2)
 From Portfolio..NashvilHousing

Update NashvilHousing 
 Set OwnerSpecificAddress = PARSENAME(OwnerAddress,3)
 From Portfolio..NashvilHousing

 --Change Y to Yes and N to No in field "SoldAsVacant"

 Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
 From NashvilHousing
 Group by SoldAsVacant
 Order by 2 

 Select SoldAsVacant,
 Case 
   When SoldAsVacant = 'Y' Then 'Yes'
   When SoldAsVacant = 'N' Then 'No'
  Else SoldAsVacant
 End
  From Portfolio..NashvilHousing

Update NashvilHousing
Set SoldAsVacant = Case 
   When SoldAsVacant = 'Y' Then 'Yes'
   When SoldAsVacant = 'N' Then 'No'
  Else SoldAsVacant
 End
  From Portfolio..NashvilHousing

--Remove Duplicates 


With RowNumCTE
As(
Select *, ROW_NUMBER()OVER(Partition By
ParcelID ,
PropertyAddress,
SaleDate,
SalePrice,
LegalReference 
order by ParcelID) Row_num
From Portfolio.dbo.NashvilHousing
)
Delete 
From RowNumCTE
Where Row_num>1;



--Delete Unused Columns
Alter table Portfolio.dbo.NashvilHousing
Drop Column TaxDistrict