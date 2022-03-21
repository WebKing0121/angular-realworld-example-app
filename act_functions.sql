create procedure cropsByGrowerIdProc(IN userID text)
BEGIN
SELECT DISTINCT
   g.growerID AS growerID,
   g.firstName AS firstName,
   g.lastName AS lastName,
   z.zoneID AS zoneID,
   g.farmName AS farmName,
   g.email AS email,
   g.phoneNumber AS phoneNumber,
   u.userID AS userID,
   g.source AS source,
	json_object('cropID',c.cropID,'plantedAcreage',c.acres) AS crops
FROM GrowerDICT g
inner join UserGrowerTransaction u on (u.growerID = g.growerID AND u.userID = userID)
left join CropTransaction c on (c.growerID = g.growerID AND c.isActive = 1)
inner join ZoneTransaction z on(z.growerID = g.growerID)
where (u.userID = userID AND g.isActive IS TRUE);
END;

create procedure getCropInfoByGrowerIDProc(IN _growerID text)
BEGIN
SELECT DISTINCT
    z.zoneID AS zoneID,
    ct.zonePrice AS cropZonePrice,
    ct.FFMult AS cropFFMult,
    ct.CapMult AS cropCapMult,
    ct.seedZonePrice AS cropSeedZonePrice,
    ct.seedFFMult AS cropSeedFFMult,
    ct.seedCapMult AS cropSeedCapMult,
    c.acres as cropAcreage,
    c.cropID AS cropID
FROM GrowerDICT g
inner join CropTransaction c on (g.growerID = c.growerID)
inner join CropDICT ct on (ct.cropid = c.cropID)
inner join ZoneTransaction z on(z.growerID = g.growerID)
where (g.growerID = _growerID AND g.isActive IS TRUE AND c.isActive IS TRUE);
END;

create procedure getCropPricesAndZoneByGrowerIdProc(IN growerID text, IN planID text)
BEGIN
SELECT DISTINCT
	z.zoneID AS zoneID,
	ct.zonePrice AS cropZonePrice,
	ct.FFMult AS cropFFMult,
	ct.CapMult AS cropCapMult,
	c.acres as cropAcreage,
	c.cropID AS cropID,
	a.productID AS productID,
	a.appliedAcreage AS appliedProductAcreage,
	a.appliedUoM AS appliedProductUoM,
	a.appliedRate AS appliedProductRate,
	pr.price AS productPrice,
	pr.measurementUnit AS productUoM
FROM GrowerDICT g
inner join CropTransaction c on (g.growerID = c.growerID)
inner join CropDICT ct on (ct.cropid = c.cropID)
inner join ZoneTransaction z on(z.growerID = g.growerID)
inner join PlanTransaction p on (g.growerID = p.growerID)
inner join ApplicationTransaction a on (a.planID = p.planID and a.cropID = c.cropID)
inner join ProductDICT pr on (pr.productID = a.productID)
where (g.growerID = growerID AND g.isActive IS TRUE AND c.isActive IS TRUE AND p.planID = planID);
END;

create procedure getCropPricesAndZoneByGrowerIdSeedProc(IN growerID text, IN planID text)
BEGIN
SELECT DISTINCT
	z.zoneID AS zoneID,
	ct.seedZonePrice AS cropZonePrice,
	ct.seedFFMult AS cropFFMult,
	ct.seedCapMult AS cropCapMult,
	c.acres as cropAcreage,
	c.cropID AS cropID,
	a.productID AS productID,
	a.appliedAcreage AS appliedProductAcreage,
	a.appliedUoM AS appliedProductUoM,
	a.appliedRate AS appliedProductRate,
	pr.price AS productPrice,
	pr.measurementUnit AS productUoM
FROM GrowerDICT g
inner join CropTransaction c on (g.growerID = c.growerID)
inner join CropDICT ct on (ct.cropid = c.cropID)
inner join ZoneTransaction z on(z.growerID = g.growerID)
inner join PlanTransaction p on (g.growerID = p.growerID)
inner join SeedApplicationTransaction a on (a.planID = p.planID and a.cropID = c.cropID)
inner join SeedProductDICT pr on (pr.productID = a.productID)
where (g.growerID = growerID AND g.isActive IS TRUE AND c.isActive IS TRUE AND p.planID = planID);
END;

create procedure getSpecialistOrServiceRepProc(IN _userID text)
BEGIN
SELECT srID, specialistID FROM UserToUserTransaction WHERE srID = _userID OR specialistID = _userID;
END;

create procedure getZonesForUser(IN _userID text)
BEGIN
SELECT * FROM UserToZoneTransaction WHERE userID = _userID;
END;

create procedure insertNewCropProc(IN _ctUUID text, IN _cropID text, IN _growerID text, IN _acres text)
BEGIN
INSERT INTO CropTransaction SET ctUUID = _ctUUID, cropID = _cropID, growerID = _growerID, acres = _acres, isActive = 1;
END;

create procedure insertNewGrowerProc(IN _growerID text, IN _firstName text, IN _lastName text, IN _farmName text,
                                     IN _email text, IN _phoneNumber text)
BEGIN
INSERT INTO GrowerDICT SET growerID = _growerID, firstName = _firstName, lastName = _lastName, farmName = _farmName, email = _email, phoneNumber = _phoneNumber;
END;

create procedure insertNewUserProc(IN _userID text, IN _email text, IN _roleID text)
BEGIN
INSERT INTO UserTransaction SET userID = _userID, email = _email, roleID = _roleID;
END;

create procedure insertUserToUserProc(IN _srID text, IN _specialistID text)
BEGIN
INSERT INTO UserToUserTransaction SET srID = _srID, specialistID = _specialistID;
END;

create procedure insertUserToZoneProc(IN _userID text, IN _zoneID text)
BEGIN
INSERT INTO UserToZoneTransaction SET userID = _userID, zoneID = _zoneID;
END;

create procedure insertZoneTransactionByGrowerID(IN _zoneID text, IN _growerID text)
BEGIN
INSERT INTO ZoneTransaction SET zoneID = _zoneID, growerID = _growerID;
END;

create procedure setCropInactiveByGrowerIDProc(IN _growerID text)
BEGIN
UPDATE CropTransaction SET isActive = 0 WHERE growerID = _growerID;
END;

create procedure updateGrowerDICTProc(IN _firstName text, IN _lastName text, IN _farmName text, IN _email text,
                                      IN _phoneNumber text, IN _growerID text)
BEGIN
UPDATE GrowerDICT SET firstName = _firstName, lastName = _lastName, farmName = _farmName, email = _email, phoneNumber = _phoneNumber WHERE growerID = _growerID;
END;

create procedure updateUserIdByEmailProc(IN _userID text, IN _email text)
BEGIN
UPDATE UserTransaction SET userID = _userID WHERE email = _email;
END;

create procedure updateUserToGrowerProc(IN _oldUserID text, IN _newUserID text)
BEGIN
UPDATE UserGrowerTransaction SET userID = _newUserID WHERE userID = _oldUserID;
END;

create procedure updateUserToUserProc(IN _newUserId text, IN _oldUserID text, IN _column text)
BEGIN
SET @query = CONCAT('UPDATE UserToUserTransaction SET ', _column, ' = ? WHERE ', _column, ' = ?');
SET @newUserID = _newUserID;
SET @oldUserID = _oldUserID;
PREPARE query FROM @query;
EXECUTE query USING @newUserID, @oldUserID;
END;

create procedure updateUserToZoneProc(IN _oldUserID text, IN _newUserID text)
BEGIN
UPDATE UserToZoneTransaction SET userID = _newUserID WHERE userID = _oldUserID;
END;

create procedure updateZoneTransactionByGrowerIDProc(IN _zoneID text, IN _growerID text)
BEGIN
UPDATE ZoneTransaction SET zoneID = _zoneID WHERE growerID = _growerID;
END;


