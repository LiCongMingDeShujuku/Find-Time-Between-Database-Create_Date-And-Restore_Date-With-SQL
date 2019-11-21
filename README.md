![CLEVER DATA GIT REPO](https://raw.githubusercontent.com/LiCongMingDeShujuku/git-resources/master/0-clever-data-github.png "李聪明的数据库")

# 查找数据库Create_Date和Restore_Date之间的时间 SQL
#### Find Time Between Database Create_Date And Restore_Date With SQL
**发布-日期: 2015年9月18日 (评论)**

![#](images/##############?raw=true "#")

## Contents

- [中文](#中文)
- [English](#English)
- [SQL Logic](#Logic)
- [Build Info](#Build-Info)
- [Author](#Author)
- [License](#License) 


## 中文
下面是一些将显示创建数据库（create_date）和恢复数据库（restore_date）之间时间的sql逻辑（logic）。


## English
Here’s some sql logic that will show you the time between when a database was created (create_date), and when it was restored (restore_date).

---
## Logic
```SQL
with last_restored as
(
select
databasename = sd.[name]
,   sd.[create_date]
,   sd.[compatibility_level]
,   sd.[collation_name]
,   rh.*
,   rownum = row_number() over (partition by sd.name order by rh.[restore_date] desc) from
master.sys.databases sd left outer join msdb.dbo.[restorehistory] rh on rh.[destination_database_name] = sd.name join master.sys.database_mirroring sdm on sd.database_id = sdm.database_id --where
--sd.database_id > 4
--and   sd.state_desc = 'online'
--and   sdm.mirroring_role_desc is null
--or    sdm.mirroring_role_desc != 'mirror'
)
select
'database' = upper(databasename)
,   'created_on' = replace(replace(left(create_date, 19), 'AM', 'am'), 'PM', 'pm') + ' ' + datename(dw, create_date)
--, 'restored_on' = replace(replace(left(restore_date, 19), 'AM', 'am'), 'PM', 'pm') + ' ' + datename(dw, create_date) ,    'restored_on' =
case
when restore_date is not null then replace(replace(left(restore_date, 19), 'AM', 'am'), 'PM', 'pm') + ' ' + datename(dw, create_date) else ''
end
,   'time_between' =
case
when restore_date is null then ''
else
cast(datediff(second, create_date, restore_date) / 60 / 60 / 24 / 30 / 12 as nvarchar(50)) + ' years, '
+ cast(datediff(second, create_date, restore_date) / 60 / 60 / 24 / 30 % 12 as nvarchar(50)) + ' months, '
+ cast(datediff(second, create_date, restore_date) / 60 / 60 / 24 % 30 as nvarchar(50)) + ' days, '
+ cast(datediff(second, create_date, restore_date) / 60 / 60 % 24 as nvarchar(50)) + ' hours, '
+ cast(datediff(second, create_date, restore_date) / 60 % 60 as nvarchar(50)) + ' minutes '
+ cast(datediff(second, create_date, restore_date) % 60 as nvarchar(50)) + ' seconds ' end
 
from
[last_restored]
where
[rownum] = 1
and databasename not in ('master', 'model', 'msdb', 'tempdb')


```



[![WorksEveryTime](https://forthebadge.com/images/badges/60-percent-of-the-time-works-every-time.svg)](https://shitday.de/)

## Build-Info

| Build Quality | Build History |
|--|--|
|<table><tr><td>[![Build-Status](https://ci.appveyor.com/api/projects/status/pjxh5g91jpbh7t84?svg?style=flat-square)](#)</td></tr><tr><td>[![Coverage](https://coveralls.io/repos/github/tygerbytes/ResourceFitness/badge.svg?style=flat-square)](#)</td></tr><tr><td>[![Nuget](https://img.shields.io/nuget/v/TW.Resfit.Core.svg?style=flat-square)](#)</td></tr></table>|<table><tr><td>[![Build history](https://buildstats.info/appveyor/chart/tygerbytes/resourcefitness)](#)</td></tr></table>|

## Author

- **李聪明的数据库 Lee's Clever Data**
- **Mike的数据库宝典 Mikes Database Collection**
- **李聪明的数据库** "Lee Songming"

[![Gist](https://img.shields.io/badge/Gist-李聪明的数据库-<COLOR>.svg)](https://gist.github.com/congmingshuju)
[![Twitter](https://img.shields.io/badge/Twitter-mike的数据库宝典-<COLOR>.svg)](https://twitter.com/mikesdatawork?lang=en)
[![Wordpress](https://img.shields.io/badge/Wordpress-mike的数据库宝典-<COLOR>.svg)](https://mikesdatawork.wordpress.com/)

---
## License
[![LicenseCCSA](https://img.shields.io/badge/License-CreativeCommonsSA-<COLOR>.svg)](https://creativecommons.org/share-your-work/licensing-types-examples/)

![Lee Songming](https://raw.githubusercontent.com/LiCongMingDeShujuku/git-resources/master/1-clever-data-github.png "李聪明的数据库")

