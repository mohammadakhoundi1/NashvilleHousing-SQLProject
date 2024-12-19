# NashvilleHousing-SQLProject
Cleaning useful information ,removing duplicates, correcting misinformed formats
## list of all the processes :
- Standardize Date Format 
- Filling null values of property address by finding similar values in fields with the same ParcelID and different UniqueID
--Split propertyadress into Propertysplitaddress and propertysplitcity with SUBSTRRING() and CHARINDEX() 
--Change Y to Yes and N to No in field "SoldAsVacant"
--Remove Duplicates
