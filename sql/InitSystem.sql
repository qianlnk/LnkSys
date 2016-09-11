--Init System data
--用户初始化
insert into tUser
values( 'xiezj','谢振家',	'管理员','123456',NULL,'2014-08-08 21:33:27.060',NULL,'18950498839','405790115',NULL,'False','True');
--菜单初始化
insert into tMenu
values('基础资料',0,0,0,1,1,NULL,'False');
insert into tMenu
values('系统配置',1,0,0,1,2,NULL,'False');
insert into tMenu
values('权限管理',2,1,1,1,3,NULL,'False');
--权限初始化
insert into tLimit
values(1,1);
insert into tLimit
values(1,2);
insert into tLimit
values(1,3);
--模块初始化  这个不做具体模块 直接在sql中加入
insert into tModule
values('qxglbylnk00000000000','权限管理','qxgl','False');
insert into tModule
values('xtdmbylnk00000000000','系统代码','xtdm','False');
insert into tModule
values('xtrzbylnk00000000000','系统日志','xtrz','False');
insert into tModule
values('lnkDll0001','模块Demo','lnkDll','False');