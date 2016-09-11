use LnkSys
go
drop table tCodeList
go
drop table tLimit
go
drop table tLog
go
drop table tMenu
go
drop table tModule
go
drop table tModuleFunc
go
drop table tUser
go

CREATE TABLE tCodeList		--系统代码对照表
(   
	FID			INT  IDENTITY(1, 1)  PRIMARY KEY,
	FType		varchar(20),
	FValue		varchar(20),
	FSort		INT,
	FIsExpired	BIT     
)
go

CREATE TABLE  tLimit		--模块权限表
(   
	FID			INT  IDENTITY(1, 1)  PRIMARY KEY,
	FUserID		INT,
	FMenuID		INT     
)
go

CREATE TABLE tLog			--系统日志
(   
	FID			INT  IDENTITY(1, 1)  PRIMARY KEY,
	FUserID		INT,
	FDate		DATETIME,
	FModule		varchar(60),
	FType		varchar(20),
	FRemark		varchar(5000)   
)
go

CREATE TABLE tMenu			--菜单表
(   
	FID			INT  IDENTITY(1, 1)  PRIMARY KEY,
	FName		varchar(20),
	FFID		INT,
	FIsEnd		INT,
	FModuleID	INT,
	FSort		INT,
	FLevel		INT,
	FRemark		varchar(200),
	FIsExpired	BIT      
)
go

CREATE TABLE tModule		--模块表
(
	FID			INT  IDENTITY(1, 1)  PRIMARY KEY,   
	FCode		char(20),
	FName		varchar(20),
	FPath		varchar(60),
	FIsExpired	BIT
)
go

CREATE TABLE tModuleFunc	--模块功能表
(   
	FID				INT  IDENTITY(1, 1)  PRIMARY KEY,
	FModuleID		INT,
	FFuncCaption	varchar(20)      
)
go

CREATE TABLE tUser			--用户表
(   
	FID				INT  IDENTITY(1, 1)  PRIMARY KEY,
	FCode			varchar(20),
	FName			varchar(20),
	FType			varchar(20),
	FPsw			varchar(20),
	FQMID			INT,
	FRegDate		DATETIME,
	FLogoutDate		DATETIME,
	FMobile			varchar(20),
	FQQ				varchar(20),
	FRemark			varchar(200),
	FIsCheck		BIT,
	FIsExpired		BIT
)
go

drop table tFuncLimit;
create table tFuncLimit(
	FID				INT  IDENTITY(1, 1)  PRIMARY KEY,
	FUserID			INT,
	FModuleFuncID	INT  
)

create table tQuickMenu(
	FID			INT  IDENTITY(1, 1)  PRIMARY KEY,
	FUserID		INT,
	FMenuID		INT  
)